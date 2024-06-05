local M = {}

local icons   = require('ngpong.utils.icon')
local lazy    = require('ngpong.utils.lazy')
local bouncer = require('ngpong.utils.debounce')
local async   = lazy.require('plenary.async')
local trouble = lazy.require('trouble')
local config  = lazy.require("trouble.config")

local trouble_actions = lazy.access('trouble', 'action')

M.actions = setmetatable({}, {
  __index = function(t, k)
    if k == 'nop' then
      return function() end
    else
      return TOOLS.wrap_f(trouble_actions, k)
    end
  end
})

M.jump = async.void(function()
  VAR.set('DisablePresistCursor', true)

  HELPER.add_jumplist()
  M.actions.jump()
  HELPER.add_jumplist()

  async.util.scheduler()

  HELPER.keep_screen_center()

  VAR.unset('DisablePresistCursor')
end)

M.refresh = bouncer.throttle_leading(1000, function()
  if not M.is_open() then
    return
  end

  local view = trouble.get_view()
  if not view then
    return
  end

  local _refresh = function()
    local source = VAR.get('TroubleSource')

    local title = 'System: Trouble list'
    local msg   = 'Refresh [' .. (TOOLS.isempty(source) and config.options.mode or source) .. '] success.'

    M.actions.refresh()

    vim.schedule(function()
      HELPER.notify_info(msg, title, { icon = icons.lsp_loaded })
    end)
  end

  local mod = config.options.mode

  -- quickfix 比较特殊，项目内部的特殊 trouble list 都是用的这玩意
  if mod == 'quickfix' then
    local source = VAR.get('TroubleSource')

    local parent = view.parent
    if not parent then
      return
    end

    local bufnr = HELPER.get_bufnr(parent)
    if not HELPER.is_buf_valid(bufnr) then
      return
    end

    if source:match('^Git') then
      -- 没有 diff 的文件直接清空刷新
      local hunks = PLGS.gitsigns.api.get_hunks(bufnr)
      if not hunks or not next(hunks) then
        HELPER.clear_qflst()
        _refresh()
      end

      PLGS.gitsigns.api.send_symbols_2_qf(source:match('workspace') and 'all' or bufnr, _refresh)
    elseif source:match('^Mark') then
      PLGS.marks.api.send_marks_2_qf(bufnr, source:match('workspace') ~= nil, _refresh)
    else
      _refresh()
    end
  else
    _refresh()
  end
end)

M.toggle = function(mod, source)
  mod = mod or ''
  source = source or ''

  local success, _ = pcall(vim.cmd, 'TroubleToggle ' .. mod)
  if success and M.is_open() then
    VAR.set('TroubleSource', source)
  end
end

M.open = function(mod, source)
  mod = mod or ''
  source = source or ''

  local success, msg = pcall(vim.cmd, 'Trouble ' .. mod)
  if success then
    VAR.set('TroubleSource', source)
  else
    LOGGER.error(msg)
  end
end

M.close = function(mod)
  mod = mod or ''

  pcall(vim.cmd, 'TroubleClose ' .. mod)
end

M.is_open = function()
  return trouble.is_open()
end

return M

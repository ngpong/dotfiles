local M = {}

local events         = require('ngpong.common.events')
local gitter         = require('ngpong.utils.git')
local lazy           = require('ngpong.utils.lazy')
local async          = lazy.require('plenary.async')
local gitsigns       = lazy.require('gitsigns')
local gitsigns_cache = lazy.require('gitsigns.cache')

local trouble = PLGS.trouble
local e_events = events.e_name

local is_special_winid = function(id, winid)
  local vimw = vim.w[winid]
  local success, result = pcall(getmetatable(vimw).__index, vimw, 'gitsigns_preview')
  return success and result == id
end

local get_win_state = function(id)
  for _, _winid in pairs(HELPER.get_list_winids()) do
    if is_special_winid(id, _winid) then
      return { winid = _winid, bufnr = HELPER.get_bufnr(_winid) }
    end
  end

  return nil
end

local is_open_win = function(id)
  for _, _winid in pairs(HELPER.get_list_winids()) do
    if is_special_winid(id, _winid) then
      return true
    end
  end

  return false
end

M.send_symbols_2_qf = function(target, cb)
  HELPER.clear_qflst()
  gitsigns.setqflist(target, { use_location_list = false, open = false })

  local ok = function ()
    local timespan = 0
    async.run(function()
      while not HELPER.is_has_qflst() do
        if timespan >= 500 then
          break
        end
        timespan = timespan + 5

        async.util.sleep(5)
      end

      if cb then
        cb()
      end
    end)
  end

  local err = function ()
    async.util.scheduler()
    cb()
  end

  local path = HELPER.get_buf_name(HELPER.get_cur_bufnr())
  gitter.if_has_diff_or_untracked(path, TOOLS.wrap_f(ok), TOOLS.wrap_f(err))
end

M.toggle_gitsymbols_list = function(target)
  target = target or 0

  M.send_symbols_2_qf(target, function()
    trouble.api.open('quickfix', 'Git ' .. (target == 0 and 'current buffer' or 'workspace') .. ' symbols')
  end)
end

M.blame_line = async.void(function()
  local opened = is_open_win('blame')

  gitsigns.blame_line()

  local timespan = 0
  while not is_open_win('blame') do
    if timespan >= 1000 then
      return
    end
    timespan = timespan + 100

    async.util.sleep(100)
  end

  local state = get_win_state('blame')

  if not opened and state then
    events.emit(e_events.GITSIGNS_OPEN_POPUP, state)
    events.emit(e_events.BUFFER_ENTER, { buf = state.bufnr })
  end
end)

M.preview_hunk = async.void(function()
  local opened = is_open_win('hunk')

  gitsigns.preview_hunk()

  local timespan = 0
  while not is_open_win('hunk') do
    if timespan >= 1000 then
      return
    end
    timespan = timespan + 100

    async.util.sleep(100)
  end

  local state = get_win_state('hunk')

  if not opened and state then
    events.emit(e_events.GITSIGNS_OPEN_POPUP, state)
    events.emit(e_events.BUFFER_ENTER, { buf = state.bufnr })
  end
end)

M.is_attach = function(bufnr)
  return require('gitsigns.cache').cache[bufnr] ~= nil
end

local open_diffthis = function()
  gitsigns.diffthis()

  for _, _winid in pairs(HELPER.get_list_winids()) do
    local bufnr = HELPER.get_bufnr(_winid)
    if HELPER.get_buf_name(bufnr):match('^gitsigns:') then
      events.emit(e_events.GITSIGNS_OPEN_DIFFTHIS, { bufnr = bufnr })
      break
    end
  end
end
M.toggle_diffthis = function()
  -- close diff base working tree window
  for _, _winid in pairs(HELPER.get_list_winids()) do
    local bufnr   = HELPER.get_bufnr(_winid)
    local bufname = HELPER.get_buf_name(bufnr)

    if bufname:match('^gitsigns:') then
      HELPER.close_win(_winid)
      return
    end
  end

  -- open diffthis if has git status
  local path = HELPER.get_buf_name(HELPER.get_cur_bufnr())
  gitter.if_has_diff_or_untracked(path, TOOLS.wrap_f(open_diffthis))
end

M.get_hunks = function(bufnr)
  local cache = gitsigns_cache.cache[bufnr]

  if cache == nil then
    return nil
  end

  if not next(cache.hunks) then
    return nil
  end

  return cache.hunks
end

return M

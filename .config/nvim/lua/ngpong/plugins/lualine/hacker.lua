local M = {}

local Autocmd = require('ngpong.common.autocmd')
local Lazy    = require('ngpong.utils.lazy')
local Bouncer = Lazy.require('ngpong.utils.debounce')
local Lualine = Lazy.require('lualine')

local this = Plgs.lualine

local __hack_refresh = function()
  local f_refresh = Lualine.refresh

  M.__org_refresh = function(...)
    f_refresh(...)
  end
  M.__bouncer_refresh = Bouncer.throttle_trailing(20, true, vim.schedule_wrap(function(...)
    f_refresh(...)
  end))

  Lualine.refresh = M.__bouncer_refresh

  local org = this.api.refresh
  this.api.refresh = function(args, bouncer)
    if not bouncer then
      org(args, M.__org_refresh)
    else
      org(args, M.__bouncer_refresh)
    end
  end
end

M.setup = function()
  local mode_changing = false

  -- 0x1: 一般情况下，每次 refresh 整体消耗会在 400 ~ 500 ns 左右，但是刷新次数非常频繁
  __hack_refresh()

  -- 0x2: 删除插件原生的刷新事件
  Autocmd.del_augroup_by('name', 'lualine_stl_refresh')
  Autocmd.del_augroup_by('name', 'lualine_tal_refresh')
  Autocmd.del_augroup_by('name', 'lualine_wb_refresh')

  local augroup = Autocmd.new_augroup('lualine')

  -- 0x3: 重新设置 autocmd

  -- 0x4: 使用节流的refresh
  augroup.on({
    'WinEnter',
    'BufWritePost',
    'SessionLoadPost',
    'FileChangedShellPost',
    'VimResized',
    'CmdlineLeave',
    'CursorMoved',
    'CursorMovedI' },
  function(state)
    local filetype = Helper.get_filetype(state.buf)
    if filetype == 'notify' then
      return
    end

    if mode_changing and vim.tbl_contains({ 'CursorMoved', 'CursorMovedI' }, state.event) then
      mode_changing = false
      return
    end

    this.api.refresh({ trigger = 'autocmd' }, true)
  end)
  -- 0x5: 某些事件在满足bounce与trigger='autocmd'任意一项配置的情况下都会出现statusline刷新闪烁的问题
  augroup.on({
    'BufEnter' },
  function(state)
    local filetype = Helper.get_filetype(state.buf)
    if filetype == 'notify' then
      return
    end

    this.api.refresh()
  end)
  -- 0x5: 使用默认的refresh
  augroup.on({ 'ModeChanged' }, function(state)
    mode_changing = true
    this.api.refresh()
  end)
end

return M

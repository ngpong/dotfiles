local M = {}

local Events  = require('ngpong.common.events')
local Autocmd = require('ngpong.common.autocmd')

local e_name = Events.e_name

local unset_autocmds = function()
  Autocmd.del_augroup('gitsigns')
end

local setup_autocmds = function(state)
  local group = Autocmd.new_augroup('gitsigns')

  local old_row, old_col = Helper.get_cursor()

  group.on({ 'CursorMoved', 'CursorMovedI' }, function()
    local cur_row, cur_col = Helper.get_cursor()
    if
      (old_row ~= cur_row or old_col ~= cur_col)
      and Helper.get_cur_winid() ~= state.winid
    then
      Helper.wipeout_buffer(state.bufnr)
      unset_autocmds()
    end
    old_row = cur_row
    old_col = cur_col
  end)

  group.on('WinClosed', function()
    Helper.wipeout_buffer(state.bufnr)
    unset_autocmds()
  end, tostring(state.winid))
end

M.setup = function()
  Events.rg(e_name.GITSIGNS_OPEN_POPUP, function(state)
    setup_autocmds(state)
  end)
end

return M

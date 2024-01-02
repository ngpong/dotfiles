local M = {}

local events  = require('ngpong.common.events')
local autocmd = require('ngpong.common.autocmd')

local e_events = events.e_name

local unset_autocmds = function()
  autocmd.del_augroup('gitsigns')
end

local setup_autocmds = function(state)
  local group_id = autocmd.new_augroup('gitsigns')

  local old_row, old_col = HELPER.get_cursor()

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    group = group_id,
    callback = function()
      local cur_row, cur_col = HELPER.get_cursor()
      if
        (old_row ~= cur_row or old_col ~= cur_col)
        and HELPER.get_cur_winid() ~= state.winid
      then
        HELPER.wipeout_buffer(state.bufnr)
        unset_autocmds()
      end

      old_row = cur_row
      old_col = cur_col
    end,
  })

  vim.api.nvim_create_autocmd('WinClosed', {
    pattern = tostring(state.winid),
    group = group_id,
    callback = function()
      HELPER.wipeout_buffer(state.bufnr)
      unset_autocmds()
    end,
  })
end

M.setup = function()
  events.rg(e_events.GITSIGNS_OPEN_POPUP, function(state)
    setup_autocmds(state)
  end)
end

return M
local M = {}

local etypes = vim.__event.types

local group = vim.__autocmd.augroup("gitsigns")

local unset_autocmds = function()
  group:del()
end

local setup_autocmds = function(state)
  local old_row, old_col = vim.__cursor.get()

  group:on({ "CursorMoved", "CursorMovedI" }, function()
    local cur_row, cur_col = vim.__cursor.get()
    if
      (old_row ~= cur_row or old_col ~= cur_col)
      and vim.__win.current() ~= state.winid
    then
      vim.__buf.wipeout(state.bufnr)
      unset_autocmds()
    end
    old_row = cur_row
    old_col = cur_col
  end)

  group:on("WinClosed", function()
    vim.__buf.wipeout(state.bufnr)
    unset_autocmds()
  end, { pattern = tostring(state.winid) })
end

M.setup = function()
  vim.__event.rg(etypes.GITSIGNS_OPEN_POPUP, function(state)
    setup_autocmds(state)
  end)
end

return M

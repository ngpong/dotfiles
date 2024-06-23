local M = {}

-- stylua: ignore start
local Lazy   = require('ngpong.utils.lazy')
local Cmp    = Lazy.require('cmp')
-- stylua: ignore end


M.has_words_before = function ()
  local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

M.is_visible = function()
  return Cmp.core.view:visible() or vim.fn.pumvisible() == 1
end

M.is_docvisible = function ()
  return cmp.core.view.docs_view:visible()
end

return M

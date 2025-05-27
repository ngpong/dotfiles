local M = {}

-- stylua: ignore start
local Cmp    = vim.__lazy.require("cmp")
-- stylua: ignore end

M.has_words_before = function ()
  local line, col = vim.__cursor.get()
  return col ~= 0 and vim.__fs.getline(0, line, ""):sub(col, col):match("%s") == nil
end

M.is_visible = function()
  return Cmp.core.view:visible() or vim.fn.pumvisible() == 1
end

M.is_docvisible = function ()
  return Cmp.core.view.docs_view:visible()
end

return M

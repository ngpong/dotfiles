local M = {}

M.setup = function()
  vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = vim.__color.dark4 })
end

return M

local M = {}

M.setup = function()
  vim.api.nvim_set_hl(0, "WhichKey", { fg = vim.__color.bright_aqua, bold = true })
  vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = vim.__color.dark0_soft })
  vim.api.nvim_set_hl(0, "WhichKeyDesc", { fg = vim.__color.light1, italic = true, bold = true })
  vim.api.nvim_set_hl(0, "WhichKeyGroup", { fg = vim.__color.bright_red, bold = true })
  -- vim.api.nvim_set_hl(0, "WhichKeyBorder", { bg = vim.__color.dark0_soft, fg = vim.__color.dark3 })
end

return M

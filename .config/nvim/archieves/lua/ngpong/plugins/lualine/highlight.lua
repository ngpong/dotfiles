local M = {}

M.setup = function()
  vim.api.nvim_set_hl(0, "StatusLine", { bg = vim.__color.dark1 })
  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = vim.__color.dark1 })
  vim.api.nvim_set_hl(0, "StatusLineTermNC", { bg = vim.__color.dark1 })
  vim.api.nvim_set_hl(0, "LuaLineDiffChange", { fg = vim.__color.bright_yellow })
end

return M

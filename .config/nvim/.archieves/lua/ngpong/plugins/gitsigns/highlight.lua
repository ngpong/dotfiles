local M = {}

M.setup = function()
  vim.api.nvim_set_hl(0, "GitSignsUntrackedNr", { fg = vim.__color.bright_blue })
  vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = vim.__color.bright_blue })
  vim.api.nvim_set_hl(0, "GitSignsChange", { fg = vim.__color.bright_yellow })
  vim.api.nvim_set_hl(0, "GitSignsChangeNr", { fg = vim.__color.bright_yellow })
end

return M

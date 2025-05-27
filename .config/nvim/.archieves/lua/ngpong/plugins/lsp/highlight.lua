local M = {}

M.setup = function()
  vim.api.nvim_set_hl(0, "LspInfoBorder", { fg = vim.__color.light1 })

  vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = vim.__color.bright_red })
  vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = vim.__color.bright_yellow })
  vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = vim.__color.bright_blue })
  vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = vim.__color.bright_aqua })
end

return M

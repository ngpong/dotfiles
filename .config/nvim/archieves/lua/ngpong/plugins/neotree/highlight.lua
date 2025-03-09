local M = {}

M.setup = function()
  vim.api.nvim_set_hl(0, "NeoTreeFileIcon", { link = "DevIconDefault" })
  vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = vim.__color.bright_blue, bold = true })
  vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = vim.__color.bright_yellow })
  vim.api.nvim_set_hl(0, "NeoTreeDiagnosticSignWarn", { fg = vim.__color.bright_yellow })
  vim.api.nvim_set_hl(0, "NeoTreeDiagnosticSignError", { fg = vim.__color.bright_red })
  vim.api.nvim_set_hl(0, "NeoTreeDiagnosticSignHint", { fg = vim.__color.bright_aqua })
  vim.api.nvim_set_hl(0, "NeoTreeDiagnosticSignInfo", { fg = vim.__color.bright_blue })
  vim.api.nvim_set_hl(0, "NeoTreeFloatTitle", { fg = vim.__color.bright_green, italic = true })
  vim.api.nvim_set_hl(0, "NeoTreeRootName", { fg = vim.__color.bright_blue })
  vim.api.nvim_set_hl(0, "NeoTreeDotfile", { link = "Comment" })
  vim.api.nvim_set_hl(0, "NeoTreeMessage", { link = "Comment" })
  -- vim.api.nvim_set_hl(0, "NeoTreeGitConflict", { italic = false, bold = true, fg = "#b16283" })
  -- vim.api.nvim_set_hl(0, "NeoTreeGitUnstaged", { italic = false, bold = true, fg = "#e87d05" })
  -- vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { italic = false, fg = "#e87d05" })
end

return M

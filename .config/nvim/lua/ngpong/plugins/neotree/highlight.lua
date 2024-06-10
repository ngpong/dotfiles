local M = {}

local colors = Plgs.colorscheme.colors

M.setup = function()
  vim.api.nvim_set_hl(0, 'NeoTreeFileIcon', { link = 'DevIconDefault' })
  vim.api.nvim_set_hl(0, 'NeoTreeDirectoryIcon', { fg = colors.bright_yellow })
  vim.api.nvim_set_hl(0, 'NeoTreeDiagnosticSignWarn', { fg = colors.bright_yellow })
  vim.api.nvim_set_hl(0, 'NeoTreeDiagnosticSignError', { fg = colors.bright_red })
  vim.api.nvim_set_hl(0, 'NeoTreeDiagnosticSignHint', { fg = colors.bright_aqua })
  vim.api.nvim_set_hl(0, 'NeoTreeDiagnosticSignInfo', { fg = colors.bright_blue })
  vim.api.nvim_set_hl(0, 'NeoTreeFloatTitle', { fg = colors.bright_green, italic = true })
  -- vim.api.nvim_set_hl(0, 'NeoTreeGitConflict', { italic = false, bold = true, fg = '#b16283' })
  -- vim.api.nvim_set_hl(0, 'NeoTreeGitUnstaged', { italic = false, bold = true, fg = '#e87d05' })
  -- vim.api.nvim_set_hl(0, 'NeoTreeGitUntracked', { italic = false, fg = '#e87d05' })
end

return M

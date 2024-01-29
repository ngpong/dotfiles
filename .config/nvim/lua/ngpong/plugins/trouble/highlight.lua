local M = {}

local colors = PLGS.colorscheme.colors

M.setup = function()
  vim.api.nvim_set_hl(0, 'TroubleNormal', { bg = colors.dark0_soft })
  vim.api.nvim_set_hl(0, 'TroubleIndent', { fg = colors.dark4 })
  vim.api.nvim_set_hl(0, 'TroubleFoldIcon', { fg = colors.dark4 })
  vim.api.nvim_set_hl(0, 'TroubleSignOther', { fg = colors.bright_green })
  vim.api.nvim_set_hl(0, 'TroubleSignHint', { fg = colors.bright_aqua })
  vim.api.nvim_set_hl(0, 'TroubleSignError', { fg = colors.bright_red })
  vim.api.nvim_set_hl(0, 'TroubleSignWarning', { fg = colors.bright_yellow })
  vim.api.nvim_set_hl(0, 'TroubleSignInformation', { fg = colors.bright_green })
  vim.api.nvim_set_hl(0, 'TroubleCount', { fg = colors.bright_orange })
end

return M

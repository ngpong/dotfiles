local M = {}

local colors = PLGS.colorscheme.colors

M.setup = function()
  vim.api.nvim_set_hl(0, 'TroubleNormal', { bg = colors.dark0_soft })
  vim.api.nvim_set_hl(0, 'TroubleIndent', { fg = colors.dark4 })
  vim.api.nvim_set_hl(0, 'TroubleFoldIcon', { fg = colors.dark4 })
  vim.api.nvim_set_hl(0, 'TroubleSignOther', { fg = colors.bright_green })
  vim.api.nvim_set_hl(0, 'TroubleSignHint', { link = 'DiagnosticHint' })
  vim.api.nvim_set_hl(0, 'TroubleSignError', { link = 'DiagnosticError' })
  vim.api.nvim_set_hl(0, 'TroubleSignWarning', { link = 'DiagnosticWarn' })
  vim.api.nvim_set_hl(0, 'TroubleSignInformation', { link = 'DiagnosticInfo' })
  vim.api.nvim_set_hl(0, 'TroubleCount', { fg = colors.bright_orange })
  vim.api.nvim_set_hl(0, 'TroubleTextHint', { fg = colors.light1 })
  vim.api.nvim_set_hl(0, 'TroubleTextInformation', { fg = colors.light1 })
  vim.api.nvim_set_hl(0, 'TroubleTextWarning', { fg = colors.light1 })
  vim.api.nvim_set_hl(0, 'TroubleTextError', { fg = colors.light1 })
end

return M

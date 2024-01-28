local M = {}

local colors = PLGS.colorscheme.colors

M.setup = function()
  vim.api.nvim_set_hl(0, 'TroubleNormal', { bg = colors.dark0_soft })
  vim.api.nvim_set_hl(0, 'TroubleIndent', { fg = colors.dark4 })
  vim.api.nvim_set_hl(0, 'TroubleFoldIcon', { fg = colors.dark4 })
  vim.api.nvim_set_hl(0, 'TroubleSignOther', { fg = colors.bright_green })
  vim.api.nvim_set_hl(0, 'TroubleCount', { fg = colors.bright_orange })
end

return M

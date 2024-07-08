local M = {}

local colors = Plgs.colorscheme.colors

M.setup = function()
  vim.api.nvim_set_hl(0, 'WhichKey', { fg = colors.bright_aqua, bold = true })
  vim.api.nvim_set_hl(0, 'WhichKeyFloat', { bg = colors.dark0_soft })
  vim.api.nvim_set_hl(0, 'WhichKeyDesc', { fg = colors.light1, italic = true, bold = true })
  vim.api.nvim_set_hl(0, 'WhichKeyGroup', { fg = colors.bright_red, bold = true })
  vim.api.nvim_set_hl(0, 'WhichKeyBorder', { bg = colors.dark0_soft, fg = colors.dark3 })
end

return M

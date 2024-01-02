local M = {}

local colors = PLGS.colorscheme.colors

M.setup = function()
  vim.api.nvim_set_hl(0, 'WhichKey', { fg = colors.bright_green, italic = true, bold = true })
end

return M
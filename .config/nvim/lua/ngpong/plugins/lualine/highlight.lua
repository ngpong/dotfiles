local M = {}

local colors = Plgs.colorscheme.colors

M.setup = function()
  vim.api.nvim_set_hl(0, 'StatusLine', { bg = colors.dark1 })
  vim.api.nvim_set_hl(0, 'LuaLineDiffChange', { fg = colors.bright_yellow })
end

return M

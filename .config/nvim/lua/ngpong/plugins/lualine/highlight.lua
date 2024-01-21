local M = {}

local colors = PLGS.colorscheme.colors

M.setup = function()
  vim.api.nvim_set_hl(0, 'StatusLine', { bg = colors.dark1 })
end

return M

local M = {}

local colors = Plgs.colorscheme.colors

M.setup = function()
  vim.api.nvim_set_hl(0, 'MultiCursor', { bg = colors.bright_blue, fg = colors.dark1 })
  vim.api.nvim_set_hl(0, 'MultiCursorMain', { bg = colors.bright_blue, fg = colors.dark1 })
end

return M
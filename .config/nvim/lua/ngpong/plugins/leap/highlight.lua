local M = {}

M.setup = function()
  vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' }) -- link = 'Comment' fg = colors.gray
  vim.api.nvim_set_hl(0, 'LeapMatch', { fg = 'white', bold = true, underline = true, nocombine = true, })
  vim.api.nvim_set_hl(0, 'LeapLabelPrimary', { link = 'Search' })
end

return M

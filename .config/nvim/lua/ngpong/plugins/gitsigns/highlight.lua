local M = {}

M.setup = function()
  vim.api.nvim_set_hl(0, 'GitSignsUntrackedNr', { link = 'GruvboxBlue' })
  vim.api.nvim_set_hl(0, 'GitSignsUntracked', { link = 'GruvboxBlue' })
end

return M

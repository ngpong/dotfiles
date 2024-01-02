local M = {}

M.setup = function()
  vim.api.nvim_set_hl(0, 'LspInfoBorder', { link = 'GruvboxFg1' })
end

return M
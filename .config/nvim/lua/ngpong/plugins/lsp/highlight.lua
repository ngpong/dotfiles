local M = {}

M.setup = function()
  vim.api.nvim_set_hl(0, 'LspInfoBorder', { link = 'GruvboxFg1' })

  vim.api.nvim_set_hl(0, 'DiagnosticSignError', { link = 'GruvboxRed' })
  vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { link = 'GruvboxYellow' })
  vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { link = 'GruvboxBlue' })
  vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { link = 'GruvboxAqua' })
end

return M

local M = {}

M.setup = function()
  vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { link = 'GruvboxBg4' })
end

return M

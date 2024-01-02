local M = {}

M.setup = function()
  vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { link = 'NonText' })
end

return M
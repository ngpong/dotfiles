local M = {}

local etypes = vim.__event.types

M.setup = function()
  vim.__event.rg(etypes.FILE_TYPE, function(state)
    if vim.__filter.contain_fts(vim.__buf.filetype(state.buf)) then
      vim.b.miniindentscope_disable = true
    end
  end)
end

return M

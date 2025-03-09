local M = {}

local etypes = vim.__event.types

M.setup = function()
  vim.__event.rg(etypes.FILE_TYPE, function(state)
    if vim.__filter.contain_fts(state.match) then
      vim.b.minicursorword_disable = true
    else
      vim.b.minicursorword_disable = false
    end
  end)

  require("mini.cursorword").setup({
    delay = 375,
  })
end

return M

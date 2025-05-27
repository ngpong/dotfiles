local M = {}

M.setup = function()
  vim.api.nvim_set_hl(0, "MiniCursorword", { italic = true, bold = true, underline = true })
  vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { italic = true, bold = true, underline = true })
end

return M

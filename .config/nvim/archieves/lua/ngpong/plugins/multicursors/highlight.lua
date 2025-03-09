local M = {}

M.setup = function()
  vim.api.nvim_set_hl(0, "MultiCursor", { bg = vim.__color.bright_blue, fg = vim.__color.dark1 })
  vim.api.nvim_set_hl(0, "MultiCursorMain", { bg = vim.__color.bright_blue, fg = vim.__color.dark1 })
end

return M
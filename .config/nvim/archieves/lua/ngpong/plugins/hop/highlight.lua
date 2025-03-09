local M = {}

M.setup = function()
  vim.api.nvim_set_hl(0, "Question", { fg = vim.__color.light1 })
  vim.api.nvim_set_hl(0, "HopNextKey", { bg = vim.__color.bright_red, fg = vim.__color.dark0, bold = true, italic = true, })
  vim.api.nvim_set_hl(0, "HopNextKey1", { bg = vim.__color.neutral_blue, fg = vim.__color.dark0, bold = true, italic = true, })
  vim.api.nvim_set_hl(0, "HopNextKey2", { bg = vim.__color.bright_blue, fg = vim.__color.dark0, bold = true, italic = true, })
  -- vim.api.nvim_set_hl(0, "HopUnmatched", { link = "Comment" })
  -- vim.api.nvim_set_hl(0, "HopCursor", { reverse = true })
  vim.api.nvim_set_hl(0, "HopPreview", { link = "Search" })
end

return M

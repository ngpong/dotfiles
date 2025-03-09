local M = {}

M.setup = function()
  -- 该条 highlight 被我在 makrs.nvim 源码里面手动删除了
  -- vim.api.nvim_set_hl(0, "MarkSignNumHL", { bg = vim.__color.dark0_soft, fg = vim.__color.bright_yellow })

  vim.api.nvim_set_hl(0, "MarkSignHL", { fg = vim.__color.bright_yellow, italic = true })
end

return M

local M = {}

local colors = Plgs.colorscheme.colors

M.setup = function()
  -- 该条 highlight 被我在 makrs.nvim 源码里面手动删除了
  -- vim.api.nvim_set_hl(0, 'MarkSignNumHL', { bg = colors.dark0_soft, fg = colors.bright_yellow })

  vim.api.nvim_set_hl(0, 'MarkSignHL', { fg = colors.bright_red, bg = colors.bright_yellow, italic = true })
end

return M

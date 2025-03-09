local M = {}

local setup = function()
  -- https://www.reddit.com/r/neovim/comments/xcsatv/how_can_i_configure_telescope_to_look_like_this/
  vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = vim.__color.bright_green, italic = true, bold = true })
  vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = vim.__color.bright_green, italic = true, bold = true })
  vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = vim.__color.bright_red, italic = true, bold = true })
  vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = vim.__color.dark2 })
  vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { bg = vim.__color.dark2, fg = vim.__color.light1 })
  vim.api.nvim_set_hl(0, "TelescopeMultiSelection", { fg = vim.__color.light1, bg = vim.__color.dark2, bold = true, italic = true })

  vim.api.nvim_set_hl(0, "TelescopeResultsDiffUntracked", { fg = vim.__color.bright_orange })
  vim.api.nvim_set_hl(0, "TelescopeResultsDiffAdd", { fg = vim.__color.bright_green })
  vim.api.nvim_set_hl(0, "TelescopeResultsDiffchange", { fg = vim.__color.bright_yellow })
  vim.api.nvim_set_hl(0, "TelescopeResultsDiffDelete", { fg = vim.__color.bright_red })
  -- vim.api.nvim_set_hl(0, "TelescopeResultsDiffuntracked", { fg = vim.__color.bright_red })

  -- vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = vim.__color.gray })
  -- vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = vim.__color.gray })
  -- vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = vim.__color.gray })
  -- vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = vim.__color.gray })

  -- vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = vim.__color.bright_green, italic = true, bold = true })
  -- vim.api.nvim_set_hl(0, "TelescopeMultiSelection", { fg = vim.__color.bright_red })
  -- vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = vim.__color.bright_blue, italic = true, bold = true })
end

M.setup = setup

return M

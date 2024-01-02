local M = {}

local colors = PLGS.colorscheme.colors

local setup = function()
  -- https://www.reddit.com/r/neovim/comments/xcsatv/how_can_i_configure_telescope_to_look_like_this/
  vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { fg = colors.bright_green, italic = true, bold = true })
  vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { fg = colors.bright_green, italic = true, bold = true })
  vim.api.nvim_set_hl(0, 'TelescopeMatching', { fg = colors.bright_green, italic = true, bold = true })
  -- vim.api.nvim_set_hl(0, 'TelescopeSelection', { fg = colors.bright_blue, italic = true, bold = true })
end

M.setup = setup

return M
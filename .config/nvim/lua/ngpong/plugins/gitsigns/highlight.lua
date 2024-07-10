local M = {}

local colors = Plgs.colorscheme.colors

M.setup = function()
  vim.api.nvim_set_hl(0, 'GitSignsUntrackedNr', { link = 'GruvboxBlue' })
  vim.api.nvim_set_hl(0, 'GitSignsUntracked', { link = 'GruvboxBlue' })
  vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = colors.bright_yellow })
  vim.api.nvim_set_hl(0, 'GitSignsChangeNr', { fg = colors.bright_yellow })
  end

return M

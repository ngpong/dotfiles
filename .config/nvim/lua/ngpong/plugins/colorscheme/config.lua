local M = {}

local Lazy    = require('ngpong.utils.lazy')
local Gruvbox = Lazy.require('gruvbox')

-- dark = {
--   bg0 = p.dark0,
--   bg1 = p.dark1,
--   bg2 = p.dark2,
--   bg3 = p.dark3,
--   bg4 = p.dark4,
--   fg0 = p.light0,
--   fg1 = p.light1,
--   fg2 = p.light2,
--   fg3 = p.light3,
--   fg4 = p.light4,
--   red = p.bright_red,
--   green = p.bright_green,
--   yellow = p.bright_yellow,
--   blue = p.bright_blue,
--   purple = p.bright_purple,
--   aqua = p.bright_aqua,
--   orange = p.bright_orange,
--   neutral_red = p.neutral_red,
--   neutral_green = p.neutral_green,
--   neutral_yellow = p.neutral_yellow,
--   neutral_blue = p.neutral_blue,
--   neutral_purple = p.neutral_purple,
--   neutral_aqua = p.neutral_aqua,
--   dark_red = p.dark_red,
--   dark_green = p.dark_green,
--   dark_aqua = p.dark_aqua,
--   gray = p.gray,
-- }

M.setup = function()
  Gruvbox.setup({
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
      strings = true,
      comments = true,
      operators = false,
      folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true,
    contrast = 'soft',
    palette_overrides = {},
    dim_inactive = false,
    overrides = {
      NormalFloat = { bg = Gruvbox.palette.dark0_soft },
      FloatTitle = { fg = Gruvbox.palette.bright_green, italic = true },
      SignColumn = { bg = Gruvbox.palette.dark0_soft, italic = true },
      DevIconSharedObject = { fg = Gruvbox.palette.dark4 },
      FloatBorder = { fg = Gruvbox.palette.light1 },
      -- DiagnosticInfo = { link = 'GruvboxGreen' },
      ['@string'] = { fg = Gruvbox.palette.bright_green },
      ['@operator'] = { link = 'GruvboxFg4' },
      ['@operators'] = { link = 'GruvboxFg2' },
      ['@parameter'] = { link = 'GruvboxFg2' },
      ['@conditional'] = { fg = Gruvbox.palette.bright_red, italic = true },
      ['@lsp.type.parameter'] = { link = 'GruvboxFg1' },
      ['@lsp.type.operator'] = { fg = nil },
      ['@punctuation.bracket'] = { link = 'GruvboxFg2' },
      ['@punctuation.delimiter'] = { link = 'GruvboxFg2' },
      ['@type.qualifier'] = { fg = Gruvbox.palette.bright_red, italic = true },
      ['@keyword.return'] = { fg = Gruvbox.palette.bright_red, italic = true },
      ['@keyword.operator'] = { fg = Gruvbox.palette.bright_red, italic = true },
      ['@keyword.repeat'] = { fg = Gruvbox.palette.bright_red, italic = true },
      ['@keyword.conditional'] = { fg = Gruvbox.palette.bright_red, italic = true },
      ['@keyword.conditional.ternary'] = { link = 'GruvboxFg4' },
      ['@keyword'] = { fg = Gruvbox.palette.bright_red, italic = true },
      ['@repeat'] = { fg = Gruvbox.palette.bright_red, italic = true },
      ['@namespace'] = { fg = Gruvbox.palette.bright_green, italic = true },
    },
    transparent_mode = false,
  })

  vim.go.background = 'dark'
  vim.cmd.colorscheme('gruvbox')
end

return M

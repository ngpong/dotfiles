local M = {}

local lazy    = require('ngpong.utils.lazy')
local gruvbox = lazy.require('gruvbox')

M.setup = function()
  gruvbox.setup {
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
      NormalFloat = { bg = gruvbox.palette.dark0_soft, blend = 0 },
      FloatTitle = { fg = gruvbox.palette.bright_green, italic = true },
      SignColumn = { bg = gruvbox.palette.dark0_soft, italic = true },
      -- FloatBorder = { fg = gruvbox.palette.dark2_soft, blend = 100 },
      -- DiagnosticInfo = { link = 'GruvboxGreen' },
      ['@operator'] = { link = 'GruvboxFg4' },
      ['@operators'] = { link = 'GruvboxFg2' },
      ['@parameter'] = { link = 'GruvboxFg2' },
      ['@conditional'] = { fg = gruvbox.palette.bright_red, italic = true },
      ['@lsp.type.parameter'] = { link = 'GruvboxFg1' },
      ['@lsp.type.operator'] = { fg = nil },
      ['@punctuation.bracket'] = { link = 'GruvboxFg2' },
      ['@punctuation.delimiter'] = { link = 'GruvboxFg2' },
      ['@type.qualifier'] = { fg = gruvbox.palette.bright_red, italic = true },
      ['@keyword.return']  = { fg = gruvbox.palette.bright_red, italic = true },
      ['@keyword.operator']  = { fg = gruvbox.palette.bright_red, italic = true },
      ['@keyword.conditional.ternary']  = { link = 'GruvboxFg4' },
      ['@keyword'] = { fg = gruvbox.palette.bright_red, italic = true },
      ['@repeat'] = { fg = gruvbox.palette.bright_red, italic = true },
      ['@namespace'] = { fg = gruvbox.palette.bright_green, italic = true }
    },
    transparent_mode = false,
  }

  vim.go.background = 'dark'
  vim.cmd.colorscheme('gruvbox')
end

return M

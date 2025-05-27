return {
  "ellisonleao/gruvbox.nvim",
  main = "gruvbox",
  priority = 10000,
  opts = {
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
      strings = true,
      comments = false,
      operators = false,
      folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true,
    contrast = "",
    palette_overrides = {},
    dim_inactive = false,
    transparent_mode = false,
    overrides = {
      LazyButton = { bg = vim.__color.dark4, fg = vim.__color.dark0 },
      LazyButtonActive = { bg = vim.__color.bright_blue, fg = vim.__color.dark0, bold = true },
      LazyH1 = { bg = vim.__color.bright_blue, fg = vim.__color.dark0, bold = true },
      LazySpecial = { fg = vim.__color.bright_orange },
      LazyBackdrop = { link = "Normal" },

      WinSeparator = { fg = "#222222" },
      VertSplit = { fg = vim.__color.dark0_hard },

      NormalFloat = { bg = vim.__color.dark0_soft, fg = vim.__color.light1 },
      FloatBorder = { fg = vim.__color.dark0_soft, bg = vim.__color.dark0_soft },
      FloatTitle = { bg = vim.__color.bright_blue, fg = vim.__color.dark0_hard, bold = true },
      FloatEndOfBuffer = { bg = vim.__color.dark0_soft, fg = vim.__color.dark0_soft },

      CursorLineNr = { fg = vim.__color.bright_yellow, bg = vim.__color.dark0 },
      CursorLine = { bg = "#302e2e" },
      CursorLineDark = { bg = "#242424" },
      Visual = { bg = "#384539" },

      SignColumn = { bg = vim.__color.dark0 },

      IndentGuide = { fg = "#3f3b38" },

      WinBar = { fg = vim.__color.light2 },
      WinBarNC = { link = "WinBar" },

      -- Directory = { fg = vim.__color.light2 },
      DirectoryIcon = { fg = "#c09553" },

      -- CurSearch = { link = "Search" },
      -- IncSearch = { link = "Search" },

      StatusLine = { bg = vim.__color.dark0_soft },
      StatusLineNC = { bg = vim.__color.dark0_soft },
      StatusLineTermNC = { bg = vim.__color.dark0_soft },

      cStatement = { fg = vim.__color.bright_red, italic = true },
      cppStatement = { fg = vim.__color.bright_red, italic = true },
      cConditional = { fg = vim.__color.bright_red, italic = true },
      cRepeat = { fg = vim.__color.bright_red, italic = true },
      cLabel = { fg = vim.__color.bright_red, italic = true },
    }
  },
  config = function(_, opts)
    require("gruvbox").setup(opts)
    vim.go.background = "dark"
    vim.cmd.colorscheme("gruvbox")
  end
}

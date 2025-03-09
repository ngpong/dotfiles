return {
  "ellisonleao/gruvbox.nvim",
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
      WinSeparator = { fg = vim.__color.dark0_hard },
      VertSplit = { fg = vim.__color.dark0_hard },

      NormalFloat = { bg = vim.__color.dark1, fg = vim.__color.light1 },
      FloatBorder = { bg = vim.__color.dark1 },
      FloatTitle = { fg = vim.__color.dark0_hard, bg = vim.__color.bright_aqua, italic = true, bold = true },

      CursorLineNr = { fg = vim.__color.bright_yellow, bg = vim.__color.dark0 },
      CursorLine = { bg = "#302e2e" },

      SignColumn = { bg = vim.__color.dark0 },

      IndentGuide = { fg = "#3f3b38" },

      WinBar = { fg = vim.__color.light2 },
      WinBarNC = { link = "WinBar" },

      -- Directory = { fg = vim.__color.light2 },
      DirectoryIcon = { fg = "#c09553" },

      -- CurSearch = { link = "Search" },
      -- IncSearch = { link = "Search" },

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
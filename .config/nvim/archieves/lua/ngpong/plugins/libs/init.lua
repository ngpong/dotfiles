return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      override = {
        zsh = {
          icon = vim.__icons.terminal,
          color = "#6d8086",
          cterm_color = "66",
          name = "Zsh"
        }
      },
      override_by_filename = {
        [".zshrc"] = {
          icon = vim.__icons.terminal,
          color = "#6d8086",
          cterm_color = "66",
          name = "Zsh"
        }
      }
    }
  },
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
  {
    "s1n7ax/nvim-window-picker",
    lazy = true,
    opts = {
      selection_chars = "HJKLABCDEFGIMNOPQRSTUVWXYZ",
      picker_config = {
        statusline_winbar_picker = {
          use_winbar = "always",
        },
      },
      show_prompt = false,
      filter_rules = {
        autoselect_one = false,
        include_current_win = false,
        bo = {
          filetype = { "neo-tree", "neo-tree-popup", "notify", "fidget" },
          buftype = { "terminal", "quickfix" },
        },
      },
      highlights = {
        winbar = {
            focused = {
                fg = "#282828",
                bg = "#b8bb26",
                bold = true,
            },
            unfocused = {
                fg = "#282828",
                bg = "#b8bb26",
                bold = true,
            },
        },
    },
    }
  },
}

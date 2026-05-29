return {
  {
    "nvim-tree/nvim-web-devicons",
    main = "nvim-web-devicons",
    lazy = true,
    first = true,
    init = function()
      vim.__webicons = vim.__lazy.require("nvim-web-devicons")
    end,
    opts = {
      override = {
        zsh = {
          icon = "",
          color = "#6d8086",
          name = "Zsh"
        },
        default_icon = {
          icon = vim.__icons.file_2,
          color = vim.__color.light1,
          name = "Default",
        }
      },
      override_by_filename = {
        [".zshrc"] = {
          icon = "",
          color = "#6d8086",
          name = "Zsh"
        },
        [".clangd"] = {
          icon = "",
          color = "#526064",
          name = "ClangConfig"
        },
        [".ignore"] = {
          icon = "",
          color = "#526064",
          name = "IgnoreFile"
        },
        ["Jenkinsfile"] = {
          icon = "",
          color = "#a89984",
          name = "JenkinsFile"
        },
      },
      override_by_extension = {
        ["so"] = {
          icon = "",
          color = vim.__color.dark4,
          name = "SharedObject"
        },
        ["a"] = {
          icon = "",
          color = vim.__color.dark4,
          name = "StaticLibraryArchive"
        },
        ["dll"] = {
          icon = "",
          color = vim.__color.dark4,
          name = "Dll"
        },
        ["lib"] = {
          icon = "",
          color = vim.__color.dark4,
          name = "Lib"
        }
      },
      override_by_operating_system = {
        ["ubuntu"] = {
          icon = "󰕈",
          color = "#DD4814",
          cterm_color = "196",
          name = "Ubuntu"
        },
      },
      override_by_filetype = {
        lazy = {
          icon = "󰒲",
          color = vim.__color.bright_blue,
          name = "Lazy"
        },
        help = {
          icon = "󰘥",
          color = vim.__color.bright_purple,
          name = "Help"
        },
        trouble = {
          icon = "󰝖",
          color = vim.__color.bright_green,
          name = "Trouble"
        },
        qf = {
          icon = "󰝖",
          color = vim.__color.bright_green,
          name = "Quickfix"
        }
      }
    },
    config = function(_, opts)
      local override_by_filetype = opts.override_by_filetype
      opts.override_by_filetype = nil

      local override_fts = {}
      for k, v in pairs(override_by_filetype) do
        override_fts[k] = k opts.override[k] = v
      end
      vim.__webicons.set_icon_by_filetype(override_fts)

      vim.__webicons.setup(opts)
    end
  },
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_install = {
        { parse = "bash", ft = "sh" }
      }
    }
  },
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "bash-language-server" } }
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        bashls = {
          cmd = {
            "bash-language-server",
            "start",
          },
          single_file_support = true,
          filetypes = { "sh" },
          settings = {
            bashIde = {
              globPattern = "*@(.sh|.inc|.bash|.command)",
              shellcheckArguments = {
                "--exclude=SC2034",
              }
            }
          },
        },
      },
    },
  },
}

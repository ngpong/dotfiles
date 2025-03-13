return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_install = { "yaml" }
    }
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        yamlls = {
          cmd = {
            "yaml-language-server",
            "--stdio"
          },
          single_file_support = true,
          settings = {
            redhat = {
              telemetry = {
                enabled = false
              }
            },
            yaml = {
              format = {
                enable = false,
              },
              -- schemaStore = {
              --   enable = true
              -- },
              http = {
                proxy = "http://127.0.0.1:7890",
              },
            },
          },
          filetypes = { "yaml", "yaml.docker-compose" },
        },
      },
    },
  },
}
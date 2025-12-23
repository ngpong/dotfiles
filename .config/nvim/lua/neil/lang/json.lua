return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_install = { "json" }
    }
  },
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "json-lsp" } }
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        jsonls = {
          cmd = {
            "vscode-json-language-server",
            "--stdio"
          },
          single_file_support = true,
          init_options = {
            provideFormatter = false
          },
          filetypes = { "json", "jsonc" },
        },
      },
    },
  },
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_install = {
        { parse = "python", ft = "python" },
      }
    }
  },
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "pyright" } }
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        pyright = {},
      },
    },
  },
}
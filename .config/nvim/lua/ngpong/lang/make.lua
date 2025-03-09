return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_install = {
        { parse = "cmake", ft = "cmake" },
        { parse = "make", ft = { "automake", "make" } },
      }
    },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        cmake = {
          cmd = {
            "cmake-language-server",
          },
          single_file_support = true,
          init_options = { buildDirectory = "build" },
          filetypes = { "cmake" },
        },
        autotools_ls = {
          cmd = {
            "autotools-language-server",
          },
          filetypes = { "config", "automake", "make" },
          single_file_support = true,
        }
      },
    },
  },
}
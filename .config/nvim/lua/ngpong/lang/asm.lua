return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_install = {
        { parse = "asm", ft = { "asm", "vmasm", "nasm" } }
      }
    },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        asm_lsp = {
          cmd = {
            "asm-lsp",
          },
          filetypes = { "asm", "vmasm", "nasm" },
        }
      },
    },
  },
}
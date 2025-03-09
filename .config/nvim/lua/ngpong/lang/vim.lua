return {
  "nvim-treesitter/nvim-treesitter",
  optional = true,
  opts = {
    ensure_install = {
      { parse = "vim", ft = "vim" },
      { parse = "vimdoc", ft = { "checkhealth", "help" } },
      { parse = "query", ft = "query" },
      { parse = "regex", ft = "regex" },
    }
  }
}
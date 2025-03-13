return {
  "nvim-treesitter/nvim-treesitter",
  optional = true,
  opts = {
    ensure_install = {
      "vim",
      { parse = "vimdoc", ft = { "checkhealth", "help" } },
      "query",
      "regex"
    }
  }
}
return {
  "nvim-treesitter/nvim-treesitter",
  optional = true,
  opts = {
    ensure_install = {
      { parse = "markdown", ft = { "markdown", "pandoc" } },
      "markdown_inline",
    }
  }
}
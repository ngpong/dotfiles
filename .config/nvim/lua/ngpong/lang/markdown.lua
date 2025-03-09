return {
  "nvim-treesitter/nvim-treesitter",
  optional = true,
  opts = {
    ensure_install = {
      { parse = "markdown", ft = { "markdown", "pandoc" } },
      { parse = "markdown_inline", ft = "markdown_inline" },
    }
  }
}
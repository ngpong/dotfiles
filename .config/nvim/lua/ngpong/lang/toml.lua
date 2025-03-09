return {
  "nvim-treesitter/nvim-treesitter",
  optional = true,
  opts = {
    ensure_install = {
      { parse = "toml", ft = "toml" },
    }
  }
}
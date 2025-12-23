return {
  "nvim-treesitter/nvim-treesitter",
  optional = true,
  opts = {
    ensure_install = {
      { parse = "perl", ft = "pl" },
    }
  }
}
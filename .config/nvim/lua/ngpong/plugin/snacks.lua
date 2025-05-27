return {
  "folke/snacks.nvim",
  main = "snacks",
  lazy = false,
  config = function(_, opts)
    require("snacks").setup(opts)
  end
}

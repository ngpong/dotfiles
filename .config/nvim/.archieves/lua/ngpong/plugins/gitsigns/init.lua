return {
  "lewis6991/gitsigns.nvim",
  lazy = true,
  event = "VeryLazy",
  init = function()
    vim._plugins.record_seq("gitsigns.nvim init")
    vim._plugins.gitsigns.keys.setup()
  end,
  config = function()
    vim._plugins.record_seq("gitsigns.nvim config")
    vim._plugins.gitsigns.highlight.setup()
    vim._plugins.gitsigns.config.setup()
    vim._plugins.gitsigns.autocmd.setup()
  end
}

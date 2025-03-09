return {
  "smoka7/hop.nvim",
  lazy = true,
  dependencies = {
    "tpope/vim-repeat"
  },
  init = function()
    vim._plugins.record_seq("hop.nvim init")
    vim._plugins.hop.keys.setup()
  end,
  config = function()
    vim._plugins.record_seq("hop.nvim config")
    vim._plugins.hop.highlight.setup()
    vim._plugins.hop.config.setup()
  end
}

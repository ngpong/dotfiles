return {
  "NGPONG/matchparen.nvim",
  lazy = true,
  event = "VeryLazyFile",
  config = function()
    vim._plugins.record_seq("matchparen.nvim config")
    vim._plugins.matchparen.config.setup()
  end
}

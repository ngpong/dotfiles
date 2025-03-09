return {
  "NGPONG/marks.nvim",
  lazy = true,
  event = "VeryLazyFile",
  init = function()
    vim._plugins.record_seq("marks.nvim init")
    vim._plugins.marks.keys.setup()
  end,
  config = function()
    vim._plugins.record_seq("marks.nvim config")
    vim._plugins.marks.highlight.setup()
    vim._plugins.marks.config.setup()
  end
}

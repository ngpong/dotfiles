return {
  "echasnovski/mini.cursorword",
  lazy = true,
  event = "VeryLazyFile",
  init = function()
    vim._plugins.record_seq("mini.cursorword init")
  end,
  config = function()
    vim._plugins.record_seq("mini.cursorword config")
    vim._plugins.cursorword.config.setup()
    vim._plugins.cursorword.highlight.setup()
  end
}

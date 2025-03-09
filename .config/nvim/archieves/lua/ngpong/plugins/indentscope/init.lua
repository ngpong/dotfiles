return {
  "echasnovski/mini.indentscope",
  lazy = true,
  event = "VeryLazyFile",
  init = function ()
    vim._plugins.record_seq("mini.indentscope.nvim init")
    vim._plugins.indentscope.opts.setup()
    vim._plugins.indentscope.keys.setup()
  end,
  config = function()
    vim._plugins.record_seq("mini.indentscope.nvim config")
    vim._plugins.indentscope.highlight.setup()
    vim._plugins.indentscope.config.setup()
  end
}

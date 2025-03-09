return {
  "stevearc/dressing.nvim",
  lazy = true,
  init = function()
    vim._plugins.record_seq("dressing.nvim init")
    vim._plugins.dressing.opts.setup()
    vim._plugins.dressing.behavior.setup()
    vim._plugins.dressing.keys.setup()
  end,
  config = function()
    vim._plugins.record_seq("dressing.nvim config")
    vim._plugins.dressing.config.setup()
  end
}

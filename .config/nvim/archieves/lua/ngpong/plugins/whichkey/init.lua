return {
  "NGPONG/which-key.nvim",
  lazy = true,
  event = "VeryLazyFile",
  init = function()
    vim._plugins.record_seq("which-key init")
    vim._plugins.whichkey.keys.setup()
  end,
  config = function()
    vim._plugins.record_seq("which-key config")
    vim._plugins.whichkey.highlight.setup()
    vim._plugins.whichkey.config.setup()
  end
}

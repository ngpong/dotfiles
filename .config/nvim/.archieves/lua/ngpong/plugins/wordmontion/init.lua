return {
  "chrisgrieser/nvim-spider",
  lazy = true,
  init = function()
    vim._plugins.record_seq("nvim-spider init")
    vim._plugins.wordmontion.keys.setup()
  end,
  config = function()
    vim._plugins.record_seq("nvim-spider config")
    vim._plugins.wordmontion.config.setup()
  end
}
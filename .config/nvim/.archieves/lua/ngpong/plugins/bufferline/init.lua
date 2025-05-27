return {
  "akinsho/bufferline.nvim",
  lazy = true,
  event = "VeryLazy",
  init = function()
    vim._plugins.record_seq("bufferline.nvim init")
    vim._plugins.bufferline.keys.setup()
  end,
  config = function()
    vim._plugins.record_seq("bufferline.nvim config")
    vim._plugins.bufferline.config.setup()
    vim._plugins.bufferline.behavior.setup()
  end
}

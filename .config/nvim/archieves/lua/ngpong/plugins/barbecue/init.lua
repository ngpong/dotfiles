return {
  "NGPONG/barbecue.nvim",
  lazy = true,
  event = { "LazyFile", "VeryLazy" },
  dependencies = {
    "SmiteshP/nvim-navic"
  },
  init = function()
    vim._plugins.record_seq("barbecue.nvim init")
    vim._plugins.barbecue.handler.setup()
    vim._plugins.barbecue.autocmd.setup()
  end,
  config = function()
    vim._plugins.record_seq("barbecue.nvim config")
    vim._plugins.barbecue.config.setup()
  end
}

return {
  "svban/YankAssassin.nvim",
  init = function()
    vim._plugins.record_seq("YankAssassin.nvim init")
  end,
  config = function()
    vim._plugins.record_seq("YankAssassin.nvim config")
    vim._plugins.yanky.config.setup()
    vim._plugins.yanky.autocmd.setup()
  end
}
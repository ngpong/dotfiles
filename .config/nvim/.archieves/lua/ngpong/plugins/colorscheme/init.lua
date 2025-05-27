return {
  "ellisonleao/gruvbox.nvim",
  lazy = false,
  priority = 1,
  config = function()
    vim._plugins.record_seq("colorscheme config")
    vim._plugins.colorscheme.config.setup()
  end
}
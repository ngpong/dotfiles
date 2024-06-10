return {
  'ellisonleao/gruvbox.nvim',
  lazy = false,
  priority = 1,
  config = function()
    Plgs.record_seq('colorscheme config')
    Plgs.colorscheme.config.setup()
  end
}
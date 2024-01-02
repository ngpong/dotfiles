return {
  'ellisonleao/gruvbox.nvim',
  lazy = false,
  priority = 1,
  config = function()
    PLGS.record_seq('colorscheme config')
    PLGS.colorscheme.config.setup()
  end
}
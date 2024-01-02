return {
  'utilyre/barbecue.nvim',
  lazy = true,
  event = 'LazyFile',
  dependencies = {
    'SmiteshP/nvim-navic'
  },
  config = function()
    PLGS.record_seq('barbecue.nvim config')
    PLGS.barbecue.autocmd.setup()
    PLGS.barbecue.config.setup()
  end
}
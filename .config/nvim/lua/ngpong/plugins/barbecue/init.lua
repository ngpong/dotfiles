return {
  'utilyre/barbecue.nvim',
  lazy = true,
  event = 'LazyFile',
  dependencies = {
    'SmiteshP/nvim-navic'
  },
  init = function()
    PLGS.record_seq('barbecue.nvim init')
    PLGS.barbecue.handler.setup()
    PLGS.barbecue.autocmd.setup()
  end,
  config = function()
    PLGS.record_seq('barbecue.nvim config')
    PLGS.barbecue.config.setup()
  end
}

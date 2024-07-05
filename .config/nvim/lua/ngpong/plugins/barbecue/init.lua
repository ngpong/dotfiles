return {
  'NGPONG/barbecue.nvim',
  lazy = true,
  enabled = true,
  event = 'LazyFile',
  dependencies = {
    'SmiteshP/nvim-navic'
  },
  init = function()
    Plgs.record_seq('barbecue.nvim init')
    Plgs.barbecue.handler.setup()
    Plgs.barbecue.autocmd.setup()
  end,
  config = function()
    Plgs.record_seq('barbecue.nvim config')
    Plgs.barbecue.config.setup()
  end
}

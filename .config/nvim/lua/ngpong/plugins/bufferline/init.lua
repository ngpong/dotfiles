return {
  'akinsho/bufferline.nvim',
  lazy = true,
  event = 'VeryLazy',
  init = function()
    Plgs.record_seq('bufferline.nvim init')
    Plgs.bufferline.keys.setup()
    Plgs.bufferline.session.setup()
  end,
  config = function()
    Plgs.record_seq('bufferline.nvim config')
    Plgs.bufferline.config.setup()
  end
}

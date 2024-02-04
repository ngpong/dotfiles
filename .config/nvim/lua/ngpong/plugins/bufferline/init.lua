return {
  'akinsho/bufferline.nvim',
  lazy = true,
  event = 'VeryLazy',
  init = function()
    PLGS.record_seq('bufferline.nvim init')
    PLGS.bufferline.keys.setup()
    PLGS.bufferline.session.setup()
  end,
  config = function()
    PLGS.record_seq('bufferline.nvim config')
    PLGS.bufferline.config.setup()
  end
}

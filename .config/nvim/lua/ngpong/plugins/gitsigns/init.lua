return {
  'lewis6991/gitsigns.nvim',
  lazy = true,
  event = 'LazyFile',
  init = function()
    PLGS.record_seq('gitsigns.nvim init')
    PLGS.gitsigns.keys.setup()
  end,
  config = function()
    PLGS.record_seq('gitsigns.nvim config')
    PLGS.gitsigns.config.setup()
    PLGS.gitsigns.autocmd.setup()
  end
}

return {
  'lewis6991/gitsigns.nvim',
  lazy = true,
  event = 'LazyFile',
  init = function()
    Plgs.record_seq('gitsigns.nvim init')
    Plgs.gitsigns.keys.setup()
  end,
  config = function()
    Plgs.record_seq('gitsigns.nvim config')
    Plgs.gitsigns.config.setup()
    Plgs.gitsigns.autocmd.setup()
  end
}

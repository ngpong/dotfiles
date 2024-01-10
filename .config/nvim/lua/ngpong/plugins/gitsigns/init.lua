return {
  'lewis6991/gitsigns.nvim',
  lazy = true,
  event = 'VeryLazyFile',
  init = function()
    PLGS.record_seq('gitsigns.nvim init')
    PLGS.gitsigns.keys.setup()
  end,
  config = function()
    PLGS.record_seq('gitsigns.nvim config')
    PLGS.gitsigns.autocmd.setup()
    PLGS.gitsigns.config.setup()
  end
}
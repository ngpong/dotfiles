return {
  'chrisgrieser/nvim-spider',
  lazy = true,
  init = function()
    PLGS.record_seq('nvim-spider init')
    PLGS.wordmontion.keys.setup()
  end,
  config = function()
    PLGS.record_seq('nvim-spider config')
    PLGS.wordmontion.config.setup()
  end
}
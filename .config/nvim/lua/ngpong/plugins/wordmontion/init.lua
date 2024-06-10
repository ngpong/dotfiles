return {
  'chrisgrieser/nvim-spider',
  lazy = true,
  init = function()
    Plgs.record_seq('nvim-spider init')
    Plgs.wordmontion.keys.setup()
  end,
  config = function()
    Plgs.record_seq('nvim-spider config')
    Plgs.wordmontion.config.setup()
  end
}
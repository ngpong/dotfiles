return {
  'NGPONG/which-key.nvim',
  lazy = true,
  event = 'VeryVeryLazy',
  init = function()
    Plgs.record_seq('which-key init')
    Plgs.whichkey.keys.setup()
  end,
  config = function()
    Plgs.record_seq('which-key config')
    Plgs.whichkey.highlight.setup()
    Plgs.whichkey.config.setup()
  end
}

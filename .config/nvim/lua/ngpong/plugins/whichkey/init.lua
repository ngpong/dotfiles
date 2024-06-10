return {
  'NGPONG/which-key.nvim',
  lazy = true,
  event = 'VeryVeryLazy',
  init = function()
    Plgs.record_seq('which-key init')
    Plgs.whichkey.keys.setup()
    Plgs.whichkey.highlight.setup()
  end,
  config = function()
    Plgs.record_seq('which-key config')
    Plgs.whichkey.config.setup()
  end
}

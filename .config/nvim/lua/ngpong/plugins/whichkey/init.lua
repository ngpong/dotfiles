return {
  'NGPONG/which-key.nvim',
  lazy = true,
  event = 'VeryVeryLazy',
  init = function()
    PLGS.record_seq('which-key init')
    PLGS.whichkey.keys.setup()
    PLGS.whichkey.highlight.setup()
  end,
  config = function()
    PLGS.record_seq('which-key config')
    PLGS.whichkey.config.setup()
  end
}

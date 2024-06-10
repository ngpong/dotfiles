return {
  'NGPONG/leap.nvim',
  lazy = true,
  init = function()
    Plgs.record_seq('leap.nvim init')
    Plgs.leap.keys.setup()
    Plgs.leap.highlight.setup()
  end,
  config = function()
    Plgs.record_seq('leap.nvim config')
    Plgs.leap.config.setup()
  end
}

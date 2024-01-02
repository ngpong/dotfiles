return {
  'ggandor/leap.nvim',
  lazy = true,
  init = function()
    PLGS.record_seq('leap.nvim init')
    PLGS.leap.keys.setup()
    PLGS.leap.highlight.setup()
  end,
  config = function()
    PLGS.record_seq('leap.nvim config')
    PLGS.leap.config.setup()
  end
}
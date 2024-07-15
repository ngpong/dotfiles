return {
  'ggandor/leap.nvim',
  lazy = true,
  init = function()
    Plgs.record_seq('leap.nvim init')
    Plgs.leap.keys.setup()
  end,
  config = function()
    Plgs.record_seq('leap.nvim config')
    Plgs.leap.highlight.setup()
    Plgs.leap.config.setup()
  end
}

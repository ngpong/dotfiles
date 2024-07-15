return {
  'NGPONG/marks.nvim',
  lazy = true,
  event = 'VeryVeryLazy',
  init = function()
    Plgs.record_seq('marks.nvim init')
    Plgs.marks.keys.setup()
  end,
  config = function()
    Plgs.record_seq('marks.nvim config')
    Plgs.marks.highlight.setup()
    Plgs.marks.config.setup()
  end
}

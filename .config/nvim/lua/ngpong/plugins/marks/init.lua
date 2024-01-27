return {
  'NGPONG/marks.nvim',
  lazy = true,
  event = 'VeryVeryLazy',
  init = function()
    PLGS.record_seq('marks.nvim init')
    PLGS.marks.keys.setup()
    PLGS.marks.highlight.setup()
  end,
  config = function()
    PLGS.record_seq('marks.nvim config')
    PLGS.marks.config.setup()
  end
}
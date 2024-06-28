return {
  'NGPONG/matchparen.nvim',
  lazy = true,
  event = 'VeryVeryLazy',
  config = function()
    Plgs.record_seq('matchparen.nvim config')
    Plgs.matchparen.config.setup()
  end
}

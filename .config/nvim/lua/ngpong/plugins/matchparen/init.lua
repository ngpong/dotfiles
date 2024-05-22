return {
  'monkoose/matchparen.nvim',
  lazy = true,
  enabled = true,
  event = 'VeryVeryLazy',
  config = function()
    PLGS.record_seq('matchparen.nvim config')
    PLGS.matchparen.config.setup()
  end
}

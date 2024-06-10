return {
  'monkoose/matchparen.nvim',
  lazy = true,
  enabled = true,
  event = 'VeryVeryLazy',
  config = function()
    Plgs.record_seq('matchparen.nvim config')
    Plgs.matchparen.config.setup()
  end
}

return {
  'NGPONG/trouble.nvim',
  lazy = true,
  cmd = { 'TroubleToggle', 'Trouble' },
  init = function()
    PLGS.record_seq('trouble.nvim init')
    PLGS.trouble.keys.setup()
    PLGS.trouble.highlight.setup()
  end,
  config = function()
    PLGS.record_seq('trouble.nvim config')
    PLGS.trouble.behavior.setup()
    PLGS.trouble.config.setup()
  end
}
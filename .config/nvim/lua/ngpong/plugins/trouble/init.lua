return {
  'folke/trouble.nvim',
  lazy = true,
  dependencies = {
    'folke/todo-comments.nvim'
  },
  cmd = { 'TroubleToggle', 'Trouble' },
  init = function()
    Plgs.record_seq('trouble.nvim init')
    Plgs.trouble.keys.setup()
  end,
  config = function()
    Plgs.record_seq('trouble.nvim config')
    Plgs.trouble.highlight.setup()
    Plgs.trouble.behavior.setup()
    Plgs.trouble.config.setup()
  end
}

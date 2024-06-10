return {
  'stevearc/conform.nvim',
  lazy = true,
  cmd = 'ConformInfo',
  init = function()
    Plgs.record_seq('conform.nvim init')
    Plgs.formatter.keys.setup()
  end,
  config = function()
    Plgs.record_seq('conform.nvim config')
    Plgs.formatter.config.setup()
  end
}

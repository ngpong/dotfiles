return {
  'stevearc/conform.nvim',
  lazy = true,
  cmd = 'ConformInfo',
  init = function()
    PLGS.record_seq('conform.nvim init')
    PLGS.formatter.keys.setup()
  end,
  config = function()
    PLGS.record_seq('conform.nvim config')
    PLGS.formatter.config.setup()
  end
}

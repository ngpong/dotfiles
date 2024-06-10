return {
  'stevearc/dressing.nvim',
  lazy = true,
  init = function()
    Plgs.record_seq('dressing.nvim init')
    Plgs.dressing.opts.setup()
  end,
  config = function()
    Plgs.record_seq('dressing.nvim config')
    Plgs.dressing.config.setup()
  end
}

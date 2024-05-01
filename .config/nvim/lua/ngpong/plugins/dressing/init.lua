return {
  'stevearc/dressing.nvim',
  lazy = true,
  init = function()
    PLGS.record_seq('dressing.nvim init')
    PLGS.dressing.opts.setup()
  end,
  config = function()
    PLGS.record_seq('dressing.nvim config')
    PLGS.dressing.config.setup()
  end
}

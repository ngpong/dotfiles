return {
  'rcarriga/nvim-notify',
  lazy = true,
  init = function()
    PLGS.record_seq('nvim-notify init')
    PLGS.notify.opts.setup()
  end,
  config = function()
    PLGS.record_seq('nvim-notify config')
    PLGS.notify.config.setup()
  end
}
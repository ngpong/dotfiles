return {
  'rcarriga/nvim-notify',
  lazy = true,
  init = function()
    Plgs.record_seq('nvim-notify init')
    Plgs.notify.opts.setup()
  end,
  config = function()
    Plgs.record_seq('nvim-notify config')
    Plgs.notify.config.setup()
  end
}
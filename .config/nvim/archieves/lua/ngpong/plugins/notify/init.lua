return {
  "rcarriga/nvim-notify",
  lazy = true,
  init = function()
    vim._plugins.record_seq("nvim-notify init")
    vim._plugins.notify.opts.setup()
  end,
  config = function()
    vim._plugins.record_seq("nvim-notify config")
    vim._plugins.notify.config.setup()
  end
}
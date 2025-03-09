return {
  "stevearc/conform.nvim",
  lazy = true,
  cmd = "ConformInfo",
  init = function()
    vim._plugins.record_seq("conform.nvim init")
    vim._plugins.formatter.keys.setup()
  end,
  config = function()
    vim._plugins.record_seq("conform.nvim config")
    vim._plugins.formatter.config.setup()
  end
}

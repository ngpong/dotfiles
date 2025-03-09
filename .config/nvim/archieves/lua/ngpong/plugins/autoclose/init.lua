return {
  "NGPONG/autoclose.nvim",
  lazy = true,
  event = { "InsertEnter", "CmdlineEnter" },
  init = function()
    vim._plugins.record_seq("autoclose init")
  end,
  config = function()
    vim._plugins.record_seq("autoclose config")
    vim._plugins.autoclose.config.setup()
  end
}

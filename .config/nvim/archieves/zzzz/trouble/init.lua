return {
  "folke/trouble.nvim",
  lazy = true,
  cmd = { "TroubleToggle", "Trouble" },
  init = function()
    vim._plugins.record_seq("trouble.nvim init")
    vim._plugins.trouble.keys.setup()
  end,
  config = function()
    vim._plugins.record_seq("trouble.nvim config")
    vim._plugins.trouble.highlight.setup()
    vim._plugins.trouble.behavior.setup()
    vim._plugins.trouble.autocmd.setup()
    vim._plugins.trouble.config.setup()
    vim._plugins.trouble.hacker.setup()
  end
}

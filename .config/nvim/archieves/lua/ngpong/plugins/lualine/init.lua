return {
  "nvim-lualine/lualine.nvim",
  lazy = true,
  event = "VeryLazy",
  init = function()
    vim._plugins.record_seq("lualine.nvim init")
    vim._plugins.lualine.opts.setup()
  end,
  config = function()
    vim._plugins.record_seq("lualine.nvim config")
    vim._plugins.lualine.highlight.setup()
    vim._plugins.lualine.config.setup()
    vim._plugins.lualine.hacker.setup()
  end
}

return {
  "nvim-telescope/telescope.nvim",
  lazy = true,
  cmd = "Telescope",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make"
    },
    "nvim-telescope/telescope-smart-history.nvim",
    "NGPONG/telescope-live-grep-args.nvim",
  },
  init = function()
    vim._plugins.record_seq("telescope.nvim init")
    vim._plugins.telescope.keys.setup()
    vim._plugins.telescope.autocmd.setup()
    vim._plugins.telescope.behavior.setup()
  end,
  config = function()
    vim._plugins.record_seq("telescope.nvim config")
    vim._plugins.telescope.highlight.setup()
    vim._plugins.telescope.config.setup()
    vim._plugins.telescope.entry_maker.setup()
  end
}

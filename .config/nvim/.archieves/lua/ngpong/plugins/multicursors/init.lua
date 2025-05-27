-- https://neovim.io/roadmap/
-- https://github.com/neovim/neovim/issues/7257
return {
  "NGPONG/multicursors.nvim",
  lazy = true,
  dependencies = {
    "NGPONG/hydra.nvim",
  },
  init = function()
    vim._plugins.record_seq("multicursors.nvim init")
    vim._plugins.multicursors.keys.setup()
  end,
  config = function()
    vim._plugins.record_seq("multicursors.nvim config")
    vim._plugins.multicursors.highlight.setup()
    vim._plugins.multicursors.config.setup()
  end
}

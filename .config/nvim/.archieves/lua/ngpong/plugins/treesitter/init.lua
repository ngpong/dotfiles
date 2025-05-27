return {
  "nvim-treesitter/nvim-treesitter",
  lazy = vim.fn.argc(-1) == 0,
  event = { "LazyFile", "VeryLazy" },
  build = ":TSUpdate",
  dependencies = {
    { "echasnovski/mini.nvim" }
    -- { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" }
    -- { "HiPhish/rainbow-delimiters.nvim", lazy = true }
  },
  init = function()
    vim._plugins.record_seq("nvim-treesitter init")
    vim._plugins.treesitter.opts.setup()
    -- vim._plugins.treesitter.keys.setup()
  end,
  config = function()
    vim._plugins.record_seq("nvim-treesitter config")
    -- vim._plugins.treesitter.hacker.setup()
    vim._plugins.treesitter.config.setup()
  end,
}
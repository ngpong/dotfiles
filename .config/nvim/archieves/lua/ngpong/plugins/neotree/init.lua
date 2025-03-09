return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = true,
  enabled = false,
  cmd = "Neotree",
  init = function()
    vim._plugins.record_seq("neo-tree.nvim init")
    vim._plugins.neotree.keys.setup()
    vim._plugins.neotree.opts.setup()
  end,
  config = function()
    vim._plugins.record_seq("neo-tree.nvim config")
    vim._plugins.neotree.highlight.setup()
    vim._plugins.neotree.config.setup()
  end
}

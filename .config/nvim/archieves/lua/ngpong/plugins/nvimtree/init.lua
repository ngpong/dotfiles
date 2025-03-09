return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "b0o/nvim-tree-preview.lua",
  },
  lazy = true,
  init = function()
    vim._plugins.record_seq("nvim-tree.lua init")
    vim._plugins.nvimtree.keys.setup()
  end,
  config = function()
    vim._plugins.record_seq("nvim-tree.lua config")
    vim._plugins.nvimtree.opts.setup()
    vim._plugins.nvimtree.behavior.setup()
    vim._plugins.nvimtree.config.setup()
  end
}

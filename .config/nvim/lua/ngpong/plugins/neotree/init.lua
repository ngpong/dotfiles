return {
  'nvim-neo-tree/neo-tree.nvim',
  lazy = true,
  cmd = 'Neotree',
  init = function()
    PLGS.record_seq('neo-tree.nvim init')
    PLGS.neotree.keys.setup()
    PLGS.neotree.opts.setup()
    PLGS.neotree.highlight.setup()
  end,
  config = function()
    PLGS.record_seq('neo-tree.nvim config')
    PLGS.neotree.behavior.setup()
    PLGS.neotree.config.setup()
  end
}

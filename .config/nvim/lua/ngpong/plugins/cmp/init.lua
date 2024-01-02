return {
  'hrsh7th/nvim-cmp',
  lazy = true,
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-cmdline',
    'FelipeLema/cmp-async-path',
    'hrsh7th/cmp-buffer',
    'lukas-reineke/cmp-under-comparator',
    'L3MON4D3/LuaSnip'
  },
  init = function()
    PLGS.record_seq('nvim-cmp init')
    PLGS.cmp.opts.setup()
    PLGS.cmp.keys.setup()
    PLGS.cmp.highlight.setup()
  end,
  config = function()
    PLGS.record_seq('nvim-cmp config')
    PLGS.cmp.config.setup()
  end
}
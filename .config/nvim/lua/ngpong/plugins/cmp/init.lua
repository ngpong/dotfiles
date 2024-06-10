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
    Plgs.record_seq('nvim-cmp init')
    Plgs.cmp.opts.setup()
    Plgs.cmp.keys.setup()
    Plgs.cmp.highlight.setup()
  end,
  config = function()
    Plgs.record_seq('nvim-cmp config')
    Plgs.cmp.config.setup()
  end
}

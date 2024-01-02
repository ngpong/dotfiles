return {
  'L3MON4D3/LuaSnip',
  lazy = true,
  build = 'make install_jsregexp',
  dependencies = {
    'rafamadriz/friendly-snippets'
  },
  config = function()
    PLGS.record_seq('LuaSnip config')
    PLGS.luasnip.autocmd.setup()
    PLGS.luasnip.config.setup()
    PLGS.luasnip.snippets.setup()
  end
}
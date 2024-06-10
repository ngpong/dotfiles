return {
  'L3MON4D3/LuaSnip',
  lazy = true,
  build = 'make install_jsregexp',
  config = function()
    Plgs.record_seq('LuaSnip config')
    Plgs.luasnip.config.setup()
    Plgs.luasnip.autocmd.setup()
    Plgs.luasnip.snippets.setup()
  end
}

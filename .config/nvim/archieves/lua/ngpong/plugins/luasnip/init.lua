return {
  "L3MON4D3/LuaSnip",
  lazy = true,
  build = "make install_jsregexp",
  config = function()
    vim._plugins.record_seq("LuaSnip config")
    vim._plugins.luasnip.config.setup()
    vim._plugins.luasnip.autocmd.setup()
    vim._plugins.luasnip.snippets.setup()
  end
}

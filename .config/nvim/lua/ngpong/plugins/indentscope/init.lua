return {
  'echasnovski/mini.indentscope',
  lazy = true,
  event = 'VeryVeryLazy',
  init = function ()
    Plgs.record_seq('mini.indentscope.nvim init')
    Plgs.indentscope.opts.setup()
    Plgs.indentscope.keys.setup()
  end,
  config = function()
    Plgs.record_seq('mini.indentscope.nvim config')
    Plgs.indentscope.highlight.setup()
    Plgs.indentscope.config.setup()
  end
}

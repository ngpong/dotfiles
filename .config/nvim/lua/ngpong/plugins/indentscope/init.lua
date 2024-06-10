return {
  'echasnovski/mini.indentscope',
  lazy = true,
  event = 'VeryVeryLazy',
  init = function ()
    Plgs.record_seq('mini.indentscope.nvim init')
    Plgs.indentscope.opts.setup()
    Plgs.indentscope.keys.setup()
    Plgs.indentscope.highlight.setup()
  end,
  config = function()
    Plgs.record_seq('mini.indentscope.nvim config')
    Plgs.indentscope.config.setup()
  end
}

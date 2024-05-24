return {
  'echasnovski/mini.indentscope',
  lazy = true,
  event = 'VeryVeryLazy',
  init = function ()
    PLGS.record_seq('mini.indentscope.nvim init')
    PLGS.indentscope.opts.setup()
    PLGS.indentscope.keys.setup()
    PLGS.indentscope.highlight.setup()
  end,
  config = function()
    PLGS.record_seq('mini.indentscope.nvim config')
    PLGS.indentscope.config.setup()
  end
}

return {
  'nvim-lualine/lualine.nvim',
  lazy = true,
  event = 'VeryLazy',
  init = function()
    PLGS.record_seq('lualine.nvim init')
    PLGS.lualine.opts.setup()
    PLGS.lualine.highlight.setup()
  end,
  config = function()
    PLGS.record_seq('lualine.nvim config')
    PLGS.lualine.config.setup()
  end
}
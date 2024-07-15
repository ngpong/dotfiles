return {
  'nvim-lualine/lualine.nvim',
  lazy = true,
  event = 'VeryLazy',
  init = function()
    Plgs.record_seq('lualine.nvim init')
    Plgs.lualine.opts.setup()
  end,
  config = function()
    Plgs.record_seq('lualine.nvim config')
    Plgs.lualine.highlight.setup()
    Plgs.lualine.config.setup()
    Plgs.lualine.hacker.setup()
  end
}

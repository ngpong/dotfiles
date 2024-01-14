return {
  'nvim-telescope/telescope.nvim',
  lazy = true,
  cmd = 'Telescope',
  dependencies = {
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    },
    'NGPONG/telescope-live-grep-args.nvim' ,
  },
  init = function()
    PLGS.record_seq('telescope.nvim init')
    PLGS.telescope.keys.setup()
    PLGS.telescope.highlight.setup()
  end,
  config = function()
    PLGS.record_seq('telescope.nvim config')
    PLGS.telescope.autocmd.setup()
    PLGS.telescope.config.setup()
  end
}

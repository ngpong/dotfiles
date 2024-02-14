return {
  'nvim-telescope/telescope.nvim',
  lazy = true,
  cmd = 'Telescope',
  dependencies = {
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    },
    'nvim-telescope/telescope-smart-history.nvim',
    'NGPONG/telescope-live-grep-args.nvim' ,
  },
  init = function()
    PLGS.record_seq('telescope.nvim init')
    PLGS.telescope.keys.setup()
    PLGS.telescope.highlight.setup()
    PLGS.telescope.autocmd.setup()
    PLGS.telescope.behavior.setup()
  end,
  config = function()
    PLGS.record_seq('telescope.nvim config')
    PLGS.telescope.hacker.setup()
    PLGS.telescope.config.setup()
  end
}

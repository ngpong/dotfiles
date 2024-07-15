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
    'NGPONG/telescope-live-grep-args.nvim',
  },
  init = function()
    Plgs.record_seq('telescope.nvim init')
    Plgs.telescope.keys.setup()
    Plgs.telescope.autocmd.setup()
    Plgs.telescope.behavior.setup()
  end,
  config = function()
    Plgs.record_seq('telescope.nvim config')
    Plgs.telescope.highlight.setup()
    Plgs.telescope.config.setup()
    Plgs.telescope.entry_maker.setup()
  end
}

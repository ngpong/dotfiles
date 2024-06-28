-- https://github.com/neovim/neovim/issues/7257
return {
  'NGPONG/multicursors.nvim',
  lazy = true,
  dependencies = {
    'NGPONG/hydra.nvim',
  },
  init = function()
    Plgs.record_seq('multicursors.nvim init')
    Plgs.multicursors.keys.setup()
    Plgs.multicursors.highlight.setup()
  end,
  config = function()
    Plgs.record_seq('multicursors.nvim config')
    Plgs.multicursors.config.setup()
  end
}

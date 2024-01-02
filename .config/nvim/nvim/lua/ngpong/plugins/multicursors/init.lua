return {
  'NGPONG/multicursors.nvim',
  lazy = true,
  dependencies = {
    'NGPONG/hydra.nvim',
  },
  init = function()
    PLGS.record_seq('multicursors.nvim init')
    PLGS.multicursors.keys.setup()
    PLGS.multicursors.highlight.setup()
  end,
  config = function()
    PLGS.record_seq('multicursors.nvim config')
    PLGS.multicursors.config.setup()
  end
}
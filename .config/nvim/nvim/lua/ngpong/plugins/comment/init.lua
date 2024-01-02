return {
  'numToStr/Comment.nvim',
  lazy = true,
  init = function()
    PLGS.record_seq('Comment.nvim init')
    PLGS.comment.keys.setup()
  end,
  config = function()
    PLGS.record_seq('Comment.nvim config')
    PLGS.comment.config.setup()
  end
}
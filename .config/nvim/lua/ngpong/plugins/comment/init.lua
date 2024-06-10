return {
  'numToStr/Comment.nvim',
  lazy = true,
  init = function()
    Plgs.record_seq('Comment.nvim init')
    Plgs.comment.keys.setup()
  end,
  config = function()
    Plgs.record_seq('Comment.nvim config')
    Plgs.comment.config.setup()
  end
}

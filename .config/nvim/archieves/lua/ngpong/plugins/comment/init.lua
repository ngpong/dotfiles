return {
  "numToStr/Comment.nvim",
  lazy = true,
  init = function()
    vim._plugins.record_seq("Comment.nvim init")
    vim._plugins.comment.keys.setup()
  end,
  config = function()
    vim._plugins.record_seq("Comment.nvim config")
    vim._plugins.comment.config.setup()
  end
}

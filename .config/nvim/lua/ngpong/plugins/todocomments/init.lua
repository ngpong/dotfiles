return {
  'NGPONG/todo-comments.nvim',
  lazy = true,
  event = 'VeryVeryLazy',
  init = function()
    Plgs.record_seq('todo-comments.nvim init')
    Plgs.todocomments.keys.setup()
  end,
  config = function()
    Plgs.record_seq('todo-comments.nvim config')
    Plgs.todocomments.config.setup()
  end
}

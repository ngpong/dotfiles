return {
  'folke/todo-comments.nvim',
  lazy = true,
  event = 'VeryVeryLazy',
  init = function()
    PLGS.record_seq('todo-comments.nvim init')
    PLGS.todocomments.keys.setup()
  end,
  config = function()
    PLGS.record_seq('todo-comments.nvim config')
    PLGS.todocomments.config.setup()
  end
}

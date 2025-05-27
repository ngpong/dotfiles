return {
  "folke/todo-comments.nvim",
  lazy = true,
  event = "VeryLazyFile",
  init = function()
    vim._plugins.record_seq("todo-comments.nvim init")
    vim._plugins.todocomments.keys.setup()
  end,
  config = function()
    vim._plugins.record_seq("todo-comments.nvim config")
    vim._plugins.todocomments.config.setup()
  end
}

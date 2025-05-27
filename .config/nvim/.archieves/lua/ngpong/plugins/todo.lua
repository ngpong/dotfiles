return {
  "folke/todo-comments.nvim",
  main = "todo-comments",
  lazy = true,
  event = "VeryLazy",
  highlights = {
    { "TodoCommentsColorDefault", fg = vim.__color.bright_orange },
    { "TodoCommentsColorTest", fg = vim.__color.bright_purple },
  },
  keys = {
    { "[t", function() require("todo-comments").jump_prev() end },
    { "]t", function() require("todo-comments").jump_next() end },
    {
      "<leader>T",
      function()
        t_api.toggle("todo")
      end,
      silent = true
    },
  },
  opts = {
    signs = false,
    keywords = {
      FIX = { icon = vim.__icons.debugger .. vim.__icons.space, color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, },
      TODO = { icon = vim.__icons.yes_small .. vim.__icons.space, color = "info" },
      HACK = { icon = vim.__icons.fire .. vim.__icons.space, color = "error" },
      WARN = { icon = vim.__icons.diagnostic_warn .. vim.__icons.space, color = "warning", alt = { "WARNING" } },
      PERF = { icon = vim.__icons.caution .. vim.__icons.space, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = vim.__icons.diagnostic_hint .. vim.__icons.space, color = "hint", alt = { "INFO" } },
      TEST = { icon = vim.__icons.clock .. vim.__icons.space, color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
    gui_style = {
      fg = "NONE",
      bg = "BOLD",
    },
    colors = {
      error = { "DiagnosticError" },
      warning = { "DiagnosticWarn" },
      info = { "DiagnosticInfo" },
      hint = { "DiagnosticHint" },
      default = { "TodoCommentsColorDefault" },
      test = { "TodoCommentsColorTest" },
    },
    highlight = {
      multiline = false,
      multiline_pattern = "^.",
      multiline_context = 10,
      before = "", -- 'fg' or 'bg' or empty
      keyword = "wide", -- 'fg', 'bg', 'wide', 'wide_bg', 'wide_fg' or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
      after = "fg", -- 'fg' or 'bg' or empty
      pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
      comments_only = false,
      max_line_len = 400,
      exclude = vim.__filter.filetypes[1],
    },
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--sort-files",
        "--hidden",
        "--no-ignore-vcs",
        "--type-not=readme",
        "--type-not=d",
        "--type-not=diff",
        "--type-not=sql",
        "--type-not=txt",
      },
    },
  },
  hackers = {
    before = {
      function()
        require("todo-comments.snacks").source = require("snacks.picker.config.sources").todo_comments
      end
    }
  }
}

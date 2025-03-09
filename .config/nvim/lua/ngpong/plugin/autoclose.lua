return {
  "NGPONG/autoclose.nvim",
  lazy = true,
  event = "InsertEnter",
  opts = {
    keys = {
      ["("] = { escape = false, close = false, pair = "()" },
      ["["] = { escape = false, close = false, pair = "[]" },
      ["{"] = { escape = false, close = false, pair = "{}" },

      [">"] = { escape = false, close = false, pair = "<>" },
      [")"] = { escape = false, close = false, pair = "()" },
      ["]"] = { escape = false, close = false, pair = "[]" },
      ["}"] = { escape = false, close = false, pair = "{}" },

      ["<CR>"] = { disable_command_mode = true },
    },
    options = {
      disabled_filetypes = {},
      disable_when_touch = true,
      touch_regex = "[%w(%[{]",
      pair_spaces = true,
      auto_indent = true,
      disable_command_mode = true,
    },
    disabled = false,
  },
}
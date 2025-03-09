local M = {}

function M.setup()
  require("autoclose").setup({
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
       disable_when_touch = false,
       touch_regex = "[%w(%[{]",
       pair_spaces = false,
       auto_indent = true,
       disable_command_mode = true,
     },
     disabled = false,
    }
  )
end

return M
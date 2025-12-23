return {
  "smoka7/hop.nvim",
  main = "hop",
  -- dependencies = {
  --   "tpope/vim-repeat"
  -- },
  lazy = true,
  -- init = function()
  --   local function donot_prompt(cb)
  --     return function()
  --       local nvim_echo = vim.api.nvim_echo
  --       vim.api.nvim_echo = function(...) end
  --       cb()
  --       vim.api.nvim_echo = nvim_echo
  --     end
  --   end
  --
  --   local function short_prompt(cb)
  --     return function()
  --       local get_input_pattern = Hop.get_input_pattern
  --       Hop.get_input_pattern = function(...)
  --         local args = { ... } args[1] = ":"
  --         return get_input_pattern(table.unpack(args))
  --       end
  --       cb()
  --       Hop.get_input_pattern = get_input_pattern
  --     end
  --   end
  -- end,
  highlights = {
    { "Question", fg = vim.__color.light1 },
    { "HopNextKey", bg = vim.__color.bright_red, fg = vim.__color.dark0, bold = true, italic = true, },
    { "HopNextKey1", bg = vim.__color.neutral_blue, fg = vim.__color.dark0, bold = true, italic = true, },
    { "HopNextKey2", bg = vim.__color.bright_blue, fg = vim.__color.dark0, bold = true, italic = true, },
    -- { HopUnmatched = { link = "Comment" },
    -- { HopCursor = { reverse = true },
    { "HopPreview", link = "Search" },
  },
  keys = {
    { "s", function() require("hop").hint_char2() end, mode = "" },
    { "S", function() require("hop").hint_words() end, mode = "" },
    { "f", function() require("hop").hint_char1({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true }) end, mode = { "o", "v" } },
    { "F", function() require("hop").hint_char1({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true }) end, mode = { "o", "v" } },
    { "t", function() require("hop").hint_char1({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }) end, mode = { "o", "v" } },
    { "T", function() require("hop").hint_char1({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 }) end, mode = { "o", "v" } },
  },
  opts = {
    teasing = false,
    virtual_cursor = false,
    dim_unmatched = false,
    create_hl_autocmd = false,
    uppercase_labels = false,
    hl_mode = "combine",
    yank_register = "*",
  },
}

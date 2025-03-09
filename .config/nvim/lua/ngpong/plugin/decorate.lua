-- return {
--   "stevearc/dressing.nvim",
--   lazy = true,
--   highlights = {
--     { "DressingInputNormal", link = "Normal" },
--     { "DressingInputBorder", fg = vim.__color.light2 },
--     { "DressingInputTitle", fg = vim.__color.bright_aqua, bold = true },
--   },
--   init = function()
--     vim.ui.select = function(...)
--       vim.__plugin.load("dressing.nvim")
--       return vim.ui.select(...)
--     end
--     vim.ui.input = function(...)
--       vim.__plugin.load("dressing.nvim")
--       return vim.ui.input(...)
--     end
--   end,
--   opts = {
--     input = {
--       enabled = true,
--       default_prompt = "Input",
--       title_pos = "center",
--       start_in_insert = true,
--       border = "rounded",
--       relative = "cursor",
--       prefer_width = 40,
--       max_width = { 140, 0.9 },
--       min_width = { 25, 0.25 },
--       buf_options = {},
--       win_options = {
--         wrap = false,
--         list = true,
--         sidescrolloff = 1,
--         listchars = "precedes:…,extends:…",
--         winhighlight = "Normal:DressingInputNormal,FloatBorder:DressingInputBorder,FloatTitle:DressingInputTitle"
--       },
--       mappings = {
--         n = {
--           ["<Esc>"] = "Close",
--           ["<CR>"] = "Confirm",
--         },
--         i = {
--           ["<Esc>"] = "Close",
--           ["<CR>"] = "Confirm",
--           ["<C-c>"] = false,
--           ["<Up>"] = false,
--           ["<Down>"] = false,
--         },
--       },
--     },
--     select = {
--       enabled = true,
--       backend = { "fzf_lua", "telescope", "fzf", "builtin", "nui" },
--       trim_prompt = true,
--       fzf_lua = {
--         -- winopts = {
--         --   height = 0.5,
--         --   width = 0.5,
--         -- },
--       },
--       -- Options for nui Menu
--       nui = {
--         position = "50%",
--         size = nil,
--         relative = "editor",
--         border = {
--           style = "rounded",
--         },
--         buf_options = {
--           swapfile = false,
--           filetype = "DressingSelect",
--         },
--         win_options = {
--           winblend = 0,
--         },
--         max_width = 80,
--         max_height = 40,
--         min_width = 40,
--         min_height = 10,
--       },
--       -- Options for built-in selector
--       builtin = {
--         show_numbers = true,
--         border = "rounded",
--         relative = "editor",
--         buf_options = {},
--         win_options = {
--           cursorline = true,
--           cursorlineopt = "both",
--         },
--         width = nil,
--         max_width = { 140, 0.8 },
--         min_width = { 40, 0.2 },
--         height = nil,
--         max_height = 0.9,
--         min_height = { 10, 0.2 },
--         mappings = {
--           ["<Esc>"] = "Close",
--           ["<C-c>"] = false,
--           ["<CR>"] = "Confirm",
--         },
--         override = function(conf)
--           return conf
--         end,
--       },
--       format_item_override = {},
--       get_config = nil,
--     }
--   }
-- }


return {
  "folke/snacks.nvim",
  optional = true,
  highlights = {
    { "SnacksInputNormal", bg = vim.__color.dark0 },
    { "SnacksInputBorder", bg = vim.__color.dark0, fg = vim.__color.dark2 },
    { "SnacksInputTitle", link = "FloatTitle" },
    { "SnacksInputIcon", fg = vim.__color.bright_blue },
  },
  opts = {
    input = {
      enabled = true,
      icon = " ",
      icon_hl = "SnacksInputIcon",
      icon_pos = "left",
      prompt_pos = "title",
      expand = false, -- 如果文本超出宽度自动扩展
    },
    styles = {
      input = {
        backdrop = false,
        border = vim.__icons.border.yes,
        title_pos = "center",
        height = 1,
        width = 30,
        noautocmd = true,
        -- relative = "editor",
        -- row = 2,
        relative = "cursor",
        row = -1,
        col = 1,
        wo = {
          winhighlight = "NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
          cursorline = false,
        },
        bo = {
          filetype = "viminput",
          buftype = "prompt",
        },
        b = {
          completion = true,
        },
        keys = {
          n_esc = false,
          q = false,
          i_esc = { "<esc>", { "cancel" }, mode = "i", expr = true },
          i_cr = { "<cr>", { "confirm" }, mode = "i", expr = true },
          i_tab = { "<tab>", { "cmp_accept", "<tab>" }, mode = "i", expr = true },
          i_ctrl_w = { "<c-w>", "<c-s-w>", mode = "i", expr = true },
          i_up = false,
          i_down = false,
        },
      },
    }
  }
}
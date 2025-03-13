-- local etypes = vim.__event.types

-- return {
--   {
--     -- 由于该插件仅渲染需要的部分(scope)，故它为性能问题的最佳解决方案
--     "echasnovski/mini.indentscope",
--     enabled = false,
--     lazy = true,
--     event = "VeryLazy",
--     opts = function()
--       vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { link = "IndentGuide" })

--       vim.__event.rg(etypes.FILE_TYPE, function(state)
--         if vim.__filter.contain_fts(vim.__buf.filetype(state.buf)) then
--           vim.b.miniindentscope_disable = true
--         end
--       end)

--       return {
--         draw = {
--           delay = 65,
--           priority = 2,
--         },
--         options = {
--           border = "both",
--           indent_at_cursor = true,
--           try_as_border = true,
--         },
--         symbol = vim.__icons.indent_guid,
--       }
--     end
--   },
--   {
--     "lukas-reineke/indent-blankline.nvim",
--     enabled = false,
--     lazy = true,
--     event = "VeryLazy",
--     cmd = { "IBLEnable", "IBLDisable", "IBLToggle", "IBLEnableScope", "IBLDisableScope", "IBLToggleScope" },
--     main = "ibl",
--     opts = function()
--       vim.api.nvim_set_hl(0, "IblIndent", { link = "IndentGuide" })
--       vim.api.nvim_set_hl(0, "IblScope", { fg = vim.__color.dark2 })

--       return {
--         -- viewport_buffer = {
--         --   min = 30, -- increase this value might be fix strange split
--         -- },
--         debounce = 70,
--         indent = {
--           char = vim.__icons.indent_guid,
--           repeat_linebreak = false,
--         },
--         scope = {
--           enabled = false,
--         }
--       }
--     end,
--   },
--   {
--     "shellRaining/hlchunk.nvim",
--     enabled = false,
--     lazy = true,
--     event = "VeryLazy",
--     opts = {
--       indent = {
--         enable = true,
--         style = "#3f3b38",
--         chars = { vim.__icons.indent_guid },
--         ahead_lines = 5,
--         delay = 70,
--       }
--     }
--   },
-- }

-- return {
--   "nvimdev/indentmini.nvim",
--   lazy = true,
--   event = "VeryLazy",
--   opts = function ()
--     vim.api.nvim_set_hl(0, "IndentLine", { link = "IndentGuide" })
--     vim.api.nvim_set_hl(0, "IndentLineCurrent", { link = "IndentGuide" })
--     return {
--       char = vim.__icons.indent_guid,
--       exclude = vim.__filter.filetypes[1]
--     }
--   end,
-- }

return {
  "shellRaining/hlchunk.nvim",
  lazy = true,
  event = "VeryLazy",
  opts = {
    indent = {
      enable = true,
      style = "#3f3b38",
      chars = { vim.__icons.indent_guid },
      ahead_lines = 5,
      delay = 70,
      exclude_filetypes = vim.__filter.filetypes_m[1],
    }
  }
}

-- local exclude_bufnrs = {}
-- return {
--   "folke/snacks.nvim",
--   optional = true,
--   autocmds = {
--     {
--       "FileType",
--       function(state)
--         exclude_bufnrs[state.buf] = true
--       end,
--       pattern = vim.__filter.filetypes[1]
--     }
--   },
--   opts = {
--     indent = {
--       enabled = true,
--       indent = {
--         enabled = true,
--         char = vim.__icons.indent_guid,
--         only_scope = false,
--         only_current = false,
--         hl = "IndentGuide",
--       },
--       animate = {
--         enabled = false,
--       },
--       scope = {
--         enabled = false,
--       },
--       chunk = {
--         enabled = false,
--       },
--       filter = function(buf)
--         return not exclude_bufnrs[buf]
--       end,
--     },
--   }
-- }
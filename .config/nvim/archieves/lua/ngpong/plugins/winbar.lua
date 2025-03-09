return {
  "Bekaboo/dropbar.nvim",
  enabled = false,
  lazy = true,
  event = { "LazyFile", "VeryLazy" },
  opts = {
    bar = {
      enable = function(buf, win, _)
        if
          not vim.api.nvim_buf_is_valid(buf)
          or not vim.api.nvim_win_is_valid(win)
          or vim.fn.win_gettype(win) ~= ''
          or vim.wo[win].winbar ~= ''
          or vim.bo[buf].ft == 'help'
        then
          return false
        end

        return vim.bo[buf].ft == 'markdown'
          or pcall(vim.treesitter.get_parser, buf)
          or not vim.tbl_isempty(vim.lsp.get_clients({
            bufnr = buf,
            method = 'textDocument/documentSymbol',
          }))
      end,
      -- sources = function()
      --   local sources = require('dropbar.sources')
      --   local utils = require('dropbar.utils')

      --   return {
      --     sources.path,
      --     utils.source.fallback({
      --       sources.treesitter,
      --     }),
      --   }
      -- end
    }
  }
}

-- return {
--   "NGPONG/barbecue.nvim",
--   lazy = true,
--   event = { "LazyFile", "VeryLazy" },
--   dependencies = {
--     "SmiteshP/nvim-navic",
--     "nvim-lua/plenary.nvim",
--   },
--   opts = {
--     include_buftypes = { "" },
--     exclude_filetypes = vim.__filter.filetypes[1],
--     attach_filter = function(state)
--       local cli = vim.lsp.get_client_by_id(state.data.client_id)
--       if not cli then return false end

--       return vim.__buf.size(state.bufnr) < vim.__filter.max_size[1] and
--              cli:supports_method("textDocument/documentSymbol")
--     end,
--     modifiers = {
--       dirname = ":~:.",
--       basename = "",
--     },
--     show_dirname = true,
--     split_dirname = true,
--     show_basename = true,
--     show_modified = false,
--     modified = function(bufnr) return vim.bo[bufnr].modified end,
--     show_navic = true,
--     lead_custom_section = function() return "" end,
--     custom_section = function() return "" end,
--     context_follow_icon_color = false,
--     context_suffix = vim.__icons.space,
--     symbols = {
--       modified = vim.__icons.circular_big,
--       ellipsis = vim.__icons.ellipsis,
--       separator = "",
--       dir = vim.__icons.directory,
--     },
--     theme = {
--       normal                 = { fg = vim.__color.light2, bold = false },
--       ellipsis               = { fg = vim.__color.light2 },
--       separator              = { fg = vim.__color.light2 },
--       dirname                = { fg = vim.__color.light2 },
--       diricon                = { link = "DirectoryIcon" },
--       modified               = { fg = vim.__color.light2 },
--       basename               = { bold = false, fg = vim.__color.light2 },
--       -- context_file           = vim.__icons.lsp_kinds.File.hl,
--       -- context_module         = vim.__icons.lsp_kinds.Module.hl,
--       -- context_namespace      = vim.__icons.lsp_kinds.Namespace.hl,
--       -- context_package        = vim.__icons.lsp_kinds.Package.hl,
--       -- context_class          = vim.__icons.lsp_kinds.Class.hl,
--       -- context_method         = vim.__icons.lsp_kinds.Method.hl,
--       -- context_property       = vim.__icons.lsp_kinds.Property.hl,
--       -- context_field          = vim.__icons.lsp_kinds.Field.hl,
--       -- context_constructor    = vim.__icons.lsp_kinds.Constructor.hl,
--       -- context_enum           = vim.__icons.lsp_kinds.Enum.hl,
--       -- context_interface      = vim.__icons.lsp_kinds.Interface.hl,
--       -- context_function       = vim.__icons.lsp_kinds.Function.hl,
--       -- context_variable       = vim.__icons.lsp_kinds.Variable.hl,
--       -- context_constant       = vim.__icons.lsp_kinds.Constant.hl,
--       -- context_string         = vim.__icons.lsp_kinds.String.hl,
--       -- context_number         = vim.__icons.lsp_kinds.Number.hl,
--       -- context_boolean        = vim.__icons.lsp_kinds.Boolean.hl,
--       -- context_array          = vim.__icons.lsp_kinds.Array.hl,
--       -- context_object         = vim.__icons.lsp_kinds.Object.hl,
--       -- context_key            = vim.__icons.lsp_kinds.Key.hl,
--       -- context_null           = vim.__icons.lsp_kinds.Null.hl,
--       -- context_enum_member    = vim.__icons.lsp_kinds.EnumMember.hl,
--       -- context_struct         = vim.__icons.lsp_kinds.Struct.hl,
--       -- context_event          = vim.__icons.lsp_kinds.Event.hl,
--       -- context_operator       = vim.__icons.lsp_kinds.Operator.hl,
--       -- context_type_parameter = vim.__icons.lsp_kinds.TypeParameter.hl,
--     },
--     kinds = {
--       File          = vim.__icons.lsp_kinds.File.val,
--       Module        = vim.__icons.lsp_kinds.Module.val,
--       Namespace     = vim.__icons.lsp_kinds.Namespace.val,
--       Package       = vim.__icons.lsp_kinds.Package.val,
--       Class         = vim.__icons.lsp_kinds.Class.val,
--       Method        = vim.__icons.lsp_kinds.Method.val,
--       Property      = vim.__icons.lsp_kinds.Property.val,
--       Field         = vim.__icons.lsp_kinds.Field.val,
--       Constructor   = vim.__icons.lsp_kinds.Constructor.val,
--       Enum          = vim.__icons.lsp_kinds.Enum.val,
--       Interface     = vim.__icons.lsp_kinds.Interface.val,
--       Function      = vim.__icons.lsp_kinds.Function.val,
--       Variable      = vim.__icons.lsp_kinds.Variable.val,
--       Constant      = vim.__icons.lsp_kinds.Constant.val,
--       String        = vim.__icons.lsp_kinds.String.val,
--       Number        = vim.__icons.lsp_kinds.Number.val,
--       Boolean       = vim.__icons.lsp_kinds.Boolean.val,
--       Array         = vim.__icons.lsp_kinds.Array.val,
--       Object        = vim.__icons.lsp_kinds.Object.val,
--       Key           = vim.__icons.lsp_kinds.Key.val,
--       Null          = vim.__icons.lsp_kinds.Null.val,
--       EnumMember    = vim.__icons.lsp_kinds.EnumMember.val,
--       Struct        = vim.__icons.lsp_kinds.Struct.val,
--       Event         = vim.__icons.lsp_kinds.Event.val,
--       Operator      = vim.__icons.lsp_kinds.Operator.val,
--       TypeParameter = vim.__icons.lsp_kinds.TypeParameter.val,
--     },
--   },
--   config = function(_, opts)
--     vim.api.nvim_set_hl(0, "WinBarNC", { link = "WinBar" })

--     require("barbecue").setup(opts)
--   end
-- }
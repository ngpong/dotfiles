local M = {}

local events      = require('ngpong.common.events')
local icons       = require('ngpong.utils.icon')
local navic       = require('nvim-navic')
local barbecue    = require('barbecue')
local barbecue_ui = require('barbecue.ui')

local this = PLGS.barbecue
local colors = PLGS.colorscheme.colors
local e_events = events.e_name

M.setup = function()
  barbecue.setup {
    attach_navic = false,
    create_autocmd = false,
    include_buftypes = { '' },
    exclude_filetypes = this.filter(1),
    modifiers = {
      dirname = ':~:.',
      basename = '',
    },
    show_dirname = true,
    show_basename = true,
    show_modified = false,
    modified = function(bufnr) return vim.bo[bufnr].modified end,
    show_navic = true,
    lead_custom_section = function() return '' end,
    custom_section = function() return '' end,
    context_follow_icon_color = false,
    symbols = {
      modified = icons.circular_big,
      ellipsis = icons.ellipsis,
      separator = icons.separator,
    },
    theme = {
      normal = { fg = colors.light1, bold = true },

      ellipsis = { fg = colors.light4 },
      separator = { fg = colors.light4 },
      dirname = { fg = colors.bright_blue, italic = true, bold = false },
      modified = { fg = colors.light4 },
      basename = { bold = true, fg = colors.light1 },

      context_file = { link = icons.lsp_kinds.File.hl_link },
      context_module = { link = icons.lsp_kinds.Module.hl_link },
      context_namespace = { link = icons.lsp_kinds.Namespace.hl_link },
      context_package = { link = icons.lsp_kinds.Package.hl_link },
      context_class = { link = icons.lsp_kinds.Class.hl_link },
      context_method = { link = icons.lsp_kinds.Method.hl_link },
      context_property = { link = icons.lsp_kinds.Property.hl_link },
      context_field = { link = icons.lsp_kinds.Field.hl_link },
      context_constructor = { link = icons.lsp_kinds.Constructor.hl_link },
      context_enum = { link = icons.lsp_kinds.Enum.hl_link },
      context_interface = { link = icons.lsp_kinds.Interface.hl_link },
      context_function = { link = icons.lsp_kinds.Function.hl_link },
      context_variable = { link = icons.lsp_kinds.Variable.hl_link },
      context_constant = { link = icons.lsp_kinds.Constant.hl_link },
      context_string = { link = icons.lsp_kinds.String.hl_link },
      context_number = { link = icons.lsp_kinds.Number.hl_link },
      context_boolean = { link = icons.lsp_kinds.Boolean.hl_link },
      context_array = { link = icons.lsp_kinds.Array.hl_link },
      context_object = { link = icons.lsp_kinds.Object.hl_link },
      context_key = { link = icons.lsp_kinds.Key.hl_link },
      context_null = { link = icons.lsp_kinds.Null.hl_link },
      context_enum_member = { link = icons.lsp_kinds.EnumMember.hl_link },
      context_struct = { link = icons.lsp_kinds.Struct.hl_link },
      context_event = { link = icons.lsp_kinds.Event.hl_link },
      context_operator = { link = icons.lsp_kinds.Operator.hl_link },
      context_type_parameter = { link = icons.lsp_kinds.TypeParameter.hl_link },
    },
    kinds = {
      File          = icons.lsp_kinds.File.val,
      Module        = icons.lsp_kinds.Module.val,
      Namespace     = icons.lsp_kinds.Namespace.val,
      Package       = icons.lsp_kinds.Package.val,
      Class         = icons.lsp_kinds.Class.val,
      Method        = icons.lsp_kinds.Method.val,
      Property      = icons.lsp_kinds.Property.val,
      Field         = icons.lsp_kinds.Field.val,
      Constructor   = icons.lsp_kinds.Constructor.val,
      Enum          = icons.lsp_kinds.Enum.val,
      Interface     = icons.lsp_kinds.Interface.val,
      Function      = icons.lsp_kinds.Function.val,
      Variable      = icons.lsp_kinds.Variable.val,
      Constant      = icons.lsp_kinds.Constant.val,
      String        = icons.lsp_kinds.String.val,
      Number        = icons.lsp_kinds.Number.val,
      Boolean       = icons.lsp_kinds.Boolean.val,
      Array         = icons.lsp_kinds.Array.val,
      Object        = icons.lsp_kinds.Object.val,
      Key           = icons.lsp_kinds.Key.val,
      Null          = icons.lsp_kinds.Null.val,
      EnumMember    = icons.lsp_kinds.EnumMember.val,
      Struct        = icons.lsp_kinds.Struct.val,
      Event         = icons.lsp_kinds.Event.val,
      Operator      = icons.lsp_kinds.Operator.val,
      TypeParameter = icons.lsp_kinds.TypeParameter.val,
    },
  }

  navic.setup {
    lazy_update_context = true
  }

  barbecue_ui.toggle(true)

  events.rg(e_events.ATTACH_LSP, function(state)
    if this.filter(2, state) then
      navic.attach(state.cli, state.bufnr)

      vim.b[state.bufnr].barbecu_enable = true

      events.emit(e_events.ATTACH_NAVIC, state)
    else
      vim.b[state.bufnr].barbecu_enable = false
    end
  end)
end

return M

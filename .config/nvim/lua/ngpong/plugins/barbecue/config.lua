local M = {}

local Events     = require('ngpong.common.events')
local Icons      = require('ngpong.utils.icon')
local Lazy       = require('ngpong.utils.lazy')
local Navic      = Lazy.require('nvim-navic')
local Barbecue   = Lazy.require('barbecue')
local BarbecueUI = Lazy.require('barbecue.ui')

local this   = Plgs.barbecue
local colors = Plgs.colorscheme.colors
local e_name = Events.e_name

M.setup = function()
  Barbecue.setup {
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
    context_suffix = Icons.space,
    symbols = {
      modified = Icons.circular_big,
      ellipsis = Icons.ellipsis,
      separator = Icons.separator,
      dir = Icons.directory,
    },
    theme = {
      normal = { fg = colors.light1, bold = false },

      ellipsis = { fg = colors.light4 },
      separator = { fg = colors.light4 },
      dirname = { fg = colors.bright_blue },
      diricon = { fg = colors.bright_yellow },
      modified = { fg = colors.light4 },
      basename = { bold = false, fg = colors.light1 },

      context_file = { link = Icons.lsp_kinds.File.hl_link },
      context_module = { link = Icons.lsp_kinds.Module.hl_link },
      context_namespace = { link = Icons.lsp_kinds.Namespace.hl_link },
      context_package = { link = Icons.lsp_kinds.Package.hl_link },
      context_class = { link = Icons.lsp_kinds.Class.hl_link },
      context_method = { link = Icons.lsp_kinds.Method.hl_link },
      context_property = { link = Icons.lsp_kinds.Property.hl_link },
      context_field = { link = Icons.lsp_kinds.Field.hl_link },
      context_constructor = { link = Icons.lsp_kinds.Constructor.hl_link },
      context_enum = { link = Icons.lsp_kinds.Enum.hl_link },
      context_interface = { link = Icons.lsp_kinds.Interface.hl_link },
      context_function = { link = Icons.lsp_kinds.Function.hl_link },
      context_variable = { link = Icons.lsp_kinds.Variable.hl_link },
      context_constant = { link = Icons.lsp_kinds.Constant.hl_link },
      context_string = { link = Icons.lsp_kinds.String.hl_link },
      context_number = { link = Icons.lsp_kinds.Number.hl_link },
      context_boolean = { link = Icons.lsp_kinds.Boolean.hl_link },
      context_array = { link = Icons.lsp_kinds.Array.hl_link },
      context_object = { link = Icons.lsp_kinds.Object.hl_link },
      context_key = { link = Icons.lsp_kinds.Key.hl_link },
      context_null = { link = Icons.lsp_kinds.Null.hl_link },
      context_enum_member = { link = Icons.lsp_kinds.EnumMember.hl_link },
      context_struct = { link = Icons.lsp_kinds.Struct.hl_link },
      context_event = { link = Icons.lsp_kinds.Event.hl_link },
      context_operator = { link = Icons.lsp_kinds.Operator.hl_link },
      context_type_parameter = { link = Icons.lsp_kinds.TypeParameter.hl_link },
    },
    kinds = {
      File          = Icons.lsp_kinds.File.val,
      Module        = Icons.lsp_kinds.Module.val,
      Namespace     = Icons.lsp_kinds.Namespace.val,
      Package       = Icons.lsp_kinds.Package.val,
      Class         = Icons.lsp_kinds.Class.val,
      Method        = Icons.lsp_kinds.Method.val,
      Property      = Icons.lsp_kinds.Property.val,
      Field         = Icons.lsp_kinds.Field.val,
      Constructor   = Icons.lsp_kinds.Constructor.val,
      Enum          = Icons.lsp_kinds.Enum.val,
      Interface     = Icons.lsp_kinds.Interface.val,
      Function      = Icons.lsp_kinds.Function.val,
      Variable      = Icons.lsp_kinds.Variable.val,
      Constant      = Icons.lsp_kinds.Constant.val,
      String        = Icons.lsp_kinds.String.val,
      Number        = Icons.lsp_kinds.Number.val,
      Boolean       = Icons.lsp_kinds.Boolean.val,
      Array         = Icons.lsp_kinds.Array.val,
      Object        = Icons.lsp_kinds.Object.val,
      Key           = Icons.lsp_kinds.Key.val,
      Null          = Icons.lsp_kinds.Null.val,
      EnumMember    = Icons.lsp_kinds.EnumMember.val,
      Struct        = Icons.lsp_kinds.Struct.val,
      Event         = Icons.lsp_kinds.Event.val,
      Operator      = Icons.lsp_kinds.Operator.val,
      TypeParameter = Icons.lsp_kinds.TypeParameter.val,
    },
  }

  Navic.setup {
    lazy_update_context = true
  }

  BarbecueUI.toggle(true)

  Events.rg(e_name.ATTACH_LSP, function(state)
    if this.filter(2, state) then
      Navic.attach(state.cli, state.bufnr)

      vim.b[state.bufnr].barbecu_enable = true

      Events.emit(e_name.ATTACH_NAVIC, state)
    else
      vim.b[state.bufnr].barbecu_enable = false
    end
  end)
end

return M

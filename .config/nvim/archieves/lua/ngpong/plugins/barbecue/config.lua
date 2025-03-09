local M = {}

local Navic      = vim.__lazy.require("nvim-navic")
local Barbecue   = vim.__lazy.require("barbecue")
local BarbecueUI = vim.__lazy.require("barbecue.ui")

local etypes = vim.__event.types

M.setup = function()
  Barbecue.setup {
    attach_navic = false,
    create_autocmd = false,
    include_buftypes = { "" },
    exclude_filetypes = vim.__filter.filetypes[1],
    modifiers = {
      dirname = ":~:.",
      basename = "",
    },
    show_dirname = true,
    show_basename = true,
    show_modified = false,
    modified = function(bufnr) return vim.bo[bufnr].modified end,
    show_navic = true,
    lead_custom_section = function() return "" end,
    custom_section = function() return "" end,
    context_follow_icon_color = false,
    context_suffix = vim.__icons.space,
    symbols = {
      modified = vim.__icons.big_dot,
      ellipsis = vim.__icons.ellipsis,
      separator = vim.__icons.separator,
      dir = vim.__icons.directory,
    },
    theme = {
      normal = { fg = vim.__color.light1, bold = false },

      ellipsis = { fg = vim.__color.light4 },
      separator = { fg = vim.__color.light4 },
      dirname = { fg = vim.__color.bright_blue },
      diricon = { fg = vim.__color.bright_yellow },
      modified = { fg = vim.__color.light4 },
      basename = { bold = false, fg = vim.__color.light1 },

      context_file = { link = vim.__icons.lsp_kinds.File.hl_link },
      context_module = { link = vim.__icons.lsp_kinds.Module.hl_link },
      context_namespace = { link = vim.__icons.lsp_kinds.Namespace.hl_link },
      context_package = { link = vim.__icons.lsp_kinds.Package.hl_link },
      context_class = { link = vim.__icons.lsp_kinds.Class.hl_link },
      context_method = { link = vim.__icons.lsp_kinds.Method.hl_link },
      context_property = { link = vim.__icons.lsp_kinds.Property.hl_link },
      context_field = { link = vim.__icons.lsp_kinds.Field.hl_link },
      context_constructor = { link = vim.__icons.lsp_kinds.Constructor.hl_link },
      context_enum = { link = vim.__icons.lsp_kinds.Enum.hl_link },
      context_interface = { link = vim.__icons.lsp_kinds.Interface.hl_link },
      context_function = { link = vim.__icons.lsp_kinds.Function.hl_link },
      context_variable = { link = vim.__icons.lsp_kinds.Variable.hl_link },
      context_constant = { link = vim.__icons.lsp_kinds.Constant.hl_link },
      context_string = { link = vim.__icons.lsp_kinds.String.hl_link },
      context_number = { link = vim.__icons.lsp_kinds.Number.hl_link },
      context_boolean = { link = vim.__icons.lsp_kinds.Boolean.hl_link },
      context_array = { link = vim.__icons.lsp_kinds.Array.hl_link },
      context_object = { link = vim.__icons.lsp_kinds.Object.hl_link },
      context_key = { link = vim.__icons.lsp_kinds.Key.hl_link },
      context_null = { link = vim.__icons.lsp_kinds.Null.hl_link },
      context_enum_member = { link = vim.__icons.lsp_kinds.EnumMember.hl_link },
      context_struct = { link = vim.__icons.lsp_kinds.Struct.hl_link },
      context_event = { link = vim.__icons.lsp_kinds.Event.hl_link },
      context_operator = { link = vim.__icons.lsp_kinds.Operator.hl_link },
      context_type_parameter = { link = vim.__icons.lsp_kinds.TypeParameter.hl_link },
    },
    kinds = {
      File          = vim.__icons.lsp_kinds.File.val,
      Module        = vim.__icons.lsp_kinds.Module.val,
      Namespace     = vim.__icons.lsp_kinds.Namespace.val,
      Package       = vim.__icons.lsp_kinds.Package.val,
      Class         = vim.__icons.lsp_kinds.Class.val,
      Method        = vim.__icons.lsp_kinds.Method.val,
      Property      = vim.__icons.lsp_kinds.Property.val,
      Field         = vim.__icons.lsp_kinds.Field.val,
      Constructor   = vim.__icons.lsp_kinds.Constructor.val,
      Enum          = vim.__icons.lsp_kinds.Enum.val,
      Interface     = vim.__icons.lsp_kinds.Interface.val,
      Function      = vim.__icons.lsp_kinds.Function.val,
      Variable      = vim.__icons.lsp_kinds.Variable.val,
      Constant      = vim.__icons.lsp_kinds.Constant.val,
      String        = vim.__icons.lsp_kinds.String.val,
      Number        = vim.__icons.lsp_kinds.Number.val,
      Boolean       = vim.__icons.lsp_kinds.Boolean.val,
      Array         = vim.__icons.lsp_kinds.Array.val,
      Object        = vim.__icons.lsp_kinds.Object.val,
      Key           = vim.__icons.lsp_kinds.Key.val,
      Null          = vim.__icons.lsp_kinds.Null.val,
      EnumMember    = vim.__icons.lsp_kinds.EnumMember.val,
      Struct        = vim.__icons.lsp_kinds.Struct.val,
      Event         = vim.__icons.lsp_kinds.Event.val,
      Operator      = vim.__icons.lsp_kinds.Operator.val,
      TypeParameter = vim.__icons.lsp_kinds.TypeParameter.val,
    },
  }

  Navic.setup {
    lazy_update_context = true
  }

  BarbecueUI.toggle(true)

  vim.__event.rg(etypes.ATTACH_LSP, function(state)
    local valid_size   = vim.__buf.size(state.bufnr) < vim.__filter.max_size[1]
    local has_provider = state.cli.server_capabilities.documentSymbolProvider

    if valid_size and has_provider then
      Navic.attach(state.cli, state.bufnr)

      vim.b[state.bufnr].barbecu_enable = true

      vim.__event.emit(etypes.ATTACH_NAVIC, state)
    else
      vim.b[state.bufnr].barbecu_enable = false
    end
  end)

  vim.__event.rg(etypes.DETACH_LSP, function(state)
    vim.__event.emit(etypes.DETACH_NAVIC, state)
  end)
end

return M

local M = {}

local Events = require('ngpong.common.events')
local Icons = require('ngpong.utils.icon')
local Keymap = require('ngpong.common.keybinder')

local e_mode = Keymap.e_mode
local e_name = Events.e_name

local trouble = Plgs.trouble
local telescope = Plgs.telescope

local del_native_keymaps = function() end

local set_native_keymaps = function()
  Keymap.register(e_mode.NORMAL, 'd.', Tools.wrap_f(vim.diagnostic.goto_next, { float = false, wrap = false }), { remap = false, desc = 'jump to next diagnostic.' })
  Keymap.register(e_mode.NORMAL, 'd,', Tools.wrap_f(vim.diagnostic.goto_prev, { float = false, wrap = false }), { remap = false, desc = 'jump to prev diagnostic.' })
  Keymap.register(e_mode.NORMAL, 'dd', Tools.wrap_f(trouble.api.toggle, 'document_diagnostics'), { silent = true, remap = false, desc = 'toggle document diagnostics list.' })
  Keymap.register(e_mode.NORMAL, 'dD', Tools.wrap_f(trouble.api.toggle, 'workspace_diagnostics'), { silent = true, remap = false, desc = 'toggle workspace diagnostics list.' })
  Keymap.register(e_mode.NORMAL, 'dp', function()
    local bufnr, _ = vim.diagnostic.open_float({
      border = 'rounded',
      relative = 'cursor',
      noautocmd = true,
    })

    local maparg = Keymap.get_keymap(e_mode.NORMAL, 'q')
    if maparg then
      Keymap.register(e_mode.NORMAL, 'q', maparg.callback, { buffer = bufnr, desc = maparg.desc, silent = maparg.silent, remap = not maparg.noremap })
    end
  end, { silent = true, remap = false, desc = 'show diagnostic(problems) preview.' })
end

local del_buffer_keymaps = function(_) end

local set_buffer_keymaps = function(state)
  if state.cli.server_capabilities.documentSymbolProvider then
    Keymap.register(e_mode.NORMAL, 'dW', Tools.wrap_f(trouble.api.toggle, 'lsp_document_symbols_extra'), { buffer = state.bufnr, silent = true, remap = false, desc = 'show document symbols in the current buffer.' })
    Keymap.register(e_mode.NORMAL, 'dw', Tools.wrap_f(telescope.api.builtin_picker, 'lsp_document_symbols'), { buffer = state.bufnr, silent = true, remap = false, desc = 'filter document symbols in the current buffer.' })
  end

  if state.cli.server_capabilities.signatureHelpProvider then
    Keymap.register(e_mode.NORMAL, 'dk', vim.lsp.buf.signature_help, { buffer = state.bufnr, remap = false, desc = 'show signature.' })
  end

  if state.cli.server_capabilities.referencesProvider then
    Keymap.register(e_mode.NORMAL, 'dr', Tools.wrap_f(trouble.api.open, 'lsp_references_extra'), { buffer = state.bufnr, silent = true, remap = false, desc = 'get all references to the symbol.' })
  end

  if state.cli.server_capabilities.definitionProvider then
    Keymap.register(e_mode.NORMAL, 'de', Tools.wrap_f(trouble.api.open, 'lsp_definitions_extra'), { buffer = state.bufnr, remap = false, desc = 'jump to definition.' })
  end

  if state.cli.server_capabilities.declarationProvider then
    Keymap.register(e_mode.NORMAL, 'dE', Tools.wrap_f(trouble.api.open, 'lsp_declarations_extra'), { buffer = state.bufnr, remap = false, desc = 'jump to declaration.' })
  end

  if state.cli.server_capabilities.renameProvider then
    Keymap.register(e_mode.NORMAL, 'dn', vim.lsp.buf.rename, { buffer = state.bufnr, remap = false, desc = 'renames all references to the symbol.' })
  end

  if state.cli.server_capabilities.hoverProvider then
    Keymap.register(e_mode.NORMAL, 'di', vim.lsp.buf.hover, { buffer = state.bufnr, remap = false, desc = 'show information(help) about the symbol.' })
  end

  if state.cli.server_capabilities.codeActionProvider then
    Keymap.register(e_mode.NORMAL, 'dc', vim.lsp.buf.code_action, { buffer = state.bufnr, silent = true, remap = false, desc = 'show code-action select menu.' })
  end
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()

  Events.rg(e_name.ATTACH_LSP, function(state)
    del_buffer_keymaps(state)
    set_buffer_keymaps(state)
  end)
end

return M

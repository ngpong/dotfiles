local M = {}

local events = require('ngpong.common.events')
local keymap = require('ngpong.common.keybinder')
local lazy   = require('ngpong.utils.lazy')
local icons  = require('ngpong.utils.icon')

local e_mode   = keymap.e_mode
local e_events = events.e_name

local touble = PLGS.trouble

local del_native_keymaps = function()
end

local set_native_keymaps = function()
  keymap.register(e_mode.NORMAL, 'd.', TOOLS.wrap_f(vim.diagnostic.goto_next, { float = false }), { remap = false, desc = 'jump to next diagnostic.' })
  keymap.register(e_mode.NORMAL, 'd,', TOOLS.wrap_f(vim.diagnostic.goto_prev, { float = false }), { remap = false, desc = 'jump to prev diagnostic.' })
  keymap.register(e_mode.NORMAL, 'dd', TOOLS.wrap_f(touble.api.open, 'document_diagnostics'), { silent = true, remap = false, desc = 'toggle document diagnostics list.' })
  keymap.register(e_mode.NORMAL, 'dD', TOOLS.wrap_f(touble.api.open, 'workspace_diagnostics'), { silent = true, remap = false, desc = 'toggle workspace diagnostics list.' })
  keymap.register(e_mode.NORMAL, 'dp', TOOLS.wrap_f(vim.diagnostic.open_float, {
    border = 'rounded',
    relative = 'cursor',
    noautocmd = true
  }), { silent = true, remap = false, desc = 'show diagnostic(problems) preview.' })
end

local del_buffer_keymaps = function(_)
end

local set_buffer_keymaps = function(state)
  if state.cli.server_capabilities.documentSymbolProvider then
    keymap.register(e_mode.NORMAL, 'dw', TOOLS.wrap_f(lazy.access('telescope.builtin', 'lsp_document_symbols'), {
      show_line = true,
      symbol_type_width = 12,
      symbol_width = 50,
      symbol_highlights = icons.get_all_lsp_hllink()
    }), { buffer = state.bufnr, silent = true, remap = false, desc = 'show document symbols in the current buffer.' })
  end

  if state.cli.server_capabilities.signatureHelpProvider then
    keymap.register(e_mode.NORMAL, 'dk', vim.lsp.buf.signature_help, { buffer = state.bufnr, remap = false, desc = 'show signature.' })
  end

  if state.cli.server_capabilities.referencesProvider then
    keymap.register(e_mode.NORMAL, 'dr', TOOLS.wrap_f(vim.lsp.buf.references, nil, {
      on_list = function(options)
        vim.fn.setloclist(0, {}, ' ', options)
        touble.api.open('loclist', 'Lsp references')
      end
    }), { buffer = state.bufnr, silent = true, remap = false, desc = 'get all references to the symbol.' })
  end

  if state.cli.server_capabilities.definitionProvider then
    keymap.register(e_mode.NORMAL, 'de', TOOLS.wrap_f(vim.lsp.buf.definition, {
      on_list = function(options)
        if #options.items == 1 then
          vim.lsp.util.jump_to_location(options.items[1].user_data, vim.lsp.buf_get_clients()[1].offset_encoding, false)
        else
          vim.fn.setloclist(0, {}, ' ', options)
          touble.api.open('loclist', 'Lsp definitions')
        end
      end
    }), { buffer = state.bufnr, remap = false, desc = 'jump to definition.' })
  end

  if state.cli.server_capabilities.declarationProvider then
    keymap.register(e_mode.NORMAL, 'dE', TOOLS.wrap_f(vim.lsp.buf.declaration, {
      on_list = function(options)
        if #options.items == 1 then
          vim.lsp.util.jump_to_location(options.items[1].user_data, vim.lsp.buf_get_clients()[1].offset_encoding, false)
        else
          vim.fn.setloclist(0, {}, ' ', options)
          touble.api.open('loclist', 'Lsp declaration')
        end
      end
    }), { buffer = state.bufnr, remap = false, desc = 'jump to declaration.' })
  end

  if state.cli.server_capabilities.renameProvider then
    keymap.register(e_mode.NORMAL, 'dn', vim.lsp.buf.rename, { buffer = state.bufnr, remap = false, desc = 'renames all references to the symbol.' })
  end

  if state.cli.server_capabilities.hoverProvider then
    keymap.register(e_mode.NORMAL, 'di', vim.lsp.buf.hover, { buffer = state.bufnr, remap = false, desc = 'show information(help) about the symbol.' })
  end

  if state.cli.server_capabilities.codeActionProvider then
    keymap.register(e_mode.NORMAL, 'dc', vim.lsp.buf.code_action, { buffer = state.bufnr, silent = true, remap = false, desc = 'show code-action select menu.' })
  end
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()

  events.rg(e_events.ATTACH_LSP, function(state)
    del_buffer_keymaps(state)
    set_buffer_keymaps(state)
  end)
end

return M

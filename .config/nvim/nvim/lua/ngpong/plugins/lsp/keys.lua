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
end

local del_buffer_keymaps = function(bufnr)
end

local set_buffer_keymaps = function(bufnr)
  keymap.register(e_mode.NORMAL, 'dn', vim.lsp.buf.rename, { buffer = bufnr, remap = false, desc = 'renames all references to the symbol.' })
  keymap.register(e_mode.NORMAL, 'de', TOOLS.wrap_f(vim.lsp.buf.definition, {
    on_list = function(options)
      if #options.items == 1 then
        vim.lsp.util.jump_to_location(options.items[1].user_data, vim.lsp.buf_get_clients()[1].offset_encoding, false)
      else
        vim.fn.setloclist(0, {}, ' ', options)
        touble.api.open('loclist', 'Lsp definitions')
      end
    end
  }), { buffer = bufnr, remap = false, desc = 'jump to definition.' })
  keymap.register(e_mode.NORMAL, 'dE', TOOLS.wrap_f(vim.lsp.buf.declaration, {
    on_list = function(options)
      if #options.items == 1 then
        vim.lsp.util.jump_to_location(options.items[1].user_data, vim.lsp.buf_get_clients()[1].offset_encoding, false)
      else
        vim.fn.setloclist(0, {}, ' ', options)
        touble.api.open('loclist', 'Lsp definitions')
      end
    end
  }), { buffer = bufnr, remap = false, desc = 'jump to declaration.' })
  keymap.register(e_mode.NORMAL, 'di', vim.lsp.buf.hover, { buffer = bufnr, remap = false, desc = 'show information(help) about the symbol.' })
  keymap.register(e_mode.NORMAL, 'dk', vim.lsp.buf.signature_help, { buffer = bufnr, remap = false, desc = 'show signature.' })
  keymap.register(e_mode.NORMAL, 'dp', TOOLS.wrap_f(vim.diagnostic.open_float, {
    border = 'rounded',
    relative = 'cursor',
    noautocmd = true
  }), { buffer = bufnr, silent = true, remap = false, desc = 'show diagnostic(problems) preview.' })
  keymap.register(e_mode.NORMAL, 'dc', vim.lsp.buf.code_action, { buffer = bufnr, silent = true, remap = false, desc = 'show code-action select menu.' })
  keymap.register(e_mode.NORMAL, 'dr', TOOLS.wrap_f(vim.lsp.buf.references, nil, {
    on_list = function(options)
      vim.fn.setloclist(0, {}, ' ', options)
      touble.api.open('loclist', 'Lsp references')
    end
  }), { buffer = bufnr, silent = true, remap = false, desc = 'get all references to the symbol.' })
  keymap.register(e_mode.NORMAL, 'dw', TOOLS.wrap_f(lazy.access('telescope.builtin', 'lsp_document_symbols'), {
    show_line = true,
    symbol_type_width = 12,
    symbol_width = 50,
    symbol_highlights = icons.get_all_lsp_hllink()
  }), { buffer = bufnr, silent = true, remap = false, desc = 'show document symbols in the current buffer.' })
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()

  events.rg(e_events.ATTACH_LSP, function(state)
    del_buffer_keymaps(state.bufnr)
    set_buffer_keymaps(state.bufnr)
  end)
end

return M
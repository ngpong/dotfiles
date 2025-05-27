local M = {}

local kmodes = vim.__key.e_mode
local etypes = vim.__event.types

local t_api = vim._plugins.trouble.api

local del_native_keymaps = function() end

local set_native_keymaps = function()
  vim.__key.rg(kmodes.N, "d]", function()
    local bufnr = vim.__buf.current()
    local success, float_winid = pcall(vim.api.nvim_buf_get_var, bufnr, "lsp_floating_preview")

    local reopen
    if success and float_winid and vim.__win.is_valid(float_winid) then
      reopen = true
    end

    local next = vim.diagnostic.jump({ count = 1, float = false, wrap = false })

    if reopen and next then
      vim.__win.close(float_winid)

      vim.__async.schedule(function()
        vim.__key.feed("dp", "gUiw")
      end)
    end
  end, { desc = "jump to next diagnostic." })
  vim.__key.rg(kmodes.N, "d[", function()
    local bufnr = vim.__buf.current()
    local success, float_winid = pcall(vim.api.nvim_buf_get_var, bufnr, "lsp_floating_preview")

    local reopen
    if success and float_winid and vim.__win.is_valid(float_winid) then
      reopen = true
    end

    local next = vim.diagnostic.jump({ count = -1, float = false, wrap = false })

    if reopen and next then
      vim.__win.close(float_winid)

      vim.__async.schedule(function()
        vim.__key.feed("dp", "gUiw")
      end)
    end
  end, { desc = "jump to prev diagnostic." })
  vim.__key.rg(kmodes.N, "dd", vim.__util.wrap_f(t_api.toggle, "document_diagnostics"), { silent = true, desc = "toggle document diagnostics list." })
  vim.__key.rg(kmodes.N, "dD", vim.__util.wrap_f(t_api.toggle, "workspace_diagnostics"), { silent = true, desc = "toggle workspace diagnostics list." })
  vim.__key.rg(kmodes.N, "dp", function()
    local bufnr, _ = vim.diagnostic.open_float({
      border = "rounded",
      relative = "cursor",
      noautocmd = true,
    })

    local maparg = vim.__key.get(kmodes.N, "q")
    if maparg then
      vim.__key.rg(kmodes.N, "q", maparg.callback, { buffer = bufnr, desc = maparg.desc, silent = maparg.silent, remap = not maparg.noremap })
    end
  end, { silent = true, desc = "show diagnostic(problems) preview." })
end

local del_buffer_keymaps = function(_) end

local set_buffer_keymaps = function(state)
  if state.cli.server_capabilities.documentSymbolProvider then
    vim.__key.rg(kmodes.N, "dw", function()
      t_api.toggle("lsp_document_symbols_extra")
    end, { buffer = state.bufnr, silent = true, desc = "show document symbols in the current buffer." })
  end

  if state.cli.server_capabilities.signatureHelpProvider then
    vim.__key.rg(kmodes.N, "dk", vim.lsp.buf.signature_help, { buffer = state.bufnr, desc = "show signature." })
  end

  if state.cli.server_capabilities.referencesProvider then
    vim.__key.rg(kmodes.N, "dr", vim.__util.wrap_f(t_api.open, "lsp_references_extra"), { buffer = state.bufnr, silent = true, desc = "get all references to the symbol." })
  end

  if state.cli.server_capabilities.definitionProvider then
    vim.__key.rg(kmodes.N, "de", vim.__util.wrap_f(t_api.open, "lsp_definitions_extra"), { buffer = state.bufnr, desc = "jump to definition." })
  end

  if state.cli.server_capabilities.declarationProvider then
    vim.__key.rg(kmodes.N, "dE", vim.__util.wrap_f(t_api.open, "lsp_declarations_extra"), { buffer = state.bufnr, desc = "jump to declaration." })
  end

  if state.cli.server_capabilities.renameProvider then
    vim.__key.rg(kmodes.N, "dn", vim.lsp.buf.rename, { buffer = state.bufnr, desc = "renames all references to the symbol." })
  end

  if state.cli.server_capabilities.hoverProvider then
    vim.__key.rg(kmodes.N, "di", vim.lsp.buf.hover, { buffer = state.bufnr, desc = "show information(help) about the symbol." })
  end

  if state.cli.server_capabilities.codeActionProvider then
    vim.__key.rg(kmodes.N, "dc", vim.lsp.buf.code_action, { buffer = state.bufnr, silent = true, desc = "show code-action select menu." })
  end
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()

  vim.__event.rg(etypes.ATTACH_LSP, function(state)
    del_buffer_keymaps(state)
    set_buffer_keymaps(state)
  end)
end

return M

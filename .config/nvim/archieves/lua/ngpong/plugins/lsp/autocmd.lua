local M = {}

local etypes = vim.__event.types

local setup_autocmd = function()
  local group = vim.__autocmd.augroup("lsp")

  group:on("LspAttach", function(args)
    vim.__event.emit(etypes.ATTACH_LSP, { cli = vim.lsp.get_client_by_id(args.data.client_id), bufnr = args.buf })
  end)

  group:on("LspDetach", function(args)
    vim.__event.emit(etypes.DETACH_LSP, { cli = vim.lsp.get_client_by_id(args.data.client_id), bufnr = args.buf })
  end)
end

M.setup = function()
  setup_autocmd()
end

return M

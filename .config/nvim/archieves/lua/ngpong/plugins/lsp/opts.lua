local M = {}

local etypes = vim.__event.types

local setup_signs = function()
  vim.fn.sign_define("DiagnosticSignError", { text = vim.__icons.diagnostic_err })
  vim.fn.sign_define("DiagnosticSignWarn", { text = vim.__icons.diagnostic_warn })
  vim.fn.sign_define("DiagnosticSignInfo", { text = vim.__icons.diagnostic_info })
  vim.fn.sign_define("DiagnosticSignHint", { text = vim.__icons.diagnostic_hint })
end

local setup_options = function(state)
  -- https://neovim.io/doc/user/lsp.html#lsp-quickstart
  vim.bo[state.bufnr].formatexpr = nil
  vim.bo[state.bufnr].omnifunc = nil
  vim.bo[state.bufnr].tagfunc = nil

  -- 禁用日志
  vim.lsp.set_log_level("off")
end

M.setup = function ()
  setup_signs()

  vim.__event.rg(etypes.ATTACH_LSP, function(state)
    setup_options(state)
  end)
end

return M

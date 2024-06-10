local M = {}

local Icons  = require('ngpong.utils.icon')
local Events = require('ngpong.common.events')

local e_name = Events.e_name

local setup_signs = function()
  vim.fn.sign_define('DiagnosticSignError', { text = Icons.diagnostic_err })
  vim.fn.sign_define('DiagnosticSignWarn', { text = Icons.diagnostic_warn })
  vim.fn.sign_define('DiagnosticSignInfo', { text = Icons.diagnostic_info })
  vim.fn.sign_define('DiagnosticSignHint', { text = Icons.diagnostic_hint })
end

local setup_options = function(state)
  -- https://neovim.io/doc/user/lsp.html#lsp-quickstart
  vim.bo[state.bufnr].formatexpr = nil
  vim.bo[state.bufnr].omnifunc = nil
  vim.bo[state.bufnr].tagfunc = nil

  -- 禁用日志
  vim.lsp.set_log_level('off')
end

M.setup = function ()
  setup_signs()

  Events.rg(e_name.ATTACH_LSP, function(state)
    setup_options(state)
  end)
end

return M

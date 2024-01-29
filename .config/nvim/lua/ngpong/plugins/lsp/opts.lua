local M = {}

local icons  = require('ngpong.utils.icon')
local events = require('ngpong.common.events')

local e_events = events.e_name

local setup_signs = function()
  vim.fn.sign_define('DiagnosticSignError', { text = icons.diagnostic_err, texthl = 'DiagnosticSignError'})
  vim.fn.sign_define('DiagnosticSignWarn', { text = icons.diagnostic_warn, texthl = 'DiagnosticSignWarn'})
  vim.fn.sign_define('DiagnosticSignInfo', { text = icons.diagnostic_info, texthl = 'DiagnosticSignInfo'})
  vim.fn.sign_define('DiagnosticSignHint', { text = icons.diagnostic_hint, texthl = 'DiagnosticSignHint' })
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

  events.rg(e_events.ATTACH_LSP, function(state)
    setup_options(state)
  end)
end

return M

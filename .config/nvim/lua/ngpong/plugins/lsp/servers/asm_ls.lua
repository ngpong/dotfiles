
local M = {}

local lazy   = require('ngpong.utils.lazy')
local lspcfg = lazy.require('lspconfig')

local setup_server = function(cfg)
  lspcfg.asm_lsp.setup({
    cmd = {
      'asm-lsp',
    },
    filetypes = { 'asm', 'vmasm' },
    capabilities = cfg.cli_capabilities(),
    on_attach = cfg.on_attach()
  })
end

M.setup = function(cfg)
  setup_server(cfg)
end

return M

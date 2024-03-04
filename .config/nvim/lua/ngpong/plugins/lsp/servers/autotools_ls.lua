
local M = {}

local lazy   = require('ngpong.utils.lazy')
local lspcfg = lazy.require('lspconfig')

local setup_server = function(cfg)
  lspcfg.autotools_ls.setup({
    cmd = {
      'autotools-language-server',
    },
    filetypes = { 'config', 'automake', 'make' },
    single_file_support = true,
    capabilities = cfg.cli_capabilities(),
    on_attach = cfg.on_attach()
  })
end

M.setup = function(cfg)
  setup_server(cfg)
end

return M

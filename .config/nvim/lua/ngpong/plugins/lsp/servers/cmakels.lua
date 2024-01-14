
local M = {}

local lspcfg = require('lspconfig')

local setup_server = function(cfg)
  lspcfg.cmake.setup({
    cmd = {
      'cmake-language-server',
    },
    single_file_support = true,
    init_options = {
      buildDirectory = 'build'
    },
    filetypes = { 'cmake' },
    capabilities = cfg.cli_capabilities(),
    on_attach = cfg.on_attach()
  })
end

M.setup = function(cfg)
  setup_server(cfg)
end

return M

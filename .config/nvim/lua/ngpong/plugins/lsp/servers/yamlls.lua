local M = {}

local lspcfg = require('lspconfig')

local setup_server = function(cfg)
  lspcfg.yamlls.setup({
    cmd = {
      'yaml-language-server',
      '--stdio'
    },
    single_file_support = true,
    settings = {
      redhat = {
        telemetry = {
          enabled = false
        }
      },
      -- yaml = {
      --   format = {
      --     enable = false,
      --   },
      --   -- schemaStore = {
      --   --   enable = true
      --   -- },
      --   -- http = {
      --   --   proxy = 'http://192.168.1.2:7890',
      --   -- },
      -- },
    },
    filetypes = { "yaml", "yaml.docker-compose" },
    capabilities = cfg.cli_capabilities(),
    on_attach = cfg.on_attach()
  })
end

M.setup = function(cfg)
  setup_server(cfg)
end

return M

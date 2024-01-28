
local M = {}

local lazy   = require('ngpong.utils.lazy')
local lspcfg = lazy.require('lspconfig')

local setup_server = function(cfg)
  lspcfg.bashls.setup({
    cmd = {
      'bash-language-server',
      'start',
    },
    single_file_support = true,
    filetypes = { 'sh' },
    settings = {
      bashIde = {
        globPattern = '*@(.sh|.inc|.bash|.command)',
        shellcheckArguments = {
          '--exclude=SC2034',
        }
      }
    },
    capabilities = cfg.cli_capabilities(),
    on_attach = cfg.on_attach()
  })
end

M.setup = function(cfg)
  setup_server(cfg)
end

return M

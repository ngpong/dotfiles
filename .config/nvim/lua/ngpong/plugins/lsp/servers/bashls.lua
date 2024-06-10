
local M = {}

local Lazy   = require('ngpong.utils.lazy')
local Lspcfg = Lazy.require('lspconfig')

local setup_server = function(cfg)
  Lspcfg.bashls.setup({
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

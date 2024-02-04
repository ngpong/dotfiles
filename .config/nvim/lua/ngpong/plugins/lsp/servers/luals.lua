local M = {}

local lazy   = require('ngpong.utils.lazy')
local lspcfg = lazy.require('lspconfig')

M.setup = function(cfg)
  lspcfg.lua_ls.setup {
    cmd = {
      'lua-language-server',
      -- '--configpath=~/.config/lua_ls/.luarc.json'
      -- --loglevel=trace
    },
    single_file_support = true,
    filetypes = { 'lua' },
    capabilities = cfg.cli_capabilities(),
    on_attach = cfg.on_attach()
  }
end

return M

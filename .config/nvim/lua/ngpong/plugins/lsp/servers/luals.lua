local M = {}

local Lazy   = require('ngpong.utils.lazy')
local Lspcfg = Lazy.require('lspconfig')

M.setup = function(cfg)
  Lspcfg.lua_ls.setup {
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

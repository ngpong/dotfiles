local M = {}

local lspcfg = require('lspconfig')

M.setup = function(cfg)
  local settings = {
    Lua = {
      addonManager = {
        enable = false,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      runtime = {
        version = 'LuaJIT',
        -- path = vim.split(package.path, ';')
      },
      workspace = {
        checkThirdParty = false,
        library = {
          -- standard library
          ['/usr/local/share/lua/5.1'] = true,
          ['/usr/share/lua/5.1'] = true,

          -- neovim library
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.stdpath('config') .. '/lua'] = true,
        },
      },
    },
  }

  lspcfg.lua_ls.setup {
    cmd = {
      'lua-language-server',
      -- '--configpath=~/.config/lua_ls/.luarc.json'
      -- --loglevel=trace
    },
    settings = settings,
    single_file_support = true,
    filetypes = { 'lua' },
    capabilities = cfg.cli_capabilities(),
    on_attach = cfg.on_attach()
  }
end

return M
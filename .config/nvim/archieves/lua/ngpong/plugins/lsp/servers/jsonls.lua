local M = {}

local Lspcfg = vim.__lazy.require("lspconfig")

local setup_server = function(cfg)
  Lspcfg.jsonls.setup({
    cmd = {
      "vscode-json-language-server",
      "--stdio"
    },
    single_file_support = true,
    init_options = {
      provideFormatter = false
    },
    filetypes = { "json", "jsonc" },
    capabilities = cfg.cli_capabilities(),
    on_attach = cfg.on_attach()
  })
end

M.setup = function(cfg)
  setup_server(cfg)
end

return M
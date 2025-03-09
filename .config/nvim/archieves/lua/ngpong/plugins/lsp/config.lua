local default_cfg = {
  on_attach = function(extra)
    return function(cli, bufnr)
      -- 禁用lsp提供的格式化能力
      cli.server_capabilities.documentFormattingProvider = false
      cli.server_capabilities.documentOnTypeFormattingProvider = false
      cli.server_capabilities.documentRangeFormattingProvider = false

      -- 禁用lsp提供的高亮能力
      -- cli.server_capabilities.semanticTokensProvider = nil

      if extra then
        extra(cli, bufnr)
      end
    end
  end,
  cli_capabilities = function(opts)
    local raw_capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities(opts or {})

    local capabilities = vim.__tbl.rr_extend(raw_capabilities, cmp_capabilities)

    -- https://www.reddit.com/r/neovim/comments/161tv8l/lsp_has_gotten_very_slow/
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

    return capabilities
  end
}

return setmetatable({}, {
  __index = function(_, k)
    local success, server = pcall(require, "ngpong.plugins.lsp.servers." .. k)
    if not success then
      vim.__logger.error("invalid server key!!")
    end

    return {
      setup = vim.__util.wrap_f(server.setup, default_cfg)
    }
  end,
})

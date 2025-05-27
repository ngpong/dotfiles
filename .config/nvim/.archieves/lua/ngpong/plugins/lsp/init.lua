return {
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "LazyFile", "VeryLazy" },
    dependencies = {
      "p00f/clangd_extensions.nvim",
      "NGPONG/lsp_signature.nvim", -- ray-x/lsp_signature.nvim
      "j-hui/fidget.nvim",
      "williamboman/mason.nvim",
    },
    init = function()
      vim._plugins.record_seq("nvim-lspconfig init")
      vim._plugins.lsp.opts.setup()
      vim._plugins.lsp.keys.setup()
    end,
    config = function()
      vim._plugins.record_seq("nvim-lspconfig config")
      vim._plugins.lsp.autocmd.setup()
      vim._plugins.lsp.highlight.setup()
      vim._plugins.lsp.handlers.setup()
      vim._plugins.lsp.behavior.setup()
      vim._plugins.lsp.config.clangd.setup()
      vim._plugins.lsp.config.luals.setup()
      vim._plugins.lsp.config.jsonls.setup()
      vim._plugins.lsp.config.yamlls.setup()
      vim._plugins.lsp.config.cmakels.setup()
      vim._plugins.lsp.config.bashls.setup()
      vim._plugins.lsp.config.asm_ls.setup()
      vim._plugins.lsp.config.autotools_ls.setup()
    end
  }
}

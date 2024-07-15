return {
  {
    'neovim/nvim-lspconfig',
    lazy = true,
    event = 'LazyFile',
    dependencies = {
      'p00f/clangd_extensions.nvim',
      'ray-x/lsp_signature.nvim',
      'williamboman/mason.nvim',
    },
    init = function()
      Plgs.record_seq('nvim-lspconfig init')
      Plgs.lsp.opts.setup()
      Plgs.lsp.keys.setup()
    end,
    config = function()
      Plgs.record_seq('nvim-lspconfig config')
      Plgs.lsp.highlight.setup()
      Plgs.lsp.handlers.setup()
      Plgs.lsp.behavior.setup()
      Plgs.lsp.config.clangd.setup()
      Plgs.lsp.config.luals.setup()
      Plgs.lsp.config.jsonls.setup()
      Plgs.lsp.config.yamlls.setup()
      Plgs.lsp.config.cmakels.setup()
      Plgs.lsp.config.bashls.setup()
      Plgs.lsp.config.asm_ls.setup()
      Plgs.lsp.config.autotools_ls.setup()
    end
  }
}

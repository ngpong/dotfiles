return {
  {
    'neovim/nvim-lspconfig',
    lazy = true,
    event = 'LazyFile',
    cmd = 'Mason',
    keys = {
      { '<leader>P', '<CMD>Mason<CR>', desc = 'open mason package manager.', },
    },
    dependencies = {
      'p00f/clangd_extensions.nvim',
      'ray-x/lsp_signature.nvim',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    init = function()
      PLGS.record_seq('nvim-lspconfig init')
      PLGS.lsp.opts.setup()
      PLGS.lsp.keys.setup()
      PLGS.lsp.highlight.setup()
    end,
    config = function()
      PLGS.record_seq('nvim-lspconfig config')
      PLGS.record_seq('mason.nvim config')
      PLGS.record_seq('mason-lspconfig.nvim config')
      PLGS.lsp.handlers.setup()
      PLGS.lsp.behavior.setup()
      PLGS.lsp.package.setup()
      PLGS.lsp.config.clangd.setup()
      PLGS.lsp.config.luals.setup()
      PLGS.lsp.config.jsonls.setup()
      PLGS.lsp.config.yamlls.setup()
      PLGS.lsp.config.cmakels.setup()
      PLGS.lsp.config.bashls.setup()
      PLGS.lsp.config.asm_ls.setup()
      PLGS.lsp.config.autotools_ls.setup()
    end
  }
}

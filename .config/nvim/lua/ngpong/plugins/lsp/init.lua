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
      PLGS.record_seq('nvim-lspconfig init')
      PLGS.lsp.opts.setup()
      PLGS.lsp.keys.setup()
      PLGS.lsp.highlight.setup()
    end,
    config = function()
      PLGS.record_seq('nvim-lspconfig config')
      PLGS.lsp.handlers.setup()
      PLGS.lsp.behavior.setup()
      PLGS.lsp.config.clangd.setup()
    end
  }
  ,
  {
    'williamboman/mason.nvim',
    lazy = true,
    cmd = 'Mason',
    keys = {
      { '<leader>P', '<CMD>Mason<CR>', desc = 'open mason package manager.', },
    },
    config = function()
      PLGS.record_seq('mason.nvim && mason-lspconfig.nvim config')
      PLGS.lsp.package.setup()
    end
  }
}
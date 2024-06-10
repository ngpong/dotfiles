return {
  {
    'williamboman/mason.nvim',
    lazy = true,
    event = 'LazyFile',
    cmd = 'Mason',
    keys = {
      { '<leader>P', '<CMD>Mason<CR>', desc = 'open mason package manager.', },
    },
    dependencies = {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    init = function()
      Plgs.record_seq('mason.nvim init')
      Plgs.package.keys.setup()
    end,
    config = function()
      Plgs.record_seq('mason.nvim config')
      Plgs.package.config.setup()
    end
  }
  ,
  {
    'williamboman/mason-lspconfig.nvim',
    lazy = true,
    init = function()
      Plgs.record_seq('mason-tool-installer.nvim init')
    end,
    config = function()
      Plgs.record_seq('mason-tool-installer.nvim config')
    end
  }
  ,
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    lazy = true,
    init = function()
      Plgs.record_seq('mason-lspconfig.nvim init')
    end,
   config = function()
      Plgs.record_seq('mason-lspconfig.nvim config')
    end
  },
}

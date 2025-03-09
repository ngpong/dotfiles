return {
  {
    "williamboman/mason.nvim",
    lazy = true,
    event = { "LazyFile", "VeryLazy" },
    cmd = "Mason",
    keys = {
      { "<leader>P", "<CMD>Mason<CR>", desc = "open mason package manager.", },
    },
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    init = function()
      vim._plugins.record_seq("mason.nvim init")
      vim._plugins.package.keys.setup()
    end,
    config = function()
      vim._plugins.record_seq("mason.nvim config")
      vim._plugins.package.config.setup()
    end
  }
  ,
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    init = function()
      vim._plugins.record_seq("mason-tool-installer.nvim init")
    end,
    config = function()
      vim._plugins.record_seq("mason-tool-installer.nvim config")
    end
  }
  ,
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = true,
    init = function()
      vim._plugins.record_seq("mason-lspconfig.nvim init")
    end,
   config = function()
      vim._plugins.record_seq("mason-lspconfig.nvim config")
    end
  },
}

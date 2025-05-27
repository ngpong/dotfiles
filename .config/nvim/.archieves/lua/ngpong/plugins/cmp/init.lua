return {
  "hrsh7th/nvim-cmp",
  lazy = true,
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-cmdline",
    "FelipeLema/cmp-async-path",
    "hrsh7th/cmp-buffer",
    "lukas-reineke/cmp-under-comparator",
    "L3MON4D3/LuaSnip"
  },
  init = function()
    vim._plugins.record_seq("nvim-cmp init")
    vim._plugins.cmp.opts.setup()
    vim._plugins.cmp.keys.setup()
  end,
  config = function()
    vim._plugins.record_seq("nvim-cmp config")
    vim._plugins.cmp.highlight.setup()
    vim._plugins.cmp.config.setup()
  end
}

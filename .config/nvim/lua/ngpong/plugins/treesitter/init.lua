return {
  'nvim-treesitter/nvim-treesitter',
  lazy = true,
  event = 'VeryLazyFile',
  cmd = { 'TSInstall', 'TSUpdate', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects'
    -- 'HiPhish/rainbow-delimiters.nvim'
  },
  init = function()
    Plgs.record_seq('nvim-treesitter init')
    Plgs.treesitter.opts.setup()
    Plgs.treesitter.keys.setup()
  end,
  config = function(_, opts)
    Plgs.record_seq('nvim-treesitter config')
    -- Plgs.treesitter.autocmd.setup() -- 关于设置折叠的 autocmd，但是可能会在大文件上引发性能问题
    Plgs.treesitter.hacker.setup()
    Plgs.treesitter.config.setup()
  end,
}

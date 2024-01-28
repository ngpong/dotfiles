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
    PLGS.record_seq('nvim-treesitter init')
    PLGS.treesitter.opts.setup()
    PLGS.treesitter.keys.setup()
  end,
  config = function(_, opts)
    PLGS.record_seq('nvim-treesitter config')
    -- PLGS.treesitter.autocmd.setup() -- 关于设置折叠的 autocmd，但是可能会在大文件上引发性能问题
    PLGS.treesitter.config.setup()
    PLGS.treesitter.hacker.setup()
  end,
}

return {
  'stevearc/dressing.nvim',
  lazy = true,
  init = function()
    PLGS.record_seq('dressing.nvim init')
    vim.ui.select = function(...)
      require('lazy').load({ plugins = { 'dressing.nvim' } })
      return vim.ui.select(...)
    end
    vim.ui.input = function(...)
      require('lazy').load({ plugins = { 'dressing.nvim' } })
      return vim.ui.input(...)
    end
  end,
  config = function()
    PLGS.record_seq('dressing.nvim config')
    PLGS.dressing.config.setup()
  end
}

return {
  {
    'nvim-lua/plenary.nvim',
    lazy = false,
    config = function()
      Plgs.record_seq('plenary.nvim config')
    end
  }
  ,
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
    config = function()
      Plgs.record_seq('nvim-web-devicons config')
    end
  }
  ,
  {
    'famiu/bufdelete.nvim',
    lazy = true,
    config = function()
      Plgs.record_seq('bufdelete.nvim config')
    end
  }
  ,
  {
    'MunifTanjim/nui.nvim',
    lazy = true,
    config = function()
      Plgs.record_seq('nui.nvim config')
    end
  }
  ,
  {
    's1n7ax/nvim-window-picker',
    lazy = true,
    config = function()
      Plgs.record_seq('nvim-window-picker config')
      require('window-picker').setup {
        autoselect_one = true,
        include_current = false,
        filter_rules = {
          bo = {
            filetype = { 'neo-tree', "neo-tree-popup", "notify" },
            buftype = { 'terminal', "quickfix" },
          },
        },
      }
    end,
  }
}

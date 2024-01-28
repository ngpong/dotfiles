local M = {}

local lazy       = require('ngpong.utils.lazy')
local treesitter = lazy.require('nvim-treesitter.configs')

local this = PLGS.treesitter

M.setup = function()
  treesitter.setup {
    ensure_installed = {
      'c',
      'cpp',
      'query',
      'vim',
      'vimdoc',
      'regex',
      'json',
      'lua',
      'bash',
      'cmake',
      'markdown',
      'markdown_inline'
    },
    sync_install = false,
    auto_install = false,
    ignore_install = {},
    highlight = {
      enable = true,
      disable = this.filter(),
      additional_vim_regex_highlighting = false,
    },
    textobjects = {
      select = {
        enable = false,
      },
      swap = {
        enable = false,
      },
      lsp_interop = {
        enable = false,
      },
      move = {
        enable = true, -- not used but control by keys.lua
        set_jumps = true, -- whether to set jumps in the jumplist
      },
    },
  }

  -- 此插件在键入 '()' 的时候会有些卡顿
  -- require('rainbow-delimiters.setup').setup {
  --   strategy = {
  --     [''] = require('rainbow-delimiters').strategy['global'],
  --   },
  --   query = {
  --     [''] = 'rainbow-delimiters',
  --     lua = 'rainbow-blocks',
  --   },
  -- }
end

return M

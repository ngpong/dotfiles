local M = {}

local keymap        = require('ngpong.common.keybinder')
local events        = require('ngpong.common.events')
local lazy          = require('ngpong.utils.lazy')
local mc            = lazy.require('multicursors')
local mc_n          = lazy.require('multicursors.normal_mode')
local mc_i          = lazy.require('multicursors.insert_mode')
local mc_utils      = lazy.require('multicursors.utils')
local mc_selections = lazy.require('multicursors.selections')

local this = PLGS.multicursors
local e_mode = keymap.e_mode
local e_events = events.e_name

local set_native_keymaps = function()
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<leader>c', function()
    mc.start()
  end, { remap = false, desc = 'enter multi cursor mode.' })
end

local set_mode_keymaps = function(cfg)
  TOOLS.tbl_r_extend(cfg, {
    mode_keys = {
      append = { 'a', desc = 'MULTICURSORS: enter(head) inster mode.' },
      change = { 'c', desc = 'MULTICURSORS: cut character and enter insert mode.' },
      extend = { ')', desc = 'which_key_ignore' },
      insert = { 'A', desc = 'MULTICURSORS: enter(tail) inster mode.' },
    },
  })
end

local set_normal_keymaps = function(cfg)
  TOOLS.tbl_r_extend(cfg, {
    normal_keys = {
      ['<C-.>'] = {
        method = function()
          HELPER.add_jumplist()
          mc_n.find_next()
          HELPER.add_jumplist()
        end,
        opts = { desc = 'MULTICURSORS: find next match.' }
      },
      ['<C-,>'] = {
        method = function()
          HELPER.add_jumplist()
          mc_n.find_prev()
          HELPER.add_jumplist()
        end,
        opts = { desc = 'MULTICURSORS: find previous match.' }
      },
      ['<'] = {
        method = function()
          HELPER.add_jumplist()
          mc_n.skip_find_prev()
          HELPER.add_jumplist()
        end,
        opts = { desc = 'MULTICURSORS: skip current and find previous match.'  }
      },
      ['>'] = {
        method = function()
          HELPER.add_jumplist()
          mc_n.skip_find_next()
          HELPER.add_jumplist()
        end,
        opts = { desc = 'MULTICURSORS: skip current and find next match.'  }
      },
      ['x'] = {
        method = function()
          mc_n.delete(cfg)
        end,
        opts = { desc = 'MULTICURSORS: delete character.'  }
      },
      ['<leader>u'] = {
        method = function()
          mc_n.lower_case()
        end,
        opts = { desc = 'MULTICURSORS: convert selected text to lowercase.'  }
      },
      ['<leader>U'] = {
        method = function()
          mc_n.upper_case()
        end,
        opts = { desc = 'MULTICURSORS: convert selected text to uppercase.'  }
      },
      ['y'] = {
        method = function()
          mc_n.yank()
        end,
        opts = { desc = 'MULTICURSORS: copy text.'  }
      },
      ['u'] = {
        method = function()
          mc_n.replace()
        end,
        opts = { desc = 'MULTICURSORS: paste text.'  }
      },

      [','] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['b'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['b.'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['b,'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['b<'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['b>'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['B'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['B<'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['B>'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['bp'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['bs'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['BC'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['bo'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['bc'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['f'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['fb'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['f<leader>'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['ff'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['fl'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['fs'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['d'] = { method = function() end, opts = { desc = 'which_key_ignore' } },
      ['dr'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['de'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['dE'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['d.'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['d,'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['dn'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['da'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['dm'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['dc'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['dp'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['dw'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['di'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['dk'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['dh'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['ds'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['dd'] = { method = function() end, opts = { desc = 'which_key_ignore' } },
      ['dD'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['t'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['to'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['tc'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['ts'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['t.'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['t,'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['r'] = { method = function() end, opts = { desc = 'which_key_ignore' } },
      ['ro'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['rc'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['r:'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['r;'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['rl'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['r\''] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['rp'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['rh'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['rv'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['r='] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['r-'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['rs'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['rsh'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['rsv'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['g'] = { method = function() end, opts = { desc = 'which_key_ignore' } },
      ['g,'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['g.'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['gp'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['gr'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['gb'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['ga'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['gd'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['gg'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['gu'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['gh'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['ghr'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['ghs'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['gha'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['m'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['m,'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['m.'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['md'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['ms'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['me'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['mm'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['\\'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['/'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['?'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['V'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['v'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['X'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['<C-v>'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['<leader>c'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['<leader>e'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['<leader>p'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['<leader>l'] = { method = nil, opts = { desc = 'which_key_ignore' } },
      ['<leader>q'] = { method = nil, opts = { desc = 'which_key_ignore' } },

      ['.'] = { method = false },
      ['D'] = { method = false },
      ['n'] = { method = false },
      ['N'] = { method = false },
      ['z'] = { method = false },
      ['Z'] = { method = false },
      ['q'] = { method = false },
      ['<C-n>'] = { method = false },
      ['j'] = { method = false },
      ['k'] = { method = false },
      ['Q'] = { method = false },
      ['}'] = { method = false },
      ['{'] = { method = false },
      [']'] = { method = false },
      ['['] = { method = false },
      ['p'] = { method = false },
      ['P'] = { method = false },
      ['@'] = { method = false },
      [':'] = { method = false },
      ['U'] = { method = false },
      ['J'] = { method = false },
      ['K'] = { method = false },
      ['Y'] = { method = false },
      ['yy'] = { method= false },
    },
  })
end

local set_insert_keymaps = function(cfg)
  TOOLS.tbl_r_extend(cfg, {
    insert_keys = {
      ['<A-[>'] = {
        method = mc_i.Home_method,
        opts = { desc = 'which_key_ignore'  }
      },
      ['<A-]>'] = {
        method = mc_i.End_method,
        opts = { desc = 'which_key_ignore'  }
      },
      ['<A-l>'] = {
        method = mc_i.Left_method,
        opts = { desc = 'which_key_ignore'  }
      },
      ['<A-\'>'] = {
        method = mc_i.Right_method,
        opts = { desc = 'which_key_ignore'  }
      },
      ['<A-p>'] = {
        method = mc_i.UP_method,
        opts = { desc = 'which_key_ignore'  }
      },
      ['<A-;>'] = {
        method = mc_i.Down_method,
        opts = { desc = 'which_key_ignore'  }
      },
      ['<A-w>'] = {
        method = function()
          -- how to integrated spider.nvim?
          mc_selections.move_by_motion('e')
        end,
        opts = { desc = 'which_key_ignore'  }
      },
      ['<A-q>'] = {
        method = function()
          -- how to integrated spider.nvim?
          mc_selections.move_by_motion('b')
        end,
        opts = { desc = 'which_key_ignore'  }
      },

      ['<Right>'] = { method = false },
      ['<Left>'] = { method = false },
      ['<Down>'] = { method = false },
      ['<Up>'] = { method = false },
      ['<C-w>'] = { method = false },
      ['<C-BS>'] = { method = false },
      ['<C-u>'] = { method = false },
      ['<C-j>'] = { method = false },
      ['<C-Right>'] = { method = false },
      ['<C-Left>'] = { method = false },
    }
  })
end

local set_extend_keymaps = function(cfg)
  -- extend 模式用于扩展选择的一些东西，需要的时候在研究 extend 模式的键，先暂时都保持默认
  TOOLS.tbl_r_extend(cfg, {
    extend_keys = {
      -- ['w'] = { method = false },
      -- ['e'] = { method = false },
      -- ['b'] = { method = false },
      -- ['o'] = { method = false },
      -- ['O'] = { method = false },
      -- ['h'] = { method = false },
      -- ['j'] = { method = false },
      -- ['k'] = { method = false },
      -- ['l'] = { method = false },
      -- ['r'] = { method = false },
      -- ['t'] = { method = false },
      -- ['y'] = { method = false },
      -- ['^'] = { method = false },
      -- ['$'] = { method = false },
      -- ['u'] = { method = false },
      -- ['c'] = { method = false }
    }
  })
end

M.setup = function()
  set_native_keymaps()

  events.rg(e_events.SETUP_MULTICURSORS, function(cfg)
    set_mode_keymaps(cfg)
    set_normal_keymaps(cfg)
    set_insert_keymaps(cfg)
    set_extend_keymaps(cfg)
  end)
end

return M

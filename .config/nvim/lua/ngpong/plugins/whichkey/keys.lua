local M = {}

local libP   = require('ngpong.common.libp')
local Events = require('ngpong.common.events')
local Keymap = require('ngpong.common.keybinder')
local Lazy   = require('ngpong.utils.lazy')
local WK     = Lazy.require('which-key')

local e_mode   = Keymap.e_mode
local e_name = Events.e_name

local fix_keymap_native = libP.async.void(function()
  libP.async.util.scheduler()
  WK.register({
    ['v'] = { 'COMMON: enter visual mode.' },
    ['V'] = { 'COMMON: enter line-visual mode.' },

    ['K'] = {
      name = 'which_key_ignore',
    },
    [':'] = {
      name = 'which_key_ignore',
    },

    ['/'] = { 'SEARCH: enter search pattern mode.' },

    ['f'] = {
      name = 'FIND:'
    },

    ['e'] = {
      name = 'JUMPTO:',
      ['1'] = { name = 'INDENT' },
      ['2'] = { name = 'FUNCTION' },
      ['3'] = { name = 'CLASS' },
      ['4'] = { name = 'LOOP' },
      ['5'] = { name = 'CONDITIONAL' },
    },
    ['E'] = {
      name = 'which_key_ignore',
    },

    ['d'] = {
      name = 'CODEING:',
    },

    ['r'] = {
      name = 'WINDOW:',
      ['s'] = {
        name = 'SPLIT RESIZE SETTING:',
      },
    },

    ['t'] = {
      name = 'TABPAGE:',
    },

    ['n'] = {
      name = 'TODO:'
    },

    ['m'] = {
      name = 'MARKS',
      ['e'] = {
        name = 'JUMPTO',
      },
      ['d'] = {
        name = 'DEL',
      },
      ['s'] = {
        name = 'SET',
      }
    },

    ['b'] = {
      name = 'BUFFER:',
      ['C'] = { 'wipeout all buffer except current.' },
      ['<'] = { 'move current buffer prev in sequence.' },
      ['>'] = { 'move current buffer next in sequence.' },
    },
    ['B'] = {
      name = 'which_key_ignore',
    },

    ['g'] = {
      name = 'GIT:',
    },

    ['<LEADER>'] = {
      name = 'PREFIX:',
      ['t'] = {
        name = 'TROUBLE LIST:',
      },
    },
  })

  libP.async.util.scheduler()
  WK.register({
    ['e'] = {
      name = 'JUMPTO:',
      ['1'] = { name = 'INDENT' },
      ['2'] = { name = 'FUNCTION' },
      ['3'] = { name = 'CLASS' },
      ['4'] = { name = 'LOOP' },
      ['5'] = { name = 'CONDITIONAL' },
    },
  }, { mode = 'v', })
end)

local fix_keymap_neotree = libP.async.void(function(bufnr)
  libP.async.util.scheduler()
  WK.register({
    ['f'] = {
      name = 'NEOTREE FILE:',
    },

    ['g'] = {
      name = 'NEOTREE GIT:',
    },
  }, { buffer = bufnr })
end)

local fix_keymap_gitsigns = libP.async.void(function(bufnr)
  libP.async.util.scheduler()
  WK.register({
    ['g'] = {
      name = 'GIT:',
      ['h'] = {
        name = 'HUNK:',
      },
    },
  }, { buffer = bufnr })
end)

local set_native_keymaps = function()
  Keymap.register(e_mode.NORMAL, '<leader>k', '<CMD>WhichKey<CR>', { remap = false, silent = true, desc = 'open keymap config.' })
end

local setup = function()
  set_native_keymaps()

  Events.rg(e_name.SETUP_WHICHKEY, function()
    fix_keymap_native()
  end)

  Events.rg(e_name.ATTACH_GITSIGNS, function(state)
    fix_keymap_gitsigns(state.bufnr)
  end)

  Events.rg(e_name.OPEN_NEOTREE, function(state)
    fix_keymap_neotree(state.bufnr)
  end)
end

M.setup = setup

return M

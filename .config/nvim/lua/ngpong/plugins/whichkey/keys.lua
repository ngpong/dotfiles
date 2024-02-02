local M = {}

local events = require('ngpong.common.events')
local keymap = require('ngpong.common.keybinder')
local lazy   = require('ngpong.utils.lazy')
local async  = lazy.require('plenary.async')
local wk     = lazy.require('which-key')

local e_mode   = keymap.e_mode
local e_events = events.e_name

local fix_keymap_native = async.void(function()
  async.util.scheduler()
  wk.register({
    ['v'] = { 'COMMON: enter visual mode.' },
    ['V'] = { 'COMMON: enter line-visual mode.' },

    ['L'] = {
      name = 'which_key_ignore',
    },
    ['\"'] = {
      name = 'which_key_ignore',
    },

    ['/'] = { 'SEARCH: enter search pattern mode.' },

    ['f'] = {
      name = 'FIND:'
    },

    ['e'] = {
      name = 'JUMPTO:',
      ['f'] = { name = 'TEXTOBJECT FUNCTION' },
      ['c'] = { name = 'TEXTOBJECT CLASS' },
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

  async.util.scheduler()
  wk.register({
    ['e'] = {
      name = 'JUMPTO:',
      ['f'] = { name = 'TEXTOBJECT FUNCTION' },
      ['c'] = { name = 'TEXTOBJECT CLASS' },
    },
  }, { mode = 'v', })
end)

local fix_keymap_neotree = async.void(function(bufnr)
  async.util.scheduler()
  wk.register({
    ['f'] = {
      name = 'NEOTREE FILE:',
      ['r'] = {
        name = 'WINDOW SPLIT',
      },
    },

    ['g'] = {
      name = 'NEOTREE GIT:',
    },
  }, { buffer = bufnr })
end)

local fix_keymap_gitsigns = async.void(function(bufnr)
  async.util.scheduler()
  wk.register({
    ['g'] = {
      name = 'GIT:',
      ['h'] = {
        name = 'HUNK:',
      },
    },
  }, { buffer = bufnr })
end)

local set_native_keymaps = function()
  keymap.register(e_mode.NORMAL, '<leader>k', '<CMD>WhichKey<CR>', { remap = false, silent = true, desc = 'open keymap config.' })
end

local setup = function()
  set_native_keymaps()

  events.rg(e_events.SETUP_WHICHKEY, function()
    fix_keymap_native()
  end)

  events.rg(e_events.ATTACH_GITSIGNS, function(state)
    fix_keymap_gitsigns(state.bufnr)
  end)

  events.rg(e_events.CREATE_NEOTREE_SOURCE, function(state)
    if 'filesystem' == state.source then
      fix_keymap_neotree(state.bufnr)
    elseif 'git_status' == state.source then
      fix_keymap_neotree(state.bufnr)
    elseif 'buffers' == state.source then
      -- ...
    elseif 'document_symbols' == state.source then
      -- ...
    else
      return
    end
  end)
end

M.setup = setup

return M

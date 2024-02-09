local M = {}

local keymap = require('ngpong.common.keybinder')

local e_mode = keymap.e_mode

local set_native_keymaps = function()
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'ef.', function()
    require('nvim-treesitter.textobjects.move').goto_next('@function.outer', 'textobjects')
  end, { remap = false, desc = 'next @function.outer' })

  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'ef,', function()
    require('nvim-treesitter.textobjects.move').goto_previous('@function.outer', 'textobjects')
  end, { remap = false, desc = 'next @class.outer' })

  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'ec.', function()
    require('nvim-treesitter.textobjects.move').goto_next('@class.outer', 'textobjects')
  end, { remap = false, desc = 'prev @function.outer' })

  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'ec,', function()
    require('nvim-treesitter.textobjects.move').goto_previous('@class.outer', 'textobjects')
  end, { remap = false, desc = 'prev @class.outer' })

  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'el,', function()
    require('nvim-treesitter.textobjects.move').goto_previous('@loop.outer', 'textobjects')
  end, { remap = false, desc = 'prev @loop' })

  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'el.', function()
    require('nvim-treesitter.textobjects.move').goto_next('@loop.outer', 'textobjects')
  end, { remap = false, desc = 'prev @loop' })

  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'ed,', function()
    require('nvim-treesitter.textobjects.move').goto_previous('@conditional.outer', 'textobjects')
  end, { remap = false, desc = 'prev @conditional' })

  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'ed.', function()
    require('nvim-treesitter.textobjects.move').goto_next('@conditional.outer', 'textobjects')
  end, { remap = false, desc = 'prev @conditional' })
end

M.setup = function()
  set_native_keymaps()
end

return M

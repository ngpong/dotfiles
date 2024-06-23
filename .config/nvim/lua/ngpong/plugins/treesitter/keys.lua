local M = {}

local Keymap = require('ngpong.common.keybinder')

local e_mode = Keymap.e_mode

local set_native_keymaps = function()
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'e2]', function()
    require('nvim-treesitter.textobjects.move').goto_next('@function.outer', 'textobjects')
  end, { remap = false, desc = 'next @function.outer' })

  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'e2[', function()
    require('nvim-treesitter.textobjects.move').goto_previous('@function.outer', 'textobjects')
  end, { remap = false, desc = 'next @function.outer' })

  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'e3]', function()
    require('nvim-treesitter.textobjects.move').goto_next('@class.outer', 'textobjects')
  end, { remap = false, desc = 'prev @class.outer' })

  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'e3[', function()
    require('nvim-treesitter.textobjects.move').goto_previous('@class.outer', 'textobjects')
  end, { remap = false, desc = 'prev @class.outer' })

  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'e4[', function()
    require('nvim-treesitter.textobjects.move').goto_previous('@loop.outer', 'textobjects')
  end, { remap = false, desc = 'prev @loop' })

  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'e4]', function()
    require('nvim-treesitter.textobjects.move').goto_next('@loop.outer', 'textobjects')
  end, { remap = false, desc = 'prev @loop' })

  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'e5[', function()
    require('nvim-treesitter.textobjects.move').goto_previous('@conditional.outer', 'textobjects')
  end, { remap = false, desc = 'prev @conditional' })

  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'e5]', function()
    require('nvim-treesitter.textobjects.move').goto_next('@conditional.outer', 'textobjects')
  end, { remap = false, desc = 'prev @conditional' })
end

M.setup = function()
  set_native_keymaps()
end

return M

local M = {}

local Keymap = require('ngpong.common.keybinder')
local Lazy   = require('ngpong.utils.lazy')

local e_mode = Keymap.e_mode

M.setup = function()
  local montion = Lazy.access('spider', 'motion')

  local montion_e = Tools.wrap_f(montion, 'e')
  local montion_b = Tools.wrap_f(montion, 'b')

  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'w', function()
    montion_e()
  end, { remap = false, desc = 'MONTION: cursor world forward.' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'q', function()
    montion_b()
  end, { remap = false, desc = 'MONTION: cursor world backward.' })
  Keymap.register(e_mode.INSERT, '<A-w>', function()
    montion_e()
  end, { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.INSERT, '<A-q>', function()
    montion_b()
  end, { remap = false, desc = 'which_key_ignore' })
end

return M

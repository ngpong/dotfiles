local M = {}

local keymap = require('ngpong.common.keybinder')
local lazy   = require('ngpong.utils.lazy')

local e_mode = keymap.e_mode

M.setup = function()
  local montion = lazy.access('spider', 'motion')

  local montion_e = TOOLS.wrap_f(montion, 'e')
  local montion_b = TOOLS.wrap_f(montion, 'b')

  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'w', function()
    montion_e()
  end, { remap = false, desc = 'MONTION: cursor world forward.' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'q', function()
    montion_b()
  end, { remap = false, desc = 'MONTION: cursor world backward.' })
  keymap.register(e_mode.INSERT, '<A-w>', function()
    return '<C-o><cmd>lua require(\'spider\').motion(\'e\')<CR>'
  end, { expr = true, remap = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.INSERT, '<A-q>', function()
    return '<C-o><cmd>lua require(\'spider\').motion(\'b\')<CR>'
  end, { expr = true, remap = false, desc = 'which_key_ignore' })
end

return M
local M = {}

local Keymap = require('ngpong.common.keybinder')
local Lazy   = require('ngpong.utils.lazy')
local Leap   = Lazy.require('leap')

local this = Plgs.leap

local e_mode = Keymap.e_mode

local function set_native_keymaps()
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 's', function()
    Leap.leap { target_windows = { Helper.get_cur_winid() } }
  end, { remap = false, desc = 'SEARCH: arbitrary jump with current windows.' })
end

M.setup = function()
  set_native_keymaps()
end

return M

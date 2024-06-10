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

  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'S', function()
    Leap.leap { target_windows = vim.tbl_filter(
      function (win) return this.filter(win) end,
      vim.api.nvim_tabpage_list_wins(0)
    ) }
  end, { remap = false, desc = 'SEARCH: arbitrary jump with all windows..' })
end

M.setup = function()
  set_native_keymaps()
end

return M

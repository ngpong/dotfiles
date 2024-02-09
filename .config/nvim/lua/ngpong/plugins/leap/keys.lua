local M = {}

local keymap = require('ngpong.common.keybinder')
local lazy   = require('ngpong.utils.lazy')
local leap   = lazy.require('leap')

local e_mode = keymap.e_mode

local function set_native_keymaps()
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 's', function()
    leap.leap { target_windows = { HELPER.get_cur_winid() } }
  end, { remap = false, desc = 'SEARCH: arbitrary jump with current windows.' })

  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'S', function()
    leap.leap { target_windows = vim.tbl_filter(
      function (win) return vim.api.nvim_win_get_config(win).focusable end,
      vim.api.nvim_tabpage_list_wins(0)
    ) }
  end, { remap = false, desc = 'SEARCH: arbitrary jump with all windows..' })
end

M.setup = function()
  set_native_keymaps()
end

return M

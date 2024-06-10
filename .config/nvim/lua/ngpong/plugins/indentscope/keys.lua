local M = {}

local Keymap = require('ngpong.common.keybinder')

local e_mode = Keymap.e_mode

local set_native_keymaps = function()
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'e1,', function()
    vim.cmd('lua MiniIndentscope.operator(\'top\', true)')
  end, { silent = true, remap = false, desc = 'prev @indent' })

  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'e1.', function()
    vim.cmd('lua MiniIndentscope.operator(\'bottom\', true)')
  end, { silent = true, remap = false, desc = 'next @indent' })
end

M.setup = function()
  set_native_keymaps()
end

return M

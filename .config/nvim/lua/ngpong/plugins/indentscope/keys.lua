local M = {}

local keymap = require('ngpong.common.keybinder')

local e_mode = keymap.e_mode

local set_native_keymaps = function()
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'e1,', function()
    vim.cmd('lua MiniIndentscope.operator(\'top\', true)')
  end, { silent = true, remap = false, desc = 'prev @indent' })

  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'e1.', function()
    vim.cmd('lua MiniIndentscope.operator(\'bottom\', true)')
  end, { silent = true, remap = false, desc = 'next @indent' })
end

M.setup = function()
  set_native_keymaps()
end

return M

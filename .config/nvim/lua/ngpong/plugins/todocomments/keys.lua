local M = {}

local keymap = require('ngpong.common.keybinder')
local lazy   = require('ngpong.utils.lazy')

local e_mode = keymap.e_mode

local trouble = PLGS.trouble

local del_native_keymaps = function()
  keymap.unregister(e_mode.NORMAL, 'n')
end

local set_native_keymaps = function()
  keymap.register(e_mode.NORMAL, 'n,', TOOLS.wrap_f(lazy.access('todo-comments', 'jump_next')), { remap = false, desc = 'jump to prev.' })
  keymap.register(e_mode.NORMAL, 'n.', TOOLS.wrap_f(lazy.access('todo-comments', 'jump_prev')), { remap = false, desc = 'jump to next.' })
  keymap.register(e_mode.NORMAL, 'nn', TOOLS.wrap_f(trouble.api.open, 'todo'), { silent = true, remap = false, desc = 'toggle todo list.' })
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()
end

return M

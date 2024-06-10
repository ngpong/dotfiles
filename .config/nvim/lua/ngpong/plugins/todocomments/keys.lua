local M = {}

local Keymap = require('ngpong.common.keybinder')
local Lazy   = require('ngpong.utils.lazy')

local e_mode = Keymap.e_mode

local trouble = Plgs.trouble

local del_native_keymaps = function()
  Keymap.unregister(e_mode.NORMAL, 'n')
end

local set_native_keymaps = function()
  Keymap.register(e_mode.NORMAL, 'n,', Tools.wrap_f(Lazy.access('todo-comments', 'jump_prev')), { remap = false, desc = 'jump to prev.' })
  Keymap.register(e_mode.NORMAL, 'n.', Tools.wrap_f(Lazy.access('todo-comments', 'jump_next')), { remap = false, desc = 'jump to next.' })
  Keymap.register(e_mode.NORMAL, 'nn', Tools.wrap_f(trouble.api.toggle, 'document_todo'), { silent = true, remap = false, desc = 'toggle document todo list.' })
  Keymap.register(e_mode.NORMAL, 'nN', Tools.wrap_f(trouble.api.toggle, 'workspace_todo'), { silent = true, remap = false, desc = 'toggle workspace todo list.' })
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()
end

return M

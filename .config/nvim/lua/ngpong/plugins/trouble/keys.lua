local M = {}

-- stylua: ignore start
local Events = require('ngpong.common.events')
local Keymap = require('ngpong.common.keybinder')

local this = Plgs.trouble

local e_mode = Keymap.e_mode
local e_name = Events.e_name
-- stylua: ignore end

local set_native_keymaps = function()
  local wrap = Tools.wrap_f

  Keymap.register(e_mode.NORMAL, '<leader>l', wrap(this.api.toggle, 'loclist'), { silent = true, remap = false, desc = 'toggle location list.' })
  Keymap.register(e_mode.NORMAL, '<leader>q', wrap(this.api.toggle, 'quickfix'), { silent = true, remap = false, desc = 'toggle quickfix list.' })
end

local del_buffer_keymaps = function(bufnr)
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'a', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'x', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'X', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'c', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'C', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'u', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'z', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'Z', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'b', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'bC', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'b,', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'b.', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'b>', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'b<', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'bp', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'bs', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'bc', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'bo', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'B', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'BC', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'B<', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'B>', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'm', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'mm', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'm,', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'm.', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'md', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'md<leader>', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'md<CR>', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'me', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'ms', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'ms<leader>', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'rh', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'rv', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'rs', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'rc', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'ts', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'dp', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'd.', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'd,', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'e,', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'e.', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'gg', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<leader>c', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<leader>u', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<leader>U', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, '<leader>f', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<leader>j', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<leader>J', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'e1', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'e2', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'e3', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'e4', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'e5', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'e1.', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'e1,', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'e2.', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'e2,', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'e3.', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'e3,', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'e4.', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'e4,', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'e5.', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'e5,', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'n,', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'n.', function() end, { buffer = bufnr, desc = 'which_key_ignore' })
end

local set_buffer_keymaps = function(bufnr)
  Keymap.register(e_mode.NORMAL, '<ESC>', this.api.close, { remap = false, buffer = bufnr, desc = 'TROUBLE: close trouble list.' })
  Keymap.register(e_mode.NORMAL, '<S-CR>', this.api.jump_close, { remap = false, buffer = bufnr, desc = 'TROUBLE: open selected entry into buffer and close trouble.' })
  Keymap.register(e_mode.NORMAL, '<CR>', this.api.jump, { remap = false, buffer = bufnr, desc = 'TROUBLE: open selected entry into buffer.' })
  Keymap.register(e_mode.NORMAL, '<C-s>', this.api.toggle_preview, { remap = false, buffer = bufnr, desc = 'TROUBLE: toggle preview(seek) with selected entry.' })
  -- Keymap.register(e_mode.NORMAL, 'R', Tools.wrap_f(this.api.refresh), { remap = false, buffer = bufnr, desc = 'TROUBLE: refresh trouble list.' })
end

M.setup = function()
  set_native_keymaps()

  Events.rg(e_name.CREATE_TROUBLE_LIST, function(state)
    del_buffer_keymaps(state.buf)
    set_buffer_keymaps(state.buf)
  end)
end

return M

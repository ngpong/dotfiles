local M = {}

local keymap = require('ngpong.common.keybinder')
local events = require('ngpong.common.events')

local this = PLGS.trouble
local e_mode = keymap.e_mode
local e_events = events.e_name

local set_native_keymaps = function()
  local wrap = TOOLS.wrap_f

  keymap.register(e_mode.NORMAL, '<ESC>', this.api.close, { remap = false, mixture = 'trouble', desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, '<leader>l', wrap(this.api.open, 'loclist'), { silent = true, remap = false, desc = 'toggle location list.' })
  keymap.register(e_mode.NORMAL, '<leader>q', wrap(this.api.open, 'quickfix'), { silent = true, remap = false, desc = 'toggle quickfix list.' })
end

local del_buffer_keymaps = function(bufnr)
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'a', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'x', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'X', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'c', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'C', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'u', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'z', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'Z', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'b', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'bC', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'b,', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'b.', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'b>', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'b<', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'bp', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'bs', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'bc', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'bo', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'B', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'BC', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'B<', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'B>', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'm', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'mm', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'm,', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'm.', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'md', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'md<leader>', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'md<CR>', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'me', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'ms', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'ms<leader>', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'ro', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'rh', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'rv', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'ts', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'd', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'd.', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'd,', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'dd', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'dD', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'e,', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'e.', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'gg', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<leader>c', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<leader>u', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<leader>U', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, '<leader>f', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<leader>j', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<leader>J', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'ef.', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'ef,', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'ec.', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'ec,', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'ef', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'ec', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'g', this.api.actions.nop, { buffer = bufnr, desc = 'which_key_ignore' })
end

local set_buffer_keymaps = function(bufnr)
  keymap.register(e_mode.NORMAL, '<CR>', this.api.jump, { remap = false, buffer = bufnr, desc = 'TOUBLE: open selected entry into buffer.' })
  keymap.register(e_mode.NORMAL, '<C-s>', this.api.actions.toggle_preview, { remap = false, buffer = bufnr, desc = 'TOUBLE: toggle preview(seek) with selected entry.' })
  keymap.register(e_mode.NORMAL, 'R', TOOLS.wrap_f(this.api.refresh), { remap = false, buffer = bufnr, desc = 'TOUBLE: refresh trouble list.' })
  -- keymap.register(e_mode.NORMAL, '<leader>i', this.api.actions.hover, { remap = false, buffer = bufnr, desc = 'hover selected entry.' })
end

M.setup = function()
  set_native_keymaps()

  events.rg(e_events.CREATE_TROUBLE_LIST, function(state)
    del_buffer_keymaps(state.buf)
    set_buffer_keymaps(state.buf)
  end)
end

return M

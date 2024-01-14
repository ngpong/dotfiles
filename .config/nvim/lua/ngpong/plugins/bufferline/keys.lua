local M = {}

local keymap = require('ngpong.common.keybinder')

local this   = PLGS.bufferline
local e_mode = keymap.e_mode

local del_native_keymaps = function(_)
end

local set_native_keymaps = function(_)
  keymap.register(e_mode.NORMAL, 'b.', this.api.cycle_next, { remap = false, desc = 'cycle next buffer.' })
  keymap.register(e_mode.NORMAL, 'b,', this.api.cycle_prev, { remap = false, desc = 'cycle prev buffer.' })
  keymap.register(e_mode.NORMAL, 'B>', this.api.move_next, { remap = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'B<', this.api.move_prev, { remap = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'bs', this.api.select, { remap = false, desc = 'select target buffer.' })
  keymap.register(e_mode.NORMAL, 'bp', this.api.pin, { remap = false, desc = 'pin current buffer.' })
  keymap.register(e_mode.NORMAL, 'bc', TOOLS.wrap_f(HELPER.wipeout_buffer, nil, false, function(bufnr)
    return not this.api.is_pinned(bufnr)
  end), { remap = false, desc = 'wipeout current buffer.' })
  keymap.register(e_mode.NORMAL, 'bo', TOOLS.wrap_f(HELPER.wipeout_all_buffers, false, function(bufnr)
    return bufnr == HELPER.get_cur_bufnr()
  end), { remap = false, desc = 'wipeout all buffers except current.' })
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()
end

return M

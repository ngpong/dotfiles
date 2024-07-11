local M = {}

local Keymap = require('ngpong.common.keybinder')

local e_mode = Keymap.e_mode

local this    = Plgs.bufferline
local trouble = Plgs.trouble

local del_native_keymaps = function(_)
end

local set_native_keymaps = function(_)
  Keymap.register(e_mode.NORMAL, 'b]', this.api.cycle_next, { remap = false, desc = 'cycle next buffer.' })
  Keymap.register(e_mode.NORMAL, 'b[', this.api.cycle_prev, { remap = false, desc = 'cycle prev buffer.' })
  Keymap.register(e_mode.NORMAL, 'bb', Tools.wrap_f(trouble.api.toggle, 'buffers'), { remap = false, silent = true, desc = 'toggle buffers list.' })
  Keymap.register(e_mode.NORMAL, 'B}', this.api.move_next, { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'B{', this.api.move_prev, { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'bs', this.api.select, { remap = false, desc = 'select target buffer.' })
  Keymap.register(e_mode.NORMAL, 'bt', this.api.pin, { remap = false, desc = 'tack current buffer.' })
  Keymap.register(e_mode.NORMAL, 'bc', Tools.wrap_f(Helper.delete_buffer, nil, false, function(bufnr)
    return not this.api.is_pinned(bufnr)
  end), { remap = false, desc = 'wipeout current buffer.' })
  Keymap.register(e_mode.NORMAL, 'bo', Tools.wrap_f(Helper.delete_all_buffers, false, function(bufnr)
    local is_current  = Helper.get_cur_bufnr() == bufnr
    local is_pinned   = this.api.is_pinned(bufnr)
    local is_floating = Helper.is_floating_win(Helper.get_winid(bufnr))

    return not is_current and not is_pinned and not is_floating
  end), { remap = false, desc = 'wipeout all buffers except current.' })
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()
end

return M

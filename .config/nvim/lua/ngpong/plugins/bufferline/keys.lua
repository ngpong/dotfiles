local M = {}

local Keymap = require('ngpong.common.keybinder')

local e_mode = Keymap.e_mode

local this      = Plgs.bufferline
local telescope = Plgs.telescope

local del_native_keymaps = function(_)
end

local set_native_keymaps = function(_)
  Keymap.register(e_mode.NORMAL, 'b]', this.api.cycle_next, { remap = false, desc = 'cycle next buffer.' })
  Keymap.register(e_mode.NORMAL, 'b[', this.api.cycle_prev, { remap = false, desc = 'cycle prev buffer.' })
  Keymap.register(e_mode.NORMAL, 'bb', function()
    local is_pinned  = this.api.is_pinned('all')
    local components = this.api.get_components()

    local sorted_cache = {}
    for i = 1, #components do
      sorted_cache[components[i]:as_element().id] = i
    end

    telescope.api.builtin_picker('buffers', {
      is_have_pinned = is_pinned,
      sort_buffers = function(l, r)
        return sorted_cache[l] < sorted_cache[r]
      end
    })
  end, { remap = false, silent = true, desc = 'find buffers.' })
  Keymap.register(e_mode.NORMAL, 'B>', this.api.move_next, { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'B<', this.api.move_prev, { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'bs', this.api.select, { remap = false, desc = 'select target buffer.' })
  Keymap.register(e_mode.NORMAL, 'bp', this.api.pin, { remap = false, desc = 'pin current buffer.' })
  Keymap.register(e_mode.NORMAL, 'bc', Tools.wrap_f(Helper.delete_buffer, nil, false, function(bufnr)
    return not this.api.is_pinned(bufnr)
  end), { remap = false, desc = 'wipeout current buffer.' })
  Keymap.register(e_mode.NORMAL, 'bo', Tools.wrap_f(Helper.delete_all_buffers, false, function(bufnr)
    return bufnr == Helper.get_cur_bufnr()
  end), { remap = false, desc = 'wipeout all buffers except current.' })
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()
end

return M

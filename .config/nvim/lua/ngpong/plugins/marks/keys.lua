local M = {}

local keymap = require('ngpong.common.keybinder')
local lazy   = require('ngpong.utils.lazy')
local marks  = lazy.require('marks')

local this = PLGS.marks
local e_mode = keymap.e_mode

local del_native_keymaps = function()
  keymap.unregister(e_mode.NORMAL, 'm')
end

local set_native_keymaps = function()
  for code = string.byte('a'), string.byte('z') do
    local lower = string.char(code)
    local upper = string.upper(lower)

    -- mark set
    do
      -- lowercase
      local lower_lhs = 'ms' .. lower
      local lower_rhs = TOOLS.wrap_f(this.api.set, lower)
      keymap.register(e_mode.NORMAL, lower_lhs, lower_rhs, { remap = false, desc = '' .. lower .. '' })

      -- uppercase
      local upper_lhs = 'ms' .. upper
      local upper_rhs = TOOLS.wrap_f(this.api.set, upper)
      keymap.register(e_mode.NORMAL, upper_lhs, upper_rhs, { remap = false, desc = '' .. upper .. '' })
    end

    -- mark delete
    do
      -- lowercase
      local lower_lhs = 'md' .. lower
      local lower_rhs = TOOLS.wrap_f(this.api.del, lower)
      keymap.register(e_mode.NORMAL, lower_lhs, lower_rhs, { remap = false, desc = '' .. lower .. '' })

      -- uppercase
      local upper_lhs = 'md' .. upper
      local upper_rhs = TOOLS.wrap_f(this.api.del, upper)
      keymap.register(e_mode.NORMAL, upper_lhs, upper_rhs, { remap = false, desc = '' .. upper .. '' })
    end

    -- mark jump
    do
      -- lowercase
      local lower_lhs = 'me' .. lower
      local lower_rhs = TOOLS.wrap_f(this.api.jump, lower)
      keymap.register(e_mode.NORMAL, lower_lhs, lower_rhs, { remap = false, desc = '' .. lower .. '' })

      -- uppercase
      local upper_lhs = 'me' .. upper
      local upper_rhs = TOOLS.wrap_f(this.api.jump, upper)
      keymap.register(e_mode.NORMAL, upper_lhs, upper_rhs, { remap = false, desc = '' .. upper .. '' })
    end
  end

  keymap.register(e_mode.NORMAL, 'm,', function()
    HELPER.add_jumplist()
    marks.prev()
    HELPER.add_jumplist()
  end, { remap = false, desc = 'jump to prev.' })
  keymap.register(e_mode.NORMAL, 'm.', function()
    HELPER.add_jumplist()
    marks.next()
    HELPER.add_jumplist()
  end, { remap = false, desc = 'jump to next.' })
  keymap.register(e_mode.NORMAL, 'ms<leader>', TOOLS.wrap_f(lazy.access('marks', 'set_next')), { remap = false, desc = '[NEXT]' })
  keymap.register(e_mode.NORMAL, 'md<leader>', TOOLS.wrap_f(lazy.access('marks', 'delete_line')), { remap = false, desc = '[LINE]' })
  keymap.register(e_mode.NORMAL, 'md<CR>', TOOLS.wrap_f(lazy.access('marks', 'delete_buf')), { remap = false, desc = '[BUFFER]' })
  keymap.register(e_mode.NORMAL, 'mm', this.api.toggle_marks_list, { silent = true, remap = false, desc = 'toggle marks list.' })
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()
end

return M
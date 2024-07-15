local M = {}

local Icons  = require('ngpong.utils.icon')
local Keymap = require('ngpong.common.keybinder')
local Lazy   = require('ngpong.utils.lazy')
local libP   = require('ngpong.common.libp')
local Marks  = Lazy.require('marks')

local this = Plgs.marks

local e_mode = Keymap.e_mode

local del_native_keymaps = function()
  Keymap.unregister({ e_mode.NORMAL, e_mode.SELECT, e_mode.VISUAL }, 'm')
end

local set_native_keymaps = function()
  for code = string.byte('a'), string.byte('z') do
    local lower = string.char(code)
    local upper = string.upper(lower)

    -- mark set
    do
      -- lowercase
      local lower_lhs = 'ms' .. lower
      local lower_rhs = Tools.wrap_f(this.api.set, lower)
      Keymap.register(e_mode.NORMAL, lower_lhs, lower_rhs, { remap = false, desc = '' .. lower .. '' })

      -- uppercase
      local upper_lhs = 'ms' .. upper
      local upper_rhs = Tools.wrap_f(this.api.set, upper)
      Keymap.register(e_mode.NORMAL, upper_lhs, upper_rhs, { remap = false, desc = '' .. upper .. '' })
    end

    -- mark delete
    do
      -- lowercase
      local lower_lhs = 'md' .. lower
      local lower_rhs = Tools.wrap_f(this.api.del, lower)
      Keymap.register(e_mode.NORMAL, lower_lhs, lower_rhs, { remap = false, desc = '' .. lower .. '' })

      -- uppercase
      local upper_lhs = 'md' .. upper
      local upper_rhs = Tools.wrap_f(this.api.del, upper)
      Keymap.register(e_mode.NORMAL, upper_lhs, upper_rhs, { remap = false, desc = '' .. upper .. '' })
    end

    -- mark jump
    do
      -- lowercase
      local lower_lhs = 'me' .. lower
      local lower_rhs = Tools.wrap_f(this.api.jump, lower)
      Keymap.register(e_mode.NORMAL, lower_lhs, lower_rhs, { remap = false, desc = '' .. lower .. '' })

      -- uppercase
      local upper_lhs = 'me' .. upper
      local upper_rhs = Tools.wrap_f(this.api.jump, upper)
      Keymap.register(e_mode.NORMAL, upper_lhs, upper_rhs, { remap = false, desc = '' .. upper .. '' })
    end
  end

  Keymap.register(e_mode.NORMAL, 'm[', function()
    this.api.jump_2_prev()
  end, { remap = false, desc = 'jump to prev.' })
  Keymap.register(e_mode.NORMAL, 'm]', function()
    this.api.jump_2_next()
  end, { remap = false, desc = 'jump to next.' })
  Keymap.register(e_mode.NORMAL, 'ms<leader>', Tools.wrap_f(Lazy.access('marks', 'set_next')), { remap = false, desc = '[NEXT]' })
  Keymap.register(e_mode.NORMAL, 'md<leader>', function()
    local bufnr = Helper.get_cur_bufnr()
    local row, _ = Helper.get_cursor()

    local datas = Marks.mark_state.buffers[bufnr].marks_by_line[row]
    if not datas then
      return
    end

    local delete_marks = {}
    for _, _mark in pairs(datas) do
      table.insert(delete_marks, _mark)
    end

    table.sort(delete_marks, function(r, l)
      return string.byte(r) < string.byte(l)
    end)

    local texts = {}
    for _, _mark in pairs(delete_marks) do
      table.insert(texts, string.format('[[%s]]', _mark))
    end

    Marks.delete_line()
    this.api.on_mark_change()

    if next(texts) then
      Helper.notify_info(string.format('Success to delete marks %s', table.concat(texts, ' ')), 'System: marks', { icon = Icons.lsp_loaded })
    end
  end, { remap = false, desc = '<LINE>' })
  Keymap.register(e_mode.NORMAL, 'md<CR>', libP.async.void(function()
      local bufnr = Helper.get_cur_bufnr()

      local datas = Marks.mark_state.buffers[bufnr].marks_by_line
      if not datas then
        return
      end

      local delete_marks = {}
      for _, _marks in pairs(datas) do
        for _, _mark in pairs(_marks) do
          table.insert(delete_marks, _mark)
        end
      end

      table.sort(delete_marks, function(r, l)
        return string.byte(r) < string.byte(l)
      end)

      local texts = {}
      for _, _mark in pairs(delete_marks) do
        table.insert(texts, string.format('[[%s]]', _mark))
      end

      this.api.dels(delete_marks)

      if next(texts) then
        Helper.notify_info(string.format('Success to delete marks %s', table.concat(texts, ' ')), 'System: marks', { icon = Icons.lsp_loaded })
      end
    end),
    { remap = false, desc = '<BUFFER>' }
  )
  Keymap.register(e_mode.NORMAL, 'mm', Tools.wrap_f(Plgs.trouble.api.toggle, 'mark'), { silent = true, remap = false, desc = 'toggle document marks list.' })
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()
end

return M

local M = {}

local icons = require('ngpong.utils.icon')
local lazy  = require('ngpong.utils.lazy')
local marks = lazy.require('marks')

M.set = function(name)
  local code = string.byte(name)
  local compare = '\'' .. name
  local row, _ = HELPER.get_cursor()
  if code >= 65 and code <= 90 then
    for _, data in ipairs(vim.fn.getmarklist()) do
      if data.mark == compare then
        if data.pos[2] == row then
          return
        else
          HELPER.notify_warn('Replace mark [' .. name .. '] from `' .. data.file .. ':' .. data.pos[2] .. '`', 'System: marks')
          break
        end
      end
    end
  elseif code >= 97 and code <= 122 then
    for _, data in ipairs(vim.fn.getmarklist("%")) do
      if data.mark == compare then
        if data.pos[2] == row then
          return
        else
          HELPER.notify_warn('Replace mark [' .. name .. '] from `' .. data.pos[2] .. '`', 'System: marks')
          break
        end
      end
    end
  else
    return
  end

  marks.mark_state:place_mark_cursor(name)
  HELPER.presskeys('m' .. name)
end

M.del = function(name)
  marks.mark_state:delete_mark(name)
end

M.jump = function(name)
  HELPER.presskeys('`' .. name)
  HELPER.add_jumplist()
end

M.send_marks_2_qf = function(target, cb)
  HELPER.clear_qflst()

  if type(target) == 'number' or target == nil then
    marks.mark_state:buffer_to_list('quickfixlist', target)
  else
    marks.mark_state:all_to_list('quickfixlist')
  end

  if cb then
    cb()
  end
end

M.toggle_marks_list = function(target)
  M.send_marks_2_qf(target, function()
    PLGS.trouble.api.open('quickfix', 'Marks ' .. (not target and 'current buffer' or 'workspace'))
  end)
end

return M

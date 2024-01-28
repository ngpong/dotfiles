local M = {}

local lazy  = require('ngpong.utils.lazy')
local marks = lazy.require('marks')

M.set = function(name)
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

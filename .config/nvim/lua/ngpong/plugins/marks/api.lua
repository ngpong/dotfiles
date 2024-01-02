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

M.toggle_marks_list = function()
  marks.mark_state:all_to_list()
  PLGS.trouble.api.open('loclist', 'Marks')
end

return M
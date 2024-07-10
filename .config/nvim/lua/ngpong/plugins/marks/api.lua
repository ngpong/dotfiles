local M = {}

local Autocmd = require('ngpong.common.autocmd')
local Lazy    = require('ngpong.utils.lazy')
local Marks   = Lazy.require('marks')

M.set = function(name)
  local compare = '\'' .. name
  local row, _ = Helper.get_cursor()

  if M.is_upper_mark(name) then
    for _, data in ipairs(vim.fn.getmarklist()) do
      if data.mark == compare then
        if data.pos[2] == row then
          return
        else
          Helper.notify_warn('Replace mark [' .. name .. '] from `' .. data.file .. ':' .. data.pos[2] .. '`', 'System: marks')
          break
        end
      end
    end
  elseif M.is_lower_mark(name) then
    for _, data in ipairs(vim.fn.getmarklist("%")) do
      if data.mark == compare then
        if data.pos[2] == row then
          return
        else
          Helper.notify_warn('Replace mark [' .. name .. '] from `' .. data.pos[2] .. '`', 'System: marks')
          break
        end
      end
    end
  else
    return
  end

  Marks.mark_state:place_mark_cursor(name)
  Helper.presskeys('m' .. name)

  M.on_mark_change()
end

M.del = function(name)
  Marks.mark_state:delete_mark(name)

  M.on_mark_change()
end

M.jump = function(name)
  Helper.presskeys('`' .. name)
  Helper.add_jumplist()
end

M.is_upper_mark = function(mark)
  local code = string.byte(mark)
  return code >= 65 and code <= 90
end

M.is_lower_mark = function(mark)
  local code = string.byte(mark)
  return code >= 97 and code <= 122
end

M.is_char_mark = function(mark)
  local code = string.byte(mark)
  return (code >= 97 and code <= 122) or code >= 65 and code <= 90
end

M.on_mark_change = function()
  Autocmd.exec('User', { pattern = 'MarkDeleteUser' })
end

return M

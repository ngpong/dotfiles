local M = {}

local events          = require('ngpong.common.events')
local lazy            = require('ngpong.utils.lazy')
local buffline_state  = lazy.require('bufferline.state')
local buffline_groups = lazy.require('bufferline.groups')

local e_events = events.e_name

M.redraw = function()
  vim.cmd.redrawtabline()
  vim.cmd.redraw()
end

M.is_pinned = function(bufnr)
  bufnr = bufnr or HELPER.get_cur_bufnr()

  for _, item in ipairs(buffline_state.components) do
    local element = item:as_element()
    if element.id == bufnr and buffline_groups._is_pinned(element) then
      return true
    end
  end

  return false
end

M.cycle_next = function(_)
  vim.cmd('BufferLineCycleNext')

  events.emit(e_events.CYCLE_NEXT_BUFFER)
end

M.cycle_prev = function(_)
  vim.cmd('BufferLineCyclePrev')

  events.emit(e_events.CYCLE_PREV_BUFFER)
end

M.move_next = function(_)
  vim.cmd('BufferLineMoveNext')
end

M.move_prev = function(_)
  vim.cmd('BufferLineMovePrev')
end

M.pin = function(_)
  vim.cmd('BufferLineTogglePin')
end

M.select = function(_)
  vim.cmd('BufferLinePick')

  events.emit(e_events.SELECT_TARGET_BUFFER)
end

return M
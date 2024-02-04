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

M.is_pinned = function(arg)
  if type(arg) == 'number' then
    local bufnr = arg or HELPER.get_cur_bufnr()

    for _, item in ipairs(buffline_state.components) do
      local element = item:as_element()
      if element.id == bufnr and buffline_groups._is_pinned(element) then
        return true
      end
    end
  elseif type(arg) == 'table' then
    local element = arg

    return buffline_groups._is_pinned(element)
  end

  return false
end

M.cycle_next = function(_)
  local success, _ = pcall(vim.cmd, 'keepjumps BufferLineCycleNext')

  if success then
    events.emit(e_events.CYCLE_NEXT_BUFFER)
  end
end

M.cycle_prev = function(_)
  local success, _ = pcall(vim.cmd, 'keepjumps BufferLineCyclePrev')

  if success then
    events.emit(e_events.CYCLE_PREV_BUFFER)
  end
end

M.move_next = function(_)
  pcall(vim.cmd, 'BufferLineMoveNext')
end

M.move_prev = function(_)
  pcall(vim.cmd, 'BufferLineMovePrev')
end

M.pin = function(_)
  pcall(vim.cmd, 'BufferLineTogglePin')
end

M.select = function(_)
  local success, _ = pcall(vim.cmd, 'keepjumps BufferLinePick')

  if success then
    events.emit(e_events.SELECT_TARGET_BUFFER)
  end
end

M.is_plugin_loaded = function()
  return PLGS.is_loaded('bufferline.nvim')
end

return M

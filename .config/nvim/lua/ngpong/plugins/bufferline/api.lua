local M = {}

local Events         = require('ngpong.common.events')
local Lazy           = require('ngpong.utils.lazy')
local BufflineState  = Lazy.require('bufferline.state')
local BufflineGroups = Lazy.require('bufferline.groups')

local e_name = Events.e_name

M.redraw = function()
  vim.cmd.redrawtabline()
  vim.cmd.redraw()
end

M.is_pinned = function(arg)
  if type(arg) == 'number' then
    local bufnr = arg or Helper.get_cur_bufnr()

    for _, item in ipairs(BufflineState.components) do
      local element = item:as_element()
      if element.id == bufnr and BufflineGroups._is_pinned(element) then
        return true
      end
    end
  elseif type(arg) == 'table' then
    local element = arg

    return BufflineGroups._is_pinned(element)
  elseif type(arg) == 'string' and arg == 'all' then
    for _, item in ipairs(BufflineState.components) do
      local element = item:as_element()
      if BufflineGroups._is_pinned(element) then
        return true
      end
    end

    return false
  end

  return false
end

M.get_components = function()
  return BufflineState.components
end

M.cycle_next = function(_)
  local success, _ = pcall(vim.cmd, 'keepjumps BufferLineCycleNext')

  if success then
    Events.emit(e_name.CYCLE_NEXT_BUFFER)
  end
end

M.cycle_prev = function(_)
  local success, _ = pcall(vim.cmd, 'keepjumps BufferLineCyclePrev')

  if success then
    Events.emit(e_name.CYCLE_PREV_BUFFER)
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
    Events.emit(e_name.SELECT_TARGET_BUFFER)
  end
end

M.is_plugin_loaded = function()
  return Plgs.is_loaded('bufferline.nvim')
end

return M

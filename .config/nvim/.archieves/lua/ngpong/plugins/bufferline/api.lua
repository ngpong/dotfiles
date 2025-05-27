local M = {}

local BufflineState     = vim.__lazy.require("bufferline.state")
local BufflineGroups    = vim.__lazy.require("bufferline.groups")
local BufflineConstants = vim.__lazy.require("bufferline.constants")
local BufflineUI        = vim.__lazy.require("bufferline.ui")

local etypes = vim.__event.types

M.redraw = function()
  vim.cmd.redrawtabline()
  vim.cmd.redraw()
end

M.is_activation_element = function (element)
  local is_activation = true
  if element:visibility() == BufflineConstants.visibility.NONE then
    is_activation = false
  end

  return is_activation
end

M.get_activation_bufnr = function()
  for _, _item in ipairs(BufflineState.components) do
    local element = _item:as_element()
    if M.is_activation_element(element) then
      return element.id
    end
  end

  return nil
end

M.is_pinned = function(arg)
  if type(arg) == "number" then
    local bufnr = arg or vim.__buf.current()

    for _, item in ipairs(BufflineState.components) do
      local element = item:as_element()
      if element.id == bufnr and BufflineGroups._is_pinned(element) then
        return true
      end
    end
  elseif type(arg) == "table" then
    local element = arg

    return BufflineGroups._is_pinned(element)
  elseif type(arg) == "string" and arg == "all" then
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
  local success, _ = pcall(vim.cmd, "keepjumps BufferLineCycleNext")

  if success then
    vim.__event.emit(etypes.CYCLE_NEXT_BUFFER)
    vim.__autocmd.exec("User", { pattern = "BufferLineStateChange" })
  end
end

M.cycle_prev = function(_)
  local success, _ = pcall(vim.cmd, "keepjumps BufferLineCyclePrev")

  if success then
    vim.__event.emit(etypes.CYCLE_PREV_BUFFER)
    vim.__autocmd.exec("User", { pattern = "BufferLineStateChange" })
  end
end

M.move_next = function(_)
  pcall(vim.cmd, "BufferLineMoveNext")
  vim.__autocmd.exec("User", { pattern = "BufferLineStateChange" })
end

M.move_prev = function(_)
  pcall(vim.cmd, "BufferLineMovePrev")
  vim.__autocmd.exec("User", { pattern = "BufferLineStateChange" })
end

M.pin = function(element)
  if element then
    BufflineGroups.add_element("pinned", element)
  else
    pcall(vim.cmd, "BufferLineTogglePin")
  end

  vim.__autocmd.exec("User", { pattern = "BufferLineStateChange" })
end

M.select = function(_)
  local success, _ = pcall(vim.cmd, "keepjumps BufferLinePick")

  if success then
    vim.__event.emit(etypes.SELECT_TARGET_BUFFER)
    vim.__autocmd.exec("User", { pattern = "BufferLineStateChange" })
  end
end

M.is_plugin_loaded = function()
  return vim.__plugin.loaded("bufferline.nvim")
end

M.refresh = function()
  BufflineUI.refresh()
end

return M

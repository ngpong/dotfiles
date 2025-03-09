local M = {}

local Marks      = vim.__lazy.require("marks")
local MarksUtils = vim.__lazy.require("marks.utils")

M.set = function(name)
  local compare = "'" .. name
  local row, _ = vim.__cursor.get()

  if M.is_upper_mark(name) then
    for _, data in ipairs(vim.fn.getmarklist()) do
      if data.mark == compare then
        if data.pos[2] == row then
          return
        else
          vim.__notifier.warn("Replace mark [" .. name .. "] from `" .. data.file .. ":" .. data.pos[2] .. "`")
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
          vim.__notifier.warn("Replace mark [" .. name .. "] from `" .. data.pos[2] .. "`")
          break
        end
      end
    end
  else
    return
  end

  Marks.mark_state:place_mark_cursor(name)
  vim.__key.press("m" .. name)

  M.on_mark_change()
end

M.del = function(name)
  Marks.mark_state:delete_mark(name)

  M.on_mark_change()
end

M.dels = function(marks)
  if not next(marks) then
    return
  end

  for _, _mark in pairs(marks) do
    Marks.mark_state:delete_mark(_mark)
  end

  M.on_mark_change()
end

M.jump = function(name)
  vim.__key.press("`" .. name)
  vim.__jumplst.add()
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
  vim.__autocmd.exec("User", { pattern = "MarkChanged" })
end

M.jump_2_prev = function()
  local mark_state = Marks.mark_state

  local bufnr = vim.__buf.current()

  if not mark_state.buffers[bufnr] then
    vim.__notifier.warn("No more marks to jump to")
    return
  end

  local line, _ = vim.__cursor.get()
  local marks = {}
  for mark, data in pairs(mark_state.buffers[bufnr].placed_marks) do
    if MarksUtils.is_letter(mark) then
      marks[mark] = data
    end
  end

  if vim.tbl_isempty(marks) then
    vim.__notifier.warn("No more marks to jump to")
    return
  end

  local function comparator(x, y, _)
    return x.line < y.line
  end
  local prev = MarksUtils.search(marks, { line = line }, { line = -1 }, comparator, mark_state.opt.cyclic)

  if prev then
    vim.__jumplst.add()
    vim.__cursor.set(prev.line, prev.col)
    vim.__jumplst.add()
  else
    vim.__notifier.warn("No more marks to jump to")
  end
end

M.jump_2_next = function()
  local mark_state = Marks.mark_state

  local bufnr = vim.__buf.current()

  if not mark_state.buffers[bufnr] then
    vim.__notifier.warn("No more marks to jump to")
    return
  end

  local line, _ = vim.__cursor.get()
  local marks = {}
  for mark, data in pairs(mark_state.buffers[bufnr].placed_marks) do
    if MarksUtils.is_letter(mark) then
      marks[mark] = data
    end
  end

  if vim.tbl_isempty(marks) then
    vim.__notifier.warn("No more marks to jump to")
    return
  end

  local function comparator(x, y, _)
    return x.line > y.line
  end

  local next = MarksUtils.search(marks, { line = line }, { line = math.huge }, comparator, mark_state.opt.cyclic)

  if next then
    vim.__jumplst.add()
    vim.__cursor.set(next.line, next.col)
    vim.__jumplst.add()
  else
    vim.__notifier.warn("No more marks to jump to")
  end
end

return M

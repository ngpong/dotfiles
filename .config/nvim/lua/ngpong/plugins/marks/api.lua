local M = {}

local lazy  = require('ngpong.utils.lazy')
local marks = lazy.require('marks')
local path  = lazy.require('plenary.path')

M.set = function(name)
  local compare = '\'' .. name
  local row, _ = HELPER.get_cursor()

  if M.is_upper_mark(name) then
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
  elseif M.is_lower_mark(name) then
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

M.send_marks_2_qf = function(bufnr, fetch_all, cb)
  local cache = marks.mark_state.buffers
  if not next(cache) then
    return
  end

  bufnr = bufnr or HELPER.get_cur_bufnr()
  if cache[bufnr] == nil then
    HELPER.notify_err('check log')
    LOGGER.error(debug.traceback())
    LOGGER.error(bufnr)
    LOGGER.error(fetch_all)
    return
  end

  local bufname = HELPER.get_buf_name(bufnr)

  local qf_opts = {
    items = {},
    title = 'marks',
  }

  -- 当 target 指定为 all 或者 nil 的时候则获取当前 buffer 的
  -- 否则获取 target 指定 bufnr 的
  for _mark, _data in pairs(cache[bufnr].placed_marks) do
    table.insert(qf_opts.items, {
      filename = HELPER.get_buf_name(bufnr),
      lnum = _data.line,
      col = _data.col,
      text = "mark " .. _mark .. ": " .. vim.api.nvim_buf_get_lines(bufnr, _data.line - 1, _data.line, true)[1],
      priority = 0,
    })
  end

  if fetch_all then
    local workspace = HELPER.get_workspace()

    for _, _data in ipairs(vim.fn.getmarklist()) do
      local mark = _data.mark:sub(2,3)

      if M.is_upper_mark(mark) then
        local row  = _data.pos[2]
        local col  = _data.pos[3]
        local file = path:new(_data.file):expand()

        if file ~= bufname and file:match(workspace) then
          table.insert(qf_opts.items, {
            filename = file,
            lnum = row,
            col = col,
            text = "mark " .. mark .. ": " .. vim.api.nvim_buf_get_lines(bufnr, row - 1, row, true)[1],
            priority = file == bufname and 0 or 1
          })
        end
      end
    end
  end

  HELPER.clear_qflst()
  HELPER.set_qflst({}, 'r', qf_opts)

  if cb then
    cb()
  end
end

M.toggle_marks_list = function(bufnr, fetch_all)
  M.send_marks_2_qf(bufnr, fetch_all, function()
    PLGS.trouble.api.open('quickfix', 'Marks ' .. (not fetch_all and 'current buffer' or 'workspace'))
  end)
end

M.is_upper_mark = function(mark)
  local code = string.byte(mark)
  return code >= 65 and code <= 90
end

M.is_lower_mark = function(mark)
  local code = string.byte(mark)
  return code >= 97 and code <= 122
end

return M

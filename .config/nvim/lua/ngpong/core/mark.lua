local M = {}

function M.set(mark)
  local compare = "'" .. mark
  local row, _ = vim.__cursor.get()

  if M.is_upper_mark(mark) then
    for _, data in ipairs(vim.fn.getmarklist()) do
      if data.mark == compare then
        if data.pos[2] == row then
          return
        else
          vim.__notifier.warn("Replace mark [" .. mark .. "] from `" .. data.file .. ":" .. data.pos[2] .. "`")
          break
        end
      end
    end
  elseif M.is_lower_mark(mark) then
    for _, data in ipairs(vim.fn.getmarklist("%")) do
      if data.mark == compare then
        if data.pos[2] == row then
          return
        else
          vim.__notifier.warn("Replace mark [" .. mark .. "] from `" .. data.pos[2] .. "`")
          break
        end
      end
    end
  else
    return
  end

  vim.__key.press("m" .. mark)
end

function M.get(mark, opts)
  opts = opts or {}

  if M.is_upper_mark(mark) then
    return vim.api.nvim_get_mark(mark, opts)
  elseif M.is_lower_mark(mark) then
    return vim.api.nvim_buf_get_mark(opts.buf or 0, mark)
  end
end

function M.del(mark, force_write)
  vim.cmd.delmark(mark)

  if force_write then
    vim.cmd("wshada!")
  end

  vim.__notifier.info("Delete mark [" .. mark .. "]")
end

function M.jump(mark)
  vim.__key.press("`" .. mark)
  vim.__jumplst.add()
end

function M.is_upper_mark(mark)
  local code = string.byte(mark)
  return code >= 65 and code <= 90
end

function M.is_lower_mark(mark)
  local code = string.byte(mark)
  return code >= 91 and code <= 122
end

function M.is_char_mark(mark)
  local code = string.byte(mark)
  return (code >= 97 and code <= 122) or code >= 65 and code <= 90
end


return M
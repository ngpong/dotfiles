local tools = {}

tools.tbl_dump = function(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
        if type(k) ~= 'number' then k = '"' .. k .. '"' end
        s = s .. '[' .. k .. '] = ' .. tools.tbl_dump(v) .. ', '
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

tools.tbl_contains = function(t, v)
  return vim.tbl_contains(t, v)
end

tools.equal = function(lhs, rhs)
  return vim.deep_equal(lhs, rhs)
end

tools.tbl_rr_extend = function(...)
  return vim.tbl_deep_extend('force', ...)
end

tools.tbl_r_extend = function(org, ...)
  local function can_merge(v)
    return type(v) == 'table' and (vim.tbl_isempty(v) or not vim.isarray(v))
  end

  if select('#', ...) <= 0 then
    return
  end

  for i = 1, select('#', ...) do
    local tbl = select(i, ...)
    if tbl then
      for k, v in pairs(tbl) do
        if can_merge(v) and can_merge(org[k]) then
          tools.tbl_r_extend(org[k], v)
        else
          org[k] = v
        end
      end
    end
  end
end

tools.tbl_pack = function(...)
  return { n = select("#", ...), ... }
end

tools.tbl_unpack = function(t, i, j)
  return table.unpack(t, i or 1, j or t.n or table.maxn(t))
end

tools.tbl_length = function(t)
  if vim.isarray(t) then
    return #t
  else
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
  end
end

tools.get_workspace = function()
  if tools.___workspace == nil then
    local success, dir = pcall(vim.fn.getcwd)
    if success then
      tools.___workspace = dir
    end
  end

  return tools.___workspace
end

tools.get_workspace_sha1 = function()
  if tools.___workspace_sha1 == nil then
    tools.___workspace_sha1 = require('sha1').sha1(tools.get_workspace())
  end

  return tools.___workspace_sha1
end

tools.curpath = function()
  return vim.fn.expand('%:p:h')
end

tools.curpath_exist = function(path)
  return string.find(tools.curpath(), path)
end

tools.enum = function(t)
  vim.tbl_add_reverse_lookup(t)
  return t
end

tools.enum_read = function(e)
  return e
end

tools.cur_thread = function()
  return coroutine.running()
end

tools.tostring = function(key)
  return vim.inspect(key)
end

tools.split = function(inputString, sep)
  local fields = {}

  local pattern = string.format('([^%s]+)', sep)
  local _ = string.gsub(inputString, pattern, function(c)
    fields[#fields + 1] = c
  end)

  return fields
end

tools.get_cwd = function()
  local success, cwd = pcall(vim.fn.getcwd)
  if success then
    return cwd
  else
    return ''
  end
end

tools.exec_cmd = function(cmd)
  local result = vim.fn.systemlist(cmd)

  -- An empty result is ok
  if vim.v.shell_error ~= 0 or (#result > 0 and vim.startswith(result[1], 'fatal:')) then
    return false, {}
  else
    return true, result
  end
end

tools.octal_to_utf8 = function(text)
  local convert_octal_char = function(octal)
    return string.char(tonumber(octal, 8))
  end

  -- git uses octal encoding for utf-8 filepaths, convert octal back to utf-8
  local success, converted = pcall(string.gsub, text, '\\([0-7][0-7][0-7])', convert_octal_char)
  if success then
    return converted
  else
    return text
  end
end

tools.to_path = function(p)
  -- windows路径统一转换
  local fnl, _ = p:gsub('\\', '/')
  return fnl
end

tools.path_join = function(...)
  local args = { ... }
  if #args == 0 then
    return ''
  end

  local path_separator = '/'

  local all_parts = {}
  if type(args[1]) == 'string' and args[1]:sub(1, 1) == path_separator then
    all_parts[1] = ''
  end

  for _, arg in ipairs(args) do
    if arg == '' and #all_parts == 0 then
      all_parts = { '' }
    else
      local arg_parts = split(arg, path_separator)
      vim.list_extend(all_parts, arg_parts)
    end
  end
  return table.concat(all_parts, path_separator)
end

tools.stdpath = function(what)
  return vim.api.nvim_call_function('stdpath', { what })
end

tools.uuid = function()
  local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function (c)
    local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
    return string.format('%x', v)
  end)
end

tools.scandir = function(directory)
  local i, t, popen = 0, {}, io.popen

  local pfile = popen('ls -a "'..directory..'"')
  if not pfile then
    return t
  end

  for filename in pfile:lines() do
    if filename:match('%.') or filename:match('manager') then
      goto continue
    end

    i = i + 1
    t[i] = filename

      ::continue::
  end

  pfile:close()
  return t
end

tools.copy = function(obj)
  return vim.deepcopy(obj)
end

tools.isempty = function(s)
  return s == nil or s == ''
end

tools.is_callable = function(arg)
  return type(arg) == 'function' or ((getmetatable(arg) or {}).__call ~= nil)
end

tools.is_fwrapper = function(arg)
  return tools.is_callable(arg) and type(arg) == 'table' and next(arg.handlers or {})
end

tools.wrap_f = function(fc, ...)
  assert(tools.is_callable(fc), debug.traceback())

  local handler = { fc = fc, args = table.pack(...) }

  local wrapper = {
    handlers = { handler },
  }
  wrapper.append = function(handlers)
    for i=1, #handlers do
      wrapper.handlers[#wrapper.handlers+1] = handlers[i]
    end
  end
  setmetatable(wrapper, {
    __add = function(l, r)
      assert(tools.is_fwrapper(l), debug.traceback())
      assert(tools.is_fwrapper(r), debug.traceback())

      l.append(r.handlers)
      return l
    end,
    __call = function(self, ...)
      assert(tools.is_fwrapper(self), debug.traceback())

      local call_args = table.pack(...)

      for i=1, #self.handlers do
        local handler = self.handlers[i]

        for j=1, call_args.n do
          handler.args[handler.args.n + j] = call_args[j]
        end
        handler.args.n = handler.args.n + call_args.n

        handler.fc(table.unpack(handler.args, 1, handler.args.n))
      end
    end
  })

  return wrapper
end

tools.inject_f = function(f, ...)
  local args = { ... }
  local before = args[1]
  local after  = args[2]

  return function(...)
    if before and tools.is_callable(before) then
      before(...)
    end

    f(...)

    if after and tools.is_callable(after) then
      after(...)
    end
  end
end

tools.get_filename = function(path)
  return path:match('^.+/(.+)$')
end

tools.get_filestate = function(path)
  local success, stats = pcall(vim.loop.fs_stat, path)
  if success and stats then
    return stats
  else
    return nil
  end
end

return tools

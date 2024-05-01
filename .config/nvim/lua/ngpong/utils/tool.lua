local tool = {}

tool.tbl_dump = function(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
        if type(k) ~= 'number' then k = '"' .. k .. '"' end
        s = s .. '[' .. k .. '] = ' .. tool.tbl_dump(v) .. ', '
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

tool.tbl_contains = function(t, v)
  return vim.tbl_contains(t, v)
end

tool.equal = function(lhs, rhs)
  return vim.deep_equal(lhs, rhs)
end

tool.tbl_rr_extend = function(...)
  return vim.tbl_deep_extend('force', ...)
end

tool.tbl_r_extend = function(org, ...)
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
          tool.tbl_r_extend(org[k], v)
        else
          org[k] = v
        end
      end
    end
  end
end

tool.tbl_pack = function(...)
  return { n = select("#", ...), ... }
end

tool.tbl_unpack = function(t, i, j)
  return table.unpack(t, i or 1, j or t.n or table.maxn(t))
end

tool.tbl_length = function(t)
  if vim.isarray(t) then
    return #t
  else
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
  end
end

tool.get_workspace = function()
  if tool.___workspace == nil then
    local success, dir = pcall(vim.fn.getcwd)
    if success then
      tool.___workspace = dir
    end
  end

  return tool.___workspace
end

tool.get_workspace_sha1 = function()
  if tool.___workspace_sha1 == nil then
    tool.___workspace_sha1 = require('sha1').sha1(tool.get_workspace())
  end

  return tool.___workspace_sha1
end

tool.curpath = function()
  return vim.fn.expand('%:p:h')
end

tool.curpath_exist = function(path)
  return string.find(tool.curpath(), path)
end

tool.enum = function(t)
  vim.tbl_add_reverse_lookup(t)
  return t
end

tool.enum_read = function(e)
  return e
end

tool.cur_thread = function()
  return coroutine.running()
end

tool.tostring = function(key)
  return vim.inspect(key)
end

tool.split = function(inputString, sep)
  local fields = {}

  local pattern = string.format('([^%s]+)', sep)
  local _ = string.gsub(inputString, pattern, function(c)
    fields[#fields + 1] = c
  end)

  return fields
end

tool.get_cwd = function()
  local success, cwd = pcall(vim.fn.getcwd)
  if success then
    return cwd
  else
    return ''
  end
end

tool.exec_cmd = function(cmd)
  local result = vim.fn.systemlist(cmd)

  -- An empty result is ok
  if vim.v.shell_error ~= 0 or (#result > 0 and vim.startswith(result[1], 'fatal:')) then
    return false, {}
  else
    return true, result
  end
end

tool.octal_to_utf8 = function(text)
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

tool.to_path = function(p)
  -- windows路径统一转换
  local fnl, _ = p:gsub('\\', '/')
  return fnl
end

tool.path_join = function(...)
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
      local arg_parts = tool.split(arg, path_separator)
      vim.list_extend(all_parts, arg_parts)
    end
  end
  return table.concat(all_parts, path_separator)
end

tool.stdpath = function(what)
  return vim.api.nvim_call_function('stdpath', { what })
end

tool.uuid = function()
  local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function (c)
    local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
    return string.format('%x', v)
  end)
end

tool.scandir = function(directory)
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

tool.copy = function(obj)
  return vim.deepcopy(obj)
end

tool.isempty = function(s)
  return s == nil or s == ''
end

tool.is_callable = function(arg)
  return type(arg) == 'function' or ((getmetatable(arg) or {}).__call ~= nil)
end

tool.is_fwrapper = function(arg)
  return tool.is_callable(arg) and type(arg) == 'table' and next(arg.handlers or {})
end

tool.wrap_f = function(fc, ...)
  assert(tool.is_callable(fc), debug.traceback())

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
      assert(tool.is_fwrapper(l), debug.traceback())
      assert(tool.is_fwrapper(r), debug.traceback())

      l.append(r.handlers)
      return l
    end,
    __call = function(self, ...)
      assert(tool.is_fwrapper(self), debug.traceback())

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

tool.inject_f = function(f, ...)
  local args = { ... }
  local before = args[1]
  local after  = args[2]

  return function(...)
    if before and tool.is_callable(before) then
      before(...)
    end

    f(...)

    if after and tool.is_callable(after) then
      after(...)
    end
  end
end

tool.get_filename = function(path)
  return path:match('^.+/(.+)$')
end

tool.get_filestate = function(path)
  local success, stats = pcall(vim.loop.fs_stat, path)
  if success and stats then
    return stats
  else
    return nil
  end
end

tool.getenv = function(name)
  local ret = os.getenv(name)
  if ret == nil then
    return ''
  else
    return ret
  end
end

tool.get_homepath = function()
  if (tool.__home_path == nil) then
    tool.__home_path = tool.getenv('HOME')
  end

  return tool.__home_path;
end

return tool

local M = {}

local ffi = require("ffi")

local C = ffi.C

ffi.cdef [[
  typedef long time_t;

  int rand (void);
  void srand(unsigned seed);
  time_t time(time_t *timer);
]]

function M.equal(lhs, rhs)
  return vim.__str.encode(lhs) == vim.__str.encode(rhs)
end

function M.enum(t)
  vim.tbl_add_reverse_lookup(t)
  return t
end

function M.exec(cmd)
  local result = vim.fn.systemlist(cmd)

  -- An empty result is ok
  if vim.v.shell_error ~= 0 or (#result > 0 and vim.startswith(result[1], "fatal:")) then
    return false, {}
  else
    return true, result
  end
end

function M.uuid()
  local template ="xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
  return string.gsub(template, "[xy]", function (c)
    local v = (c == "x") and M.rand(0, 0xf) or M.rand(8, 0xb)
    return string.format("%x", v)
  end)
end

function M.copy(obj)
  return vim.deepcopy(obj)
end

function M.isempty(s)
  return s == nil or s == ""
end

function M.is_callable(arg)
  return type(arg) == "function" or ((getmetatable(arg) or {}).__call ~= nil)
end

function M.is_fwrapper(arg)
  return M.is_callable(arg) and type(arg) == "table" and next(arg.handlers or {})
end

function M.wrap_f(fc, ...)
  assert(M.is_callable(fc), debug.traceback())

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
      assert(M.is_fwrapper(l), debug.traceback())
      assert(M.is_fwrapper(r), debug.traceback())

      l.append(r.handlers)
      return l
    end,
    __call = function(self, ...)
      assert(M.is_fwrapper(self), debug.traceback())

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

function M.inject_f(f, ...)
  local args = { ... }
  local before = args[1]
  local after  = args[2]

  return function(...)
    if before and M.is_callable(before) then
      before(...)
    end

    f(...)

    if after and M.is_callable(after) then
      after(...)
    end
  end
end

function M.getenv(name)
  local ret = os.getenv(name)
  if ret == nil then
    return ""
  else
    return ret
  end
end

C.srand(C.time(ffi.new("time_t[1]")))
function M.rand(min, max)
  if not min and not max then
    return C.rand()
  else
    assert(min <= max)
    return ((C.rand() % ((max + 1) - min)) + min)
  end
end

local __os_name
function M.get_os()
  if not __os_name then
    local osname

    if jit then -- ask LuaJIT first
      osname = jit.os
    else -- Unix, Linux variants
      local fh, _ = assert(io.popen("uname -o 2>/dev/null", "r"))
      if fh then
        osname = fh:read()
      end
      osname = osname or "windows"
    end

    if osname == "GNU/Linux" or osname == "Linux" then
      local f = io.popen("lsb_release -a")
      if f then
        local s = f:read("*a")
        f:close()
        osname = s:match("Distributor ID:%s*(%S+)") or osname
      end
    end

    __os_name = osname:lower()
  end

  return __os_name
end

return M
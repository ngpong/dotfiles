---@diagnostic disable: need-check-nil

local fmt = string.format

local lazy = {}

function lazy.wrap(t, handler)
  local export

  local function __loaded()
    return export ~= nil
  end

  local function __get()
    if not __loaded() then
      export = handler(t)
    end

    return export
  end

  local function __load()
    if not __loaded() then __get() end
  end

  local proxy = {
    __get = __get,
    __load = __load,
    __loaded = __loaded,
  }

  return setmetatable(proxy, {
    __index = function(_, key)
      return __get()[key]
    end,
    __newindex = function(_, key, value)
      __get()[key] = value
    end,
    __call = function(_, ...)
      return __get()(...)
    end,
  })
end

function lazy.require(require_path, handler)
  local use_handler = type(handler) == "function"

  return lazy.wrap(require_path, function(s)
    if use_handler then
      return handler(require(s))
    end
    return require(s)
  end)
end

function lazy.access(x, access_path)
  local keys = type(access_path) == "table"
      and access_path
      or vim.split(access_path, ".", { plain = true })

  local handler = function(module)
    local export = module

    for _, key in ipairs(keys) do
      export = export[key]
      assert(export ~= nil, fmt("Failed to lazy-access! No key '%s' in table!", key))
    end

    return export
  end

  if type(x) == "string" then
    return lazy.require(x, handler)
  else
    return lazy.wrap(x, handler)
  end
end

return lazy

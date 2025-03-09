---@diagnostic disable: need-check-nil
local fmt = string.format

local lazy = {}

function lazy.wrap(t, handler)
  local export

  local ret = {
    __get = function()
      if export == nil then
        export = handler(t)
      end

      return export
    end,
    __loaded = function()
      return export ~= nil
    end,
  }

  return setmetatable(ret, {
    __index = function(_, key)
      if export == nil then ret.__get() end
      return export[key]
    end,
    __newindex = function(_, key, value)
      if export == nil then ret.__get() end
      export[key] = value
    end,
    __call = function(_, ...)
      if export == nil then ret.__get() end
      return export(...)
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

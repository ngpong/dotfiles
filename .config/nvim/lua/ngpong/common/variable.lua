local variable = {}

local cache = {}

variable.set = function(k ,v)
  cache[k] = v
  return v
end

variable.unset = function(k)
  cache[k] = nil
end

variable.get = function(k, set_ifnil)
  if not cache[k] and set_ifnil then
    cache[k] = {}
  end

  return cache[k]
end

variable.debug = function()
  Logger.info(cache)
end

return variable

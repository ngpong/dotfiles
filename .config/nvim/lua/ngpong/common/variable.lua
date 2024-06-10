local variable = {}

local cache = {}

variable.set = function(k ,v)
  cache[k] = v
end

variable.unset = function(k)
  cache[k] = nil
end

variable.get = function(k)
  return cache[k]
end

variable.debug = function()
  Logger.info(cache)
end

return variable

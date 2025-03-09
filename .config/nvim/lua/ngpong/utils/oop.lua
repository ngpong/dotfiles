local tablex = require("pl.tablex")

local class_declarations = {}
local function newinstance(obj)
  if not obj then
    return nil
  end

  local mt = getmetatable(obj)

  local res = newinstance(mt)

  local objcpy = tablex.copy(obj)
  objcpy.__index = objcpy
  objcpy.__base = res

  local decla = class_declarations[obj]
  if decla then
    decla(objcpy, res)
  end

  if res then
    return setmetatable(objcpy, res)
  else
    return objcpy
  end
end

local object = {}

function object:__init()
end

function object:new(...)
  local o = newinstance(self) or {}
  o.__index = nil
  o:__init(...)

  return o
end

function object:extend(f)
  local c = self
  local o = setmetatable({}, c)
  c.__index = c

  if f and type(f) == "function" then
    class_declarations[o] = f
  end

  return o
end

return {
  def = function(...)
    return object:extend(...)
  end
}
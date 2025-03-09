local plugins = {}

local plgs___seq = 0

local function _is_loaded(plugin)
  return require("lazy.core.config").plugins[plugin]._.loaded ~= nil
end

return setmetatable({
  is_loaded = function(plugin)
    local success, ret = pcall(_is_loaded, plugin)
    if not success then
      return false
    else
      return ret
    end
  end,
  record_seq = function(key)
    -- plgs___seq = plgs___seq or 0
    -- plgs___seq = plgs___seq + 1
    -- vim.__logger.debug("Execute [" .. (key and key or "") .. "] " .. plgs___seq)
  end,
}, {
  __index = function(self, k)
    local plugin = plugins[k]

    if not plugin then
      local path = "ngpong.plugins." .. k
      assert(pcall(require, path), debug.traceback())

      plugin = setmetatable({}, {
        __index = function(_self, _k)
          local success, module = pcall(require, path .. "." .. _k)
          assert(success, "load plugin module error, plugin [" .. k .. "] module [" .. _k .. "].")

          _self[_k] = module
          return module
        end,
      })

      plugins[k] = plugin
    end

    return plugin
  end,
})

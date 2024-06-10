return setmetatable({
  setup = function()
    _G.Plgs = require('ngpong.plugins')

    require('ngpong.plugins.bootstrap').ensure_install()
    require('ngpong.plugins.bootstrap').register_event()
    require('ngpong.plugins.bootstrap').register_keymap()
    require('ngpong.plugins.bootstrap').laungh()
  end,
  is_loaded = function(plugin)
    return require('lazy.core.config').plugins[plugin]._.loaded ~= nil
  end,
  record_seq = function(key)
    -- _G.plgs___seq = _G.plgs___seq or 0
    -- _G.plgs___seq = _G.plgs___seq + 1
    -- Logger.debug('Execute [' .. (key and key or '') .. '] ' .. _G.plgs___seq)
  end,
}, {
  __index = function(self, k)
    local path = 'ngpong.plugins.' .. k
    assert(pcall(require, path), debug.traceback())

    local plugin = setmetatable({}, {
      __index = function(_self, _k)
        local success, module = pcall(require, path .. '.' .. _k)
        if not success then
          Logger.error(module)
          assert(false, 'load plugin module error, plugin [' .. k .. '] module [' .. _k .. '].')
        end

        _self[_k] = module
        return module
      end,
    })

    self[k] = plugin
    return plugin
  end,
})

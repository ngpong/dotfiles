return {
  setup = function()
    table.pack = table.pack or function(...)
      return { n = select('#', ...), ... }
    end
    table.unpack = table.unpack or unpack

    -- vim.inspect 在某些情况下会报错，先暂时这么捕捉错误先
    local src_inspect = vim.inspect
    vim.inspect = function(root, options)
      local success
      local ret

      success, ret = pcall(src_inspect, root, options)
      if not success then
        success, ret = pcall(src_inspect, root, options)
      end

      if not success then
        Logger.error(root)
        Logger.error(options)
        Logger.error(success)
        Logger.error(ret)
      end

      return ret or ''
    end

    _G.VAR = require('ngpong.common.variable')
    _G.Helper = require('ngpong.common.helper')

    -- require('ngpong.common.events').track_events()
  end,
}

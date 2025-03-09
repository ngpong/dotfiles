local M = {}

function M.get(p)
  local success, ret = pcall(function()
    return require("lazy.core.config").plugins[p]
  end, p)

  if not success then
    return nil
  else
    return ret
  end
end

function M.loaded(p)
  return M.get(p)._.loaded ~= nil
end

function M.load(p)
  return require("lazy").load({ plugins = { p } })
end

function M.opts(p)
  local plugin = require("lazy.core.config").plugins[p]
  if not plugin then
    return {}
  end
  local P = require("lazy.core.plugin")
  return P.values(plugin, "opts", false)
end

function M.has(p)
  return require("lazy.core.config").spec.plugins[p] ~= nil
end

return M
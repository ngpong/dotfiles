local M = {}

M.setup = function()
  -- https://github.com/L3MON4D3/LuaSnip/issues/258
  -- https://github.com/L3MON4D3/LuaSnip/issues/872

  require('luasnip').config.set_config({
    history = false, -- (deprecated)
    keep_roots = false,
    link_roots = false,
    link_children = false,

    enable_autosnippets = false,
    -- region_check_events = { 'CursorMoved', 'CursorHold', 'InsertEnter' }
  })
end

return M

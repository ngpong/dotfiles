local M = {}

local Lazy    = require('ngpong.utils.lazy')
local Bouncer = Lazy.require('ngpong.utils.debounce')
local Lualine = Lazy.require('lualine')

M.setup = function()
  local original_refresh = Lualine.refresh
  Lualine.refresh = Bouncer.throttle_trailing(25, true, vim.schedule_wrap(function(...)
    original_refresh(...)
  end));
end

return M

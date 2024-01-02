local M = {}

local events = require('ngpong.common.events')

local this = PLGS.indentscope
local e_events = events.e_name

M.setup = function()
  events.rg(e_events.FILE_TYPE, function(state)
    if not this.filter(state.buf) then
      return
    end

    vim.b.miniindentscope_disable = true
  end)
end

return M
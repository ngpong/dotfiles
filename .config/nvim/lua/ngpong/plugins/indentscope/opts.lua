local M = {}

local Events = require('ngpong.common.events')

local e_name = Events.e_name

local this = Plgs.indentscope

M.setup = function()
  Events.rg(e_name.FILE_TYPE, function(state)
    if not this.filter(state.buf) then
      return
    end

    vim.b.miniindentscope_disable = true
  end)
end

return M
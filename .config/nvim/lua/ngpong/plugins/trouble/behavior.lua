local M = {}

local Events = require('ngpong.common.events')

local e_name = Events.e_name

M.setup = function()
  Events.rg(e_name.FILE_TYPE, function(state)
    if 'trouble' == state.file then
      Events.emit(e_name.CREATE_TROUBLE_LIST, { buf = state.buf })
    end
  end)
end

return M

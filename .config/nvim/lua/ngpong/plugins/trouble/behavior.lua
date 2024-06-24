local M = {}

local Events = require('ngpong.common.events')

local e_name = Events.e_name

local this = Plgs.trouble

M.setup = function()
  Events.rg(e_name.FILE_TYPE, function(state)
    if 'trouble' == state.file and this.api.find_view_by_bufnr(state.buf) then
      Events.emit(e_name.CREATE_TROUBLE_LIST, { buf = state.buf })
    end
  end)
end

return M

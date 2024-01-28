local M = {}

local events = require('ngpong.common.events')
local lazy   = require('ngpong.utils.lazy')
local async  = lazy.require('plenary.async')

local e_events = events.e_name

M.setup = function()
  events.rg(e_events.WIN_CLOSED, function(state)
    local bufnr = state.buf

    if 'Trouble' == HELPER.get_filetype(bufnr) then
      VAR.unset('TroubleSource')
    end
  end)

  events.rg(e_events.FILE_TYPE, function(state)
    if 'Trouble' == state.file then
      events.emit(e_events.CREATE_TROUBLE_LIST, { buf = state.buf })
    end
  end)
end

return M
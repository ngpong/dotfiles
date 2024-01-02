local M = {}

local events = require('ngpong.common.events')
local async  = require('plenary.async')

local e_events = events.e_name

M.setup = function()
  local patterns = {
    ['neo%-tree filesystem'] = 'filesystem',
    ['neo%-tree git_status'] = 'git_status',
    ['neo%-tree buffers'] = 'buffers',
    ['neo%-tree document_symbols'] = 'document_symbols',
  }

  events.rg(e_events.FILE_TYPE, async.void(function(state)
    if state.match ~= 'neo-tree' then
      return
    end

    async.util.scheduler()

    local bufname = HELPER.get_buf_name(state.buf)
    if TOOLS.isempty(bufname) then
      return
    end

    for _pattern, _source in pairs(patterns) do
      if bufname:match(_pattern) then
        events.emit(e_events.CREATE_NEOTREE_SOURCE, { bufnr = state.buf, source = _source })
        return
      end
    end
  end))
end

return M
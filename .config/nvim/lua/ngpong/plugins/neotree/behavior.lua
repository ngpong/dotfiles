local M = {}

local libP   = require('ngpong.common.libp')
local Events = require('ngpong.common.events')

local e_name = Events.e_name

M.setup = function()
  local patterns = {
    ['neo%-tree filesystem'] = 'filesystem',
    ['neo%-tree git_status'] = 'git_status',
    ['neo%-tree buffers'] = 'buffers',
    ['neo%-tree document_symbols'] = 'document_symbols',
  }

  Events.rg(e_name.FILE_TYPE, libP.async.void(function(state)
    if state.match ~= 'neo-tree' then
      return
    end

    libP.async.util.scheduler()

    if not Helper.is_buf_valid(state.buf) then
      return
    end

    local bufname = Helper.get_buf_name(state.buf)
    if Tools.isempty(bufname) then
      return
    end

    for _pattern, _source in pairs(patterns) do
      if bufname:match(_pattern) then
        Events.emit(e_name.CREATE_NEOTREE_SOURCE, { bufnr = state.buf, source = _source })
        return
      end
    end
  end))
end

return M

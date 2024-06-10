local M = {}

local Events  = require('ngpong.common.events')
local Autocmd = require('ngpong.common.autocmd')

local e_name = Events.e_name

local setup_autocmd = function()
  local group = Autocmd.new_augroup('native')

  group.on('BufReadPost', function(args)
    Events.emit(e_name.BUFFER_READ_POST, args)
  end)

  group.on('FileType', function(args)
    Events.emit(e_name.FILE_TYPE, args)
  end)

  group.on('VimEnter', function(args)
    Events.emit(e_name.VIM_ENTER, args)
  end)

  group.on('VimLeavePre', function(args)
    Events.emit(e_name.VIM_LEAVE_PRE, args)
  end)

  group.on('ExitPre', function(args)
    Events.emit(e_name.VIM_EXIT_PRE, args)
  end)

  group.on('BufNew', function(args)
    Events.emit(e_name.BUFFER_READ, args)
  end)

  group.on('BufEnter', function(args)
    Events.emit(e_name.BUFFER_ENTER, args)
  end)

  group.on('BufWinEnter', function(args)
    Events.emit(e_name.BUFFER_WIN_ENTER, args)
  end)

  group.on('BufAdd', function(args)
    Events.emit(e_name.BUFFER_ADD, args)
  end)

  group.on('BufDelete', function(args)
    Events.emit(e_name.BUFFER_DELETE, args)
  end)

  group.on('WinClosed', function(args)
    Events.emit(e_name.WIN_CLOSED, args)
  end)

  group.on({ 'CursorMoved', 'InsertLeave', 'CursorHold' }, function(args)
    Events.emit(e_name.CURSOR_NORMAL, args)
  end)
end

M.setup = function()
  setup_autocmd()
end

return M

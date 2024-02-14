local M = {}

local events  = require('ngpong.common.events')
local autocmd = require('ngpong.common.autocmd')

local e_events = events.e_name

local setup_autocmd = function()
  local group_id = autocmd.new_augroup("native")

  vim.api.nvim_create_autocmd('BufReadPost', {
    group = group_id,
    pattern = { '*' },
    callback = function(args)
      events.emit(e_events.BUFFER_READ_POST, args)
    end
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = group_id,
    pattern = { '*' },
    callback = function(args)
      events.emit(e_events.FILE_TYPE, args)
    end
  })

  vim.api.nvim_create_autocmd('VimEnter', {
    group = group_id,
    pattern = { '*' },
    callback = function(args)
      events.emit(e_events.VIM_ENTER, args)
    end
  })

  vim.api.nvim_create_autocmd('VimLeavePre', {
    group = group_id,
    pattern = { '*' },
    callback = function(args)
      events.emit(e_events.VIM_LEAVE_PRE, args)
    end
  })

  vim.api.nvim_create_autocmd('ExitPre', {
    group = group_id,
    pattern = { '*' },
    callback = function(args)
      events.emit(e_events.VIM_EXIT_PRE, args)
    end
  })

  vim.api.nvim_create_autocmd('BufNew', {
    group = group_id,
    pattern = { '*' },
    callback = function(args)
      events.emit(e_events.BUFFER_READ, args)
    end
  })

  vim.api.nvim_create_autocmd('BufEnter', {
    group = group_id,
    pattern = { '*' },
    callback = function(args)
      events.emit(e_events.BUFFER_ENTER, args)
    end
  })

  vim.api.nvim_create_autocmd('BufWinEnter', {
    group = group_id,
    pattern = { '*' },
    callback = function(args)
      events.emit(e_events.BUFFER_WIN_ENTER, args)
    end
  })

  vim.api.nvim_create_autocmd('BufAdd', {
    group = group_id,
    pattern = { '*' },
    callback = function(args)
      events.emit(e_events.BUFFER_ADD, args)
    end
  })

  vim.api.nvim_create_autocmd('BufDelete', {
    group = group_id,
    pattern = { '*' },
    callback = function(args)
      events.emit(e_events.BUFFER_DELETE, args)
    end
  })

  vim.api.nvim_create_autocmd('WinClosed', {
    group = group_id,
    pattern = { '*' },
    callback = function(args)
      events.emit(e_events.WIN_CLOSED, args)
    end
  })

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertLeave', 'CursorHold' }, {
    group = group_id,
    pattern = { '*' },
    callback = function(args)
      events.emit(e_events.CURSOR_NORMAL, args)
    end
  })
end

M.setup = function()
  setup_autocmd()
end

return M

local events = {}

local icons = require('ngpong.utils.icon')

local event_handlers = {}

events.e_name = {
  -- native
  BUFFER_READ = 1,
  VIM_ENTER = 2,
  BUFFER_ENTER = 3,
  BUFFER_WIN_ENTER = 4,
  BUFFER_READ_POST = 5,
  BUFFER_ADD = 6,
  BUFFER_DELETE = 7,
  FILE_TYPE = 8,
  WIN_CLOSED = 9,
  BUFFER_ENTER_ONCE = 10,

  -- explore tree
  SETUP_NEOTREE = 20,
  INIT_NEOTREE = 21,
  FREE_NEOTREE = 22,
  CREATE_NEOTREE_SOURCE = 23,

  -- buffer
  -- NOTE: 目前这些事件好像没啥用
  CYCLE_NEXT_BUFFER = 30,
  CYCLE_PREV_BUFFER = 31,
  SELECT_TARGET_BUFFER = 32,

  -- neoscroll
  SETUP_NEOSCROLL = 35,

  -- gitsigns
  ATTACH_GITSIGNS = 41,
  GITSIGNS_OPEN_POPUP = 42,
  GITSIGNS_OPEN_DIFFTHIS = 43,

  -- telescope
  SETUP_TELESCOPE = 46,

  -- lualine
  SETUP_LUALINE = 50,

  -- trouble
  CREATE_TROUBLE_LIST = 55,

  -- cmp
  SETUP_CMP = 60,

  -- LSP
  ATTACH_LSP = 70,

  -- nvim navic
  ATTACH_NAVIC = 80,

  -- which-key
  SETUP_WHICHKEY = 90,

  -- multicursors
  SETUP_MULTICURSORS = 100,
}

events.rg = function(name, fn)
  local handlers = event_handlers[name] or {}
  table.insert(handlers, fn)
  event_handlers[name] = handlers
end

events.unrg = function(name, fn)
  local handlers = event_handlers[name]
  for i = 1, (handlers and #handlers or 0) do
    if handlers[i] == fn then
      table.remove(handlers, i)
      return
    end
  end
end

events.emit = function(name, ...)
  local success = true
  for _, fn in pairs(event_handlers[name] or {}) do
    local status, res = pcall(fn, ...)
    if not status then
      success = false
      HELPER.notify_err('execute event error, please check log file for more information.', 'System: events')
      LOGGER.error(res)
    end
  end
  return success
end

events.get_events_name = function()
  return events.e_name
end

events.track_events = function()
  local filter = {
    -- [events.e_name.INIT_NEOTREE] = true,
    -- [events.e_name.BUFFER_READ] = true,
  }

  for _name, _val in pairs(events.e_name) do
    if filter[_val] == nil then
      events.rg(_val, function(...)
        local args = { ... }

        local msg = _name

        if #args > 0 then
          for _i, _arg in pairs(args) do
            if type(_arg) == 'table' then
              args[_i] = nil
            end
          end

          if #args > 0 then
            msg = msg .. ': ' .. table.concat(args, ', ')
          end
        end

        LOGGER.debug(msg)
      end)
    end
  end
end

return events

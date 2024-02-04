local M = {}

local events    = require('ngpong.common.events')
local json      = require('ngpong.utils.json')
local timestamp = require('ngpong.utils.timestamp')
local lazy      = require('ngpong.utils.lazy')
local bouncer   = lazy.require('ngpong.utils.debounce')
local path      = lazy.require('plenary.path')
local async     = lazy.require('plenary.async')

local e_events = events.e_name

local setup_extra_buffer_event = function()
  local bufnrs = {}

  -- 只触发一次的 BUFFER_ENTER event
  events.rg(e_events.BUFFER_ENTER, function(state)
    if bufnrs[state.buf] then
      return
    end

    bufnrs[state.buf] = true

    events.emit(e_events.BUFFER_ENTER_ONCE, state)
  end)

  events.rg(e_events.BUFFER_DELETE, function(state)
    bufnrs[state.buf] = nil
  end)

  -- 由于 VIM_ENTER 的时候不会触发 BUFFER_ENTER，所以手动触发一次
  events.emit(e_events.BUFFER_ENTER, { buf = HELPER.get_cur_bufnr() })
end

local setup_cleanup = function()
  -- clear jump list
  HELPER.clear_jumplist()

  -- clear search pattern
  HELPER.clear_searchpattern()
end

local setup_cursor_persist = function()
  local caches = {}

  local file = path:new(vim.fn.stdpath('data') .. '/cursor_presist/' .. HELPER.get_workspace_sha1() .. '.json')

  events.rg(e_events.VIM_ENTER, async.void(function(_)
    if not file:exists() then
      return
    end

    local data = file:read()
    caches = json.decode(data)

    -- 缓慢删除掉过期(一天未访问过的)的 key
    local cur_ts = timestamp.get_utc()
    for _k, _v in pairs(caches) do
      if cur_ts - (_v.ts or 0) > 60 * 60 * 24 * 1 * 100 then
        caches[_k] = nil
      end

      async.util.scheduler()
    end
  end))

  events.rg(e_events.VIM_LEAVE_PRE, function(args)
    if not file:exists() then
      file:touch({ parents = true })
    end

    file:write(json.encode(caches), 'w')
  end)

  events.rg(e_events.CURSOR, bouncer.throttle_trailing(500, true, async.void(function(args)
    async.util.scheduler()

    local bufnr = HELPER.get_cur_bufnr()
    if not HELPER.is_buf_valid(bufnr) then
      return
    end

    local bufname = HELPER.get_buf_name(bufnr):gsub(HELPER.get_workspace() .. '/', '')
    if TOOLS.isempty(bufname) then
      return
    end

    local row, col = HELPER.get_cursor()

    caches[bufname] = { row = row, col = col, ts = timestamp.get_utc() }
  end)))

  events.rg(e_events.BUFFER_READ_POST, function(args)
    local bufname = HELPER.get_buf_name(args.buf):gsub(HELPER.get_workspace() .. '/', '')

    local cache = caches[bufname]
    if cache ~= nil then
      vim.api.nvim_win_set_cursor(0, { cache.row, cache.col })
    end
  end)
end

M.setup = function()
  events.rg(e_events.VIM_ENTER, function()
    -- setup cleanup logic
    setup_cleanup()

    -- steup extra events
    setup_extra_buffer_event()

    -- setup cursor persist logic
    setup_cursor_persist()
  end)
end

return M

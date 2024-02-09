local M = {}

local filter    = require('ngpong.native.filter')
local events    = require('ngpong.common.events')
local json      = require('ngpong.utils.json')
local timestamp = require('ngpong.utils.timestamp')
local lazy      = require('ngpong.utils.lazy')
local bouncer   = lazy.require('ngpong.utils.debounce')
local Path      = lazy.require('plenary.path')
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
  local path = Path.__get()

  local caches = {}

  local file = path:new(vim.fn.stdpath('data') .. '/cursor_presist/' .. TOOLS.get_workspace_sha1() .. '.json')

  events.rg(e_events.VIM_ENTER, async.void(function(_)
    if not file:exists() then
      return
    end

    local data = file:read()
    if TOOLS.isempty(data) then
      return
    end

    caches = json.decode(data)

    -- 对于使用命令行参数打开的文件，其在打开后不会触发 BUFFER_READ_POST 事件，需要我们手动触发一次
    for _, _bufnr in pairs(HELPER.get_all_bufs()) do
      if not HELPER.is_unnamed_buf(_bufnr) then
        events.emit(e_events.BUFFER_READ_POST, { buf = _bufnr })
      end
    end

    -- 缓慢删除掉过期(一天未访问过的)的 key
    local cur = timestamp.get_utc()
    local max = 1000 * 60 * 60 * 24 * 3 -- 3天
    for _k, _v in pairs(caches) do
      if cur - (_v.ts or 0) > max then
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

  events.rg(e_events.CURSOR_NORMAL, bouncer.throttle_trailing(400, true, async.void(function(args)
    async.util.scheduler()

    local bufnr = HELPER.get_cur_bufnr()
    if not HELPER.is_buf_valid(bufnr) then
      return
    end

    local bufname = HELPER.get_buf_name(bufnr):gsub(TOOLS.get_workspace() .. '/', '')
    if TOOLS.isempty(bufname) then
      return
    end

    -- 仅刷新指定文件类型的文件
    if filter(1, bufnr) then
      return
    end

    local row, col = HELPER.get_cursor()

    caches[bufname] = { row = row, col = col, ts = timestamp.get_utc() }
  end)))

  events.rg(e_events.BUFFER_READ_POST, async.void(function(args)
    -- hidden buffer 不更新
    if HELPER.is_buf_hidden(args.buf) then
      return
    end

    -- 浮动窗口下不更新
    if HELPER.is_floating_win(HELPER.get_winid(args.buf)) then
      return
    end

    local bufname = HELPER.get_buf_name(args.buf):gsub(TOOLS.get_workspace() .. '/', '')

    local cache = caches[bufname]
    if cache ~= nil and filter(2) then
      HELPER.set_cursor(cache.row, cache.col)
      HELPER.keep_screen_center()
    end
  end))
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

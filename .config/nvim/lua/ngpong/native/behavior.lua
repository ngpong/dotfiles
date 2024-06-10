local M = {}

local Filter    = require('ngpong.native.filter')
local Events    = require('ngpong.common.events')
local libP      = require('ngpong.common.libp')
local Json      = require('ngpong.utils.json')
local Timestamp = require('ngpong.utils.timestamp')
local Lazy      = require('ngpong.utils.lazy')
local Bouncer   = Lazy.require('ngpong.utils.debounce')

local e_name = Events.e_name

local setup_extra_buffer_event = function()
  local bufnrs = {}

  -- 只触发一次的 BUFFER_ENTER event
  Events.rg(e_name.BUFFER_ENTER, function(state)
    if bufnrs[state.buf] then
      return
    end

    bufnrs[state.buf] = true

    Events.emit(e_name.BUFFER_ENTER_ONCE, state)
  end)

  Events.rg(e_name.BUFFER_DELETE, function(state)
    bufnrs[state.buf] = nil
  end)

  -- 由于 VIM_ENTER 的时候不会触发 BUFFER_ENTER，所以手动触发一次
  Events.emit(e_name.BUFFER_ENTER, { buf = Helper.get_cur_bufnr() })
end

local setup_cleanup = function()
  -- clear jump list
  Helper.clear_jumplist()

  -- clear search pattern
  Helper.clear_searchpattern()
end

local setup_cursor_persist = function()
  local caches = {}

  local file = libP.path:new(vim.fn.stdpath('data') .. '/cursor_presist/' .. Tools.get_workspace_sha1() .. '.json')

  Events.rg(e_name.VIM_ENTER, libP.async.void(function(_)
    if not file:exists() then
      return
    end

    local data = file:read()
    if Tools.isempty(data) then
      return
    end

    caches = Json.decode(data)

    -- 对于使用命令行参数打开的文件，其在打开后不会触发 BUFFER_READ_POST 事件，需要我们手动触发一次
    for _, _bufnr in pairs(Helper.get_all_bufs()) do
      if not Helper.is_unnamed_buf(_bufnr) then
        Events.emit(e_name.BUFFER_READ_POST, { buf = _bufnr })
      end
    end

    -- 缓慢删除掉过期(一天未访问过的)的 key
    local cur = Timestamp.get_utc() or 0
    local max = 1000 * 60 * 60 * 24 * 3 -- 3天
    for _k, _v in pairs(caches) do
      if cur - (_v.ts or 0) > max then
        caches[_k] = nil
      end

      libP.async.util.scheduler()
    end
  end))

  Events.rg(e_name.VIM_LEAVE_PRE, function(args)
    if not file:exists() then
      file:touch({ parents = true })
    end

    file:write(Json.encode(caches), 'w')
  end)

  Events.rg(e_name.CURSOR_NORMAL, Bouncer.throttle_trailing(400, true, libP.async.void(function(args)
    libP.async.util.scheduler()

    local bufnr = Helper.get_cur_bufnr()
    if not Helper.is_buf_valid(bufnr) then
      return
    end

    local bufname = Helper.get_buf_name(bufnr):gsub(Tools.get_workspace() .. '/', '')
    if Tools.isempty(bufname) then
      return
    end
    if bufname:match('COMMIT_EDITMSG') then
      return
    end

    -- 仅刷新指定文件类型的文件
    if Filter(1, bufnr) then
      return
    end

    local row, col = Helper.get_cursor()

    caches[bufname] = { row = row, col = col, ts = Timestamp.get_utc() }
  end)))

  Events.rg(e_name.BUFFER_READ_POST, libP.async.void(function(args)
    -- hidden buffer 不更新
    if Helper.is_buf_hidden(args.buf) then
      return
    end

    -- 浮动窗口下不更新
    if Helper.is_floating_win(Helper.get_winid(args.buf)) then
      return
    end

    local bufname = Helper.get_buf_name(args.buf):gsub(Tools.get_workspace() .. '/', '')

    local cache = caches[bufname]
    if cache ~= nil and Filter(2) then
      Helper.set_cursor(cache.row, cache.col)
      Helper.keep_screen_center()
    end
  end))
end

M.setup = function()
  Events.rg(e_name.VIM_ENTER, function()
    -- setup cleanup logic
    setup_cleanup()

    -- steup extra events
    setup_extra_buffer_event()

    -- setup cursor persist logic
    setup_cursor_persist()
  end)
end

return M

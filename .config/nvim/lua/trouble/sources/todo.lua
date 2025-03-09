local Item          = vim.__lazy.require("trouble.item")
local TroubleConfig = vim.__lazy.require("trouble.config")
local TodoConfig    = vim.__lazy.require("todo-comments.config")
local Highlight     = vim.__lazy.require("todo-comments.highlight")

local t_api = vim._plugins.trouble.api

local etypes = vim.__event.types

local C = {}

local SourceManager = vim.__class.def(function(this)
  local cache = {}
  local cache_size = 0
  local view = {
    instance = nil,
    finish_init_items = false,
  }

  local function cvrt_2item(data)
    local wrap = {}

    local file, row, col, text = data:match("([^:]+):(%d+):(%d+):(.*)$")
    if not file then
      return
    end

    local start, finish, kw = Highlight.match(text)
    if not start then
      return
    end

    local _item = {
      filename = file,
      lnum = tonumber(row),
      col = tonumber(col),
      line = text,
      tag = TodoConfig.keywords[kw] or kw,
      text = vim.trim(text:sub(start)),
      message = vim.trim(text:sub(finish + 1)),
    }

    local item = Item.new({
      pos = { _item.lnum, _item.col - 1 },
      end_pos = { _item.lnum, _item.col - 1 + #_item.tag },
      text = _item.text,
      filename = _item.filename,
      item = _item,
      source = "todo",
    })

    wrap[1] = item
    Item.add_id(wrap)

    return wrap[1]
  end

  function this:attach(_view)
    view.instance = _view
    view.finish_init_items = false
  end

  function this:detach()
    view = {}
  end

  function this:is_attach()
    return view.instance ~= nil
  end

  function this:mode()
    return "todo"
  end

  function this:desc()
    return "Todo comments"
  end

  function this:refresh()
    vim.__autocmd.exec("User", { pattern = "TroubleTodoCacheChanged" })
  end

  function this:reset_cache()
    cache = {}
    cache_size = 0
  end

  function this:append_cache(items)
    for _, item in ipairs(items) do
      cache_size = cache_size + 1
      cache[cache_size] = item
    end
  end

  function this:get_cache()
    return cache
  end

  function this:replace_cache(items, filename)
    vim.__tbl.remove_iter(cache, function(t, i, _)
      return t[i].filename ~= filename
    end)

    vim.__tbl.insert_arr(cache, items)
  end

  function this:update_cache(bufnr)
    if not this:is_attach() or not view.finish_init_items then
      return
    end

    local filename = vim.__buf.name(bufnr)

    C.finder:exec({
      paths = { filename },
      on_exit = vim.__async.schedule_wrap(function(datas)
        local items, size = {}, 0
        for i = 1, #datas do
          items[size + 1] = cvrt_2item(datas[i])
          size = size + 1
        end

        C.source:replace_cache(items, filename)
        C.source:refresh()
      end),
    })
  end

  function this:new_cache()
    local path = vim.__path.cwd()
    local desc = this:desc()
    local mode = this:mode()

    local _exited = false
    local _shutdowned = false
    local function on_exit()
      _exited = true
      view.finish_init_items = true
    end
    local function on_shutdown()
      C.source:reset_cache()
      _shutdowned = true
    end
    local function on_err()
      C.source:reset_cache()
      _shutdowned = true
    end

    local _datas, _datas_size, _datas_idx = {}, 0, 1
    local function on_data(data)
      _datas[_datas_size + 1] = data
      _datas_size = _datas_size + 1
    end

    local on_fetch = vim.__async.void(function()
      local function can_fetch()
        return not _shutdowned and this:is_attach()
      end

      local max1, max2 = 20, TroubleConfig.get().max_items

      local r1, r2 = false, false

      while true do
        vim.__async.sleep(1)

        if not can_fetch() then
          return
        end

        local datas_size, datas_idx = _datas_size, _datas_idx

        if datas_size >= datas_idx then
          vim.__async.scheduler()
          if not can_fetch() then
            return
          end

          local items, size = {}, 0
          for i = datas_idx, datas_size do
            if i % max1 == 0 then
              vim.__async.scheduler()
              if not can_fetch() then
                return
              end
            end

            items[size + 1] = cvrt_2item(_datas[i])
            size = size + 1
          end
          _datas_idx = datas_idx + size

          this:append_cache(items)

          if not r1 and _datas_idx > max1 then -- 我们暂时能够看到的最大条数
            this:refresh()
            r1 = true
          elseif not r2 and _datas_idx > max2 then -- 配置上允许的最大条目数
            this:refresh()
            r2 = true
          end
        elseif _exited then -- 结束后
          return this:refresh()
        end
      end
    end)

    local function on_start()
      C.source:reset_cache()

      if not this:is_attach() then
        t_api.open(mode, { desc = desc })

        local timeout = false
        vim.defer_fn(function()
          timeout = true
        end, 1000)

        vim.__async.run(function()
          while true do
            if this:is_attach() then
              on_fetch()
              break
            elseif timeout then
              break
            else
              vim.__async.sleep(1)
            end
          end
        end)
      else
        on_fetch()
      end
    end

    C.finder:exec({
      paths = { path },
      on_start = on_start,
      on_data = on_data,
      on_exit = on_exit,
      on_err = on_err,
      on_shutdown = on_shutdown,
    })
  end
end)

-- stylua: ignore
local Finder = vim.__class.def(function(this)
  local L = {
    job = nil,
    progress = nil
  }

  local function fix_opts(opts)
    if (not opts.on_data) and (not opts.on_exit) then
      return false
    end

    if (not opts.paths) or (not next(opts.paths)) then
      return false
    end

    opts.on_data     = opts.on_data or function(_) end
    opts.on_exit     = opts.on_exit or function(_) end
    opts.on_start    = opts.on_start or function(_) end
    opts.on_err      = opts.on_err or function(_) end
    opts.on_shutdown = opts.on_shutdown or function(_) end

    return true
  end

  -- stylua: ignore
  local exec = function(opts)
    if not fix_opts(opts) then
      return
    end

    local paths       = opts.paths
    local on_data     = opts.on_data
    local on_exit     = opts.on_exit
    local on_start    = opts.on_start
    local on_err      = opts.on_err
    local on_shutdown = opts.on_shutdown

    this:try_shutdown()

    for i, _ in ipairs(paths) do
      paths[i] = paths[i] or "."
      paths[i] = vim.fn.fnamemodify(paths[i], ":p")
    end

    local command = TodoConfig.options.search.command

    if vim.fn.executable(command) ~= 1 then
      vim.__notifier.err(command .. " was not found on your path")
      return
    end

    local args = {}
    vim.list_extend(args, TodoConfig.options.search.args)
    vim.list_extend(args, { TodoConfig.search_regex(vim.__tbl.keys(TodoConfig.keywords)), unpack(paths) })

    vim.__job.new({
      command = command,
      args = args,
      on_start = function(j)
        L.progress = vim.__ui.Progresser:new {
          title = "trouble",
          ensure = 1,
          timeout = 500,
        }
        L.progress:start("Fetching " .. "[[" .. C.source:mode() .. "]]" .. " datas...")

        L.job = j

        on_start()
      end,
      on_stdout = function(error, data, j)
        if error then
          return
        end
        on_data(data)
      end,
      on_exit = function(j, code, signal)
        local results = j:result()

        repeat
          if code == 0x999 then
            on_shutdown()
            break
          end

          if code == 2 then
            on_err(results)
            break
          end

          on_exit(results)
        until true

        L.progress:dismiss()
        L.job = nil
      end
    }):start()
  end

  function this:exec(opts)
    exec(opts)
  end

  function this:try_shutdown()
    if L.progress then
      L.progress:close()
    end

    if L.job then
      L.job:shutdown(0x999)
    end
  end
end)

C.get = function(cb, ctx)
  if vim.__trouble.refresh_mode == ctx.opts.mode then
    C.source:new_cache(false)
  else
    cb(C.source:get_cache() or {})
  end
end

C.toggle = function()
  if C.source:is_attach() then
    t_api.close({ mode = C.source:mode() })
    return
  end

  C.source:new_cache(true)
end

-- stylua: ignore
C.init = function()
  C.config = {
    formatters = {
      todo_icon = function(ctx)
        return {
          text = TodoConfig.options.keywords[ctx.item.tag].icon,
          hl = "TodoFg" .. ctx.item.tag,
        }
      end,
    },
    modes = {
      todo = {
        auto_close = false,
        warn_no_results = false,
        open_no_results = true,
        events = {
          { event = "User", pattern = { "TroubleTodoCacheChanged" } },
        },
        sort = { { buf = 0 }, "filename", "pos" },
        source = "todo",
        groups = {
          { "filename", format = "{file_icon}{filename} {count}" },
        },
        format = "{todo_icon}{text} {pos}",
      },
    },
  }

  C.finder = Finder:new()

  C.source = SourceManager:new()

  local group = vim.__autocmd.augroup("trouble_todo")

  vim.__event.rg(etypes.CREATE_TROUBLE_LIST, function(event_info)
    if event_info.mode ~= C.source:mode() then
      return
    end

    if not group:empty() then
      return
    end

    group:on("BufWritePost", function(state)
      C.source:update_cache(state.buf)
    end)

    C.source:attach(event_info.view)
  end)

  vim.__event.rg(etypes.CLOSED_TROUBLE_LIST, function(event_info)
    if event_info.mode ~= C.source:mode() then
      return
    end

    group:reset()

    C.source:detach()
    C.finder:try_shutdown()
  end)

  return {
    config = C.config,
    get = C.get,
    toggle = C.toggle,
  }
end

return C.init()
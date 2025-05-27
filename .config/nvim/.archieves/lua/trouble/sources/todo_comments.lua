---@diagnostic disable: need-check-nil
---@diagnostic disable: unused-function
---@diagnostic disable: unused-label
---@diagnostic disable: unused-local

local TodoConfig    = require("todo-comments.config")
local TodoHighlight = require("todo-comments.highlight")

local Item = require("trouble.item")

local Finder = vim.__class.def(function(this)
  local m_runningjob
  local m_locked

  function this:exec(opts)
    this:stop()

    local path        = opts.path
    local on_data     = opts.on_data or function(_) end
    local on_exit     = opts.on_exit or function(_) end
    local on_start    = opts.on_start or function(_) end
    local on_err      = opts.on_err or function(_) end
    local on_shutdown = opts.on_shutdown or function(_) end

    local args = {}
    vim.list_extend(args, TodoConfig.options.search.args)
    vim.list_extend(args, { TodoConfig.search_regex(vim.__tbl.keys(TodoConfig.keywords)), path })

    vim.__job.new({
      command = TodoConfig.options.search.command,
      args = args,
      on_start = function(j)
        m_runningjob = j
        m_locked = true
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

        m_runningjob = nil
        m_locked = false
      end
    }):start()
  end

  function this:stop()
    vim.__logger.info("begin stop")

    if m_runningjob then
      vim.__logger.info("runningjob stop")
      m_runningjob:shutdown(0x999)
    end

    if m_locked then
      vim.__logger.info("m_locked stop")

      m_locked = false
    end
  end

  function this:islock()
    return m_locked
  end
end)

local SourceManager = vim.__class.def(function(this)
  local m_cache = {}
  local m_mode = "todo_comments"

  local m_finder = Finder:new()

  local function cvrt_2item(data)
    local file, lnum, col, line = data:match("^(.+):(%d+):(%d+):(.*)$")
    if not file then
      return
    end
    lnum = tonumber(lnum)
    col = tonumber(col)

    local _, _, kw = TodoHighlight.match(line)
    kw = TodoConfig.keywords[kw] or kw

    local item = Item.new({
      filename = file,
      pos = { lnum, col - 1 },
      end_pos = { lnum, col - 1 + #kw },
      source = m_mode,
      item = {
        keyword = kw,
        text = line,
      },
    })
    item.id = Item.generate_id(item)

    return item
  end

  function this:refresh()
    vim.__autocmd.exec("User", { pattern = "TroubleTodoCacheChanged" })
  end

  function this:mode()
    return m_mode
  end

  function this:get()
    return m_cache
  end

  function this:update(bufnr)
    if m_finder:islock() then
      return
    end
    if not vim.__trouble:find_view({ mode = m_mode }) then
      return
    end

    local filename = vim.__buf.name(bufnr)

    m_finder:exec({
      path = filename,
      on_exit = vim.schedule_wrap(function(datas)
        local items = {}
        for _, data in ipairs(datas) do
          table.insert(items, cvrt_2item(data))
        end

        vim.__tbl.remove_iter(m_cache, function(t, i, _)
          return t[i].filename ~= filename
        end)
        vim.__tbl.insert_arr(m_cache, items)

        this:refresh()
      end),
    })
  end

  function this:new()
    local path = vim.__path.cwd()

    local shutdowned = false
    local fetch_datas = {}

    m_finder:exec({
      path = path,
      on_start = function()
        vim.__logger.info("on_start")
        m_cache = {}
      end,
      on_data = function(data)
        table.insert(fetch_datas, data)

        if #fetch_datas > 15 then
          vim.schedule(function()
            vim.__logger.info("on_data limit")
            if not shutdowned then
              for _, data in ipairs(fetch_datas) do
                table.insert(m_cache, cvrt_2item(data))
              end
              fetch_datas = {}

              this:refresh()
            end
          end)
        end
      end,
      on_exit = vim.schedule_wrap(function()
        vim.__logger.info("on_exit")
        for _, data in ipairs(fetch_datas) do
          table.insert(m_cache, cvrt_2item(data))
        end

        this:refresh()
      end),
      on_err = function()
        vim.__logger.info("on_err")
        m_cache = {}
        shutdowned = true
      end,
      on_shutdown = function()
        vim.__logger.info("on_shutdown")
        m_cache = {}
        shutdowned = true
      end,
    })
  end

  function this:stop()
    m_finder:stop()
  end
end)

local source = SourceManager:new()

vim.__autocmd.on("User", function(state)
  local bufnr = state.data.bufnr
  if not vim.__trouble:find_view({ bufnr = bufnr, mode = source:mode() }) then
    return
  end
  vim.__logger.info("TroubleWinMount")
  source:new()
  require("trouble.api").close({ mode = "todo_comments" })
end, { pattern = "TroubleWinMount" })

vim.__autocmd.on("User", function(state)
  local bufnr = state.data.bufnr
  if not vim.__trouble:find_view({ bufnr = bufnr, mode = source:mode() }) then
    return
  end
  vim.__logger.info("TroubleWinClose")
  source:stop()
end, { pattern = "TroubleWinClose" })

return {
  config = {
    formatters = {
      todo_keyword = function(ctx)
        local keyword = ctx.item.keyword

        return {
          {
            text = TodoConfig.options.keywords[keyword].icon,
            hl = "TodoFg" .. ctx.item.keyword,
          },
          {
            text = " " .. keyword .. " ",
            hl = "TodoBg" .. ctx.item.keyword,
          }
        }
      end,
    },
    modes = {
      [source:mode()] = {
        auto_close = false,
        warn_no_results = false,
        open_no_results = true,
        icons = {
          indent = {
            top = "",
            middle = "",
            last = "",
            ws = "",
            fold_open = "",
            fold_closed = "",
          },
        },
        title = "{hl:TroubleTitle}Todo Comments",
        events = {
          { event = "User", pattern = { "TroubleTodoCacheChanged" } },
        },
        -- TODO: asdasd
        sort = { { buf = 0 }, "filename", "pos" },
        source = "todo_comments",
        format = "{todo_keyword} {file} {text:ts}",
      },
    },
  },
  get = function(cb, ctx)
    -- if vim.__trouble.refresh_mode == ctx.opts.mode then
    --   source:new()
    -- else
      cb(source:get() or {})
    -- end
  end
}

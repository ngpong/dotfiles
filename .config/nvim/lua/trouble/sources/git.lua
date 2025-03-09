local Item           = vim.__lazy.require("trouble.item")
local GitsignsGit    = vim.__lazy.require("gitsigns.git")
local GitsignsDiff   = vim.__lazy.require("gitsigns.diff")
local GitsignsCache  = vim.__lazy.require("gitsigns.cache")
local GitsignsAsync  = vim.__lazy.require("gitsigns.async")
local GitsignsAttach = vim.__lazy.require("gitsigns.attach")

local t_api = vim._plugins.trouble.api

local etypes = vim.__event.types

local C = {}

local SourceManager = vim.__class.def(function(this)
  local cache = {}

  function this:mode()
    return "git"
  end

  function this:desc()
    return "Git diffs"
  end

  function this:refresh()
    vim.__autocmd.exec("User", { pattern = "TroubleGitCacheChanged" })
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
    local filename = vim.__buf.name(bufnr)

    C.finder:exec({
      paths = { filename },
      on_exit = vim.__async.schedule_wrap(function(datas, cvrt)
        C.source:replace_cache(cvrt(datas), filename)
        C.source:refresh()
      end),
    })
  end

  function this:new_cache(need_open)
    local desc = this:desc()

    local open_or_refresh = function(need_ensure)
      if need_open then
        t_api.open(this:mode(), {
          ensure = need_ensure and this.refresh or nil,
          desc = desc,
        })
        need_open = false
      else
        this:refresh()
      end
    end

    C.finder:exec({
      on_shutdown = function()
        cache = {}
      end,
      on_start = function()
        cache = {}
      end,
      on_data = vim.__async.schedule_wrap(function(datas, cvrt)
        vim.__tbl.insert_arr(cache, cvrt(datas))
        open_or_refresh(true)
      end),
      on_exit = vim.__async.schedule_wrap(function(datas, _)
        if not next(datas) then
          open_or_refresh(false)
        end
      end),
    })
  end
end)

local Job = vim.__class.def(function(this)
  local is_shutdown = false

  local on_start, on_stdout, on_exit

  local path

  local sort_idx = 0

  local default_item = {
    added = {
      count = 1,
      lines = { "" },
      start = 1,
    },
    head = "@@ -0 +1,1 @@",
    removed = {
      count = 0,
      lines = {},
      start = 0,
    },
    type = "add",
    vend = 1,
  }

  local function results_2items(datas)
    datas = datas or {}

    local ret, r_size = {}, 0

    local wrap, size = {}, #datas
    for i = 1, size do
      local data = datas[i]

      sort_idx = sort_idx + 1

      local _head_item = {
        filename = data.filename,
        lnum = data.added.start,
        col = vim.v.maxcol,
        text = data.head,
        head_type = data.type,
        vend = data.vend,
        idx = sort_idx,
      }

      local head_item = Item.new({
        buf = vim.fn.bufadd(_head_item.filename),
        pos = { _head_item.lnum, 0 },
        end_pos = { _head_item.vend, _head_item.col },
        text = _head_item.text,
        filename = _head_item.filename,
        item = _head_item,
        source = "git",
      })

      wrap[1] = head_item
      Item.add_id(wrap)

      r_size = r_size + 1
      ret[r_size] = head_item

      if data.removed and data.removed.count > 0 then
        local texts, text_type = {}, "Delete"

        for j, text in ipairs(data.removed.lines) do
          texts[j] = "-" .. text
        end

        sort_idx = sort_idx + 1

        local _text_item = {
          filename = data.filename,
          lnum = data.added.start,
          col = vim.v.maxcol,
          text = table.concat(texts, "\n"),
          text_type = text_type,
          vend = data.vend,
          idx = sort_idx,
        }

        local text_item = Item.new({
          buf = vim.fn.bufadd(_text_item.filename),
          pos = { _text_item.lnum, 0 },
          end_pos = { _text_item.vend, _text_item.col },
          text = _text_item.text,
          filename = _text_item.filename,
          item = _text_item,
          source = "git",
        })

        wrap[1] = text_item
        Item.add_id(wrap)

        r_size = r_size + 1
        ret[r_size] = text_item
      end

      if data.added and data.added.count > 0 then
        local texts, text_type = {}, "Add"

        for j, text in ipairs(data.added.lines) do
          texts[j] = "+" .. text
        end

        sort_idx = sort_idx + 1

        local _text_item = {
          filename = data.filename,
          lnum = data.added.start,
          col = vim.v.maxcol,
          text = table.concat(texts, "\n"),
          text_type = text_type,
          vend = data.vend,
          idx = sort_idx,
        }

        local text_item = Item.new({
          buf = vim.fn.bufadd(_text_item.filename),
          pos = { _text_item.lnum, 0 },
          end_pos = { _text_item.vend, _text_item.col },
          text = _text_item.text,
          filename = _text_item.filename,
          item = _text_item,
          source = "git",
        })

        wrap[1] = text_item
        Item.add_id(wrap)

        r_size = r_size + 1
        ret[r_size] = text_item
      end
    end

    return ret
  end

  function this:__init(opts)
    path = opts.path or nil
    on_start = opts.on_start or function(_) end
    on_stdout = opts.on_stdout or function(_) end
    on_exit = opts.on_exit or function(_) end
  end

  function this:shutdown()
    is_shutdown = true
  end

  this.start = GitsignsAsync.create(1, function(_)
    GitsignsAsync.scheduler()

    on_start(this)

    local results, results_size = {}, 0

    local stage = 5

    local repo = GitsignsGit.Repo.get(vim.__path.cwd())

    local cmd_res = repo:command({ "status", "--porcelain", "--ignore-submodules", path }) -- async

    for _, line in ipairs(cmd_res) do
      local f = line:sub(4, -1)

      local f_abs = vim.__path.join(repo.toplevel, f)

      GitsignsAsync.scheduler()

      if vim.__fs.valid(f_abs) then
        local bufnr = vim.__buf.number(f_abs)
        if bufnr and GitsignsCache.cache[bufnr] then
          local cache = GitsignsCache.cache[bufnr]

          local hunks = vim.__util.copy(cache.hunks or {})
          local size  = #hunks
          for i = 1, size do
            if is_shutdown then
              return on_exit(this, {}, true, results_2items)
            end

            hunks[i].filename = f_abs
            results[results_size + 1] = hunks[i]
            results_size = results_size + 1

            if (results_size % stage) == 0 then
              GitsignsAsync.scheduler()
            end

            on_stdout(this, hunks[i], results_2items)
          end
        else
          local a = repo:get_show_text(":0:" .. f)

          local hunks = GitsignsDiff(a, vim.__fs.readlines(f_abs))
          if not next(hunks) then
            hunks[#hunks + 1] = vim.__util.copy(default_item)
          end

          for _, hunk in ipairs(hunks) do
            if is_shutdown then
              return on_exit(this, {}, true, results_2items)
            end

            hunk.filename = f_abs
            results[results_size + 1] = hunk
            results_size = results_size + 1

            if (results_size % stage) == 0 then
              GitsignsAsync.scheduler()
            end

            on_stdout(this, hunk, results_2items)
          end
        end
      end
    end

    GitsignsAsync.scheduler()

    on_exit(this, results, false, results_2items)
  end)
end)

local Finder = vim.__class.def(function(this)
  local L = {
    jobs = {},
    progress = nil,
  }

  local function fix_opts(opts)
    if (not opts.on_data) and (not opts.on_exit) then
      return false
    end

    if (not opts.chunk_size) or (opts.chunk_size <= 0) then
      opts.chunk_size = 15
    end

    opts.on_data = opts.on_data or function(_) end
    opts.on_exit = opts.on_exit or function(_) end
    opts.on_start = opts.on_start or function(_) end
    opts.on_shutdown = opts.on_shutdown or function(_) end

    return true
  end

  -- stylua: ignore
  local exec = GitsignsAsync.create(1, function(opts)
    if not fix_opts(opts) then
      return
    end

    local path        = opts.path
    local on_data     = opts.on_data
    local on_exit     = opts.on_exit
    local on_start    = opts.on_start
    local on_shutdown = opts.on_shutdown
    local chunk_size  = opts.chunk_size

    this:try_shutdown()

    local datas, index = {}, 1

    Job:new({
      path = path,
      on_start = function(j)
        L.progress = vim.__ui.Progresser:new {
          title = "trouble",
          ensure = 1,
          timeout = 500,
        }
        L.progress:start("Fetching " .. "[[" .. C.source:mode() .. "]]" .. " datas...")

        L.jobs[j] = true

        on_start()
      end,
      on_stdout = function(j, data, cvrt)
        if index > chunk_size then
          on_data(datas, cvrt)
          datas, index = {}, 1
        end

        datas[index] = data
        index = index + 1
      end,
      on_exit = function(j, results, is_shutdown, cvrt)
        repeat
          if is_shutdown then
            on_shutdown()
            break
          end

          if next(datas) then
            on_data(datas, cvrt)
          end

          on_exit(results, cvrt)
        until true

        L.progress:dismiss()
        L.jobs[j] = nil
      end
    }):start()
  end)

  function this:exec(opts)
    exec(opts)
  end

  function this:try_shutdown()
    if L.progress then
      local ws = L.progress:get_worker_stat()

      if ws < vim.__ui.ProgressWorkerState.CLOSED then
        L.progress:close()

        if ws < vim.__ui.ProgressWorkerState.STOPED then
          for job, _ in pairs(L.jobs) do
            job:shutdown()
          end
          L.jobs = {}
        end
      end
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
  local is_opened = t_api.is_open({ mode = C.source:mode() })
  if is_opened then
    t_api.close({ mode = C.source:mode() })
    return
  end

  C.source:new_cache(true)
end

-- stylua: ignore
C.init = function()
  C.config = {
    formatters = {
      git_text = function(ctx)
        local text, hl = "", ""

        if ctx.item.text_type then
          text = ctx.item.text
          hl = "Diff" .. ctx.item.text_type
        elseif ctx.item.head_type then
          text = vim.__icons["git_" .. ctx.item.head_type] .. vim.__icons.space .. ctx.item.text
          hl = "GitSigns" .. string.upper(string.sub(ctx.item.head_type, 1, 1)) .. string.sub(ctx.item.head_type, 2)
        end

        return {
          text = text,
          hl = hl,
        }
      end,
      git_head = function(ctx)
        local type = ctx.item.type

        local hl = "GitSigns" .. string.upper(string.sub(type, 1, 1)) .. string.sub(type, 2)
        local icon = vim.__icons["git_" .. type] .. vim.__icons.space .. ctx.item.head

        return {
          text = icon,
          hl = hl,
        }
      end,
    },
    modes = {
      git = {
        events = {
          { event = "User", pattern = { "TroubleGitCacheChanged" } },
        },
        auto_close = false,
        warn_no_results = false,
        open_no_results = true,
        source = "git",
        icons = {
          indent = {
            last = "  ",
            middle = "  ",
            top = "",
          },
        },
        sort = { { buf = 0 }, "filename", "idx" },
        format = "{git_text}",
        groups = {
          { "filename", format = "{file_icon}{filename} {count}" },
        },
      },
    },
  }

  C.finder = Finder:new()

  C.source = SourceManager:new()

  local group = vim.__autocmd.augroup("trouble_git")

  vim.__event.rg(etypes.CREATE_TROUBLE_LIST, function(event_info)
    if event_info.mode ~= C.source:mode() then
      return
    end

    if not group:empty() then
      return
    end

    group:on({ "BufWritePost" }, function(state)
      C.source:update_cache(state.buf)
    end)
  end)

  vim.__event.rg(etypes.CLOSED_TROUBLE_LIST, vim.__async.schedule_wrap(function(event_info)
    if event_info.mode ~= C.source:mode() then
      return
    end

    if t_api.is_open({ mode = C.source:mode() }) then
      return
    end

    group:reset()

    C.finder:try_shutdown()
  end))

  return {
    config = C.config,
    get = C.get,
    toggle = C.toggle,
    debug = function ()
      return C.source:get_cache()
    end
  }
end

return C.init()

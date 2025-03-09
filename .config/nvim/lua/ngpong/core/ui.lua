local ui = {}

local NuiPopup = vim.__lazy.require("nui.popup")
local NuiText  = vim.__lazy.require("nui.text")
local NuiLine  = vim.__lazy.require("nui.line")

vim.api.nvim_set_hl(0, "NuiFileInfoTail", { fg = vim.__color.dark4, italic = true })
vim.api.nvim_set_hl(0, "NuiFileInfoText", { fg = vim.__color.dark4, italic = true })
ui.popup_fileinfo = function(bufnr)
  bufnr = bufnr or vim.__buf.current()
  local path = vim.__buf.name(bufnr)

  local state = vim.__fs.state(path)
  if not state then
    vim.__notifier.err("Unable to get file state, bufnr [" .. bufnr .. "]")
    return
  end

  local texts = {
    NuiText(""),
    NuiText(string.format("%8s: %s", "Name", vim.__path.basename(path))),
    NuiText(string.format("%8s: %s", "Bufinfo", string.format("%s|%s(%s)", tostring(bufnr), tostring(vim.__win.current()), table.concat(vim.__win.ids(bufnr), ",")))),
    NuiText(string.format("%8s: %s", "Path", vim.__path.relpath(path, vim.__path.cwd()))),
    NuiText(string.format("%8s: %s", "Ws", vim.__path.cwd())),
    NuiText(string.format("%8s: %s", "Type", state.type)),
  }
  if state.size then
    table.insert(texts, NuiText(string.format("%8s: %s", "Size", vim.__fs.human_size(state.size, { output = "string" }))))
    table.insert(texts, NuiText(string.format("%8s: %s", "Created", os.date("%Y-%m-%d %I:%M %p", state.birthtime.sec))))
    table.insert(texts, NuiText(string.format("%8s: %s", "Modified", os.date("%Y-%m-%d %I:%M %p", state.mtime.sec))))
  end
  table.insert(texts, NuiText(""))
  table.insert(texts, NuiText(" Press q to close", "NuiFileInfoTail"))
  table.insert(texts, NuiText(""))

  local max_length = 0
  for _, text in ipairs(texts) do
    local length = text:length()

    if length > max_length then
      max_length = length
    end
  end

  local function open_popup()
    local win = NuiPopup({
      position = "50%",
      size = {
        width = max_length + 1,
        height = #texts,
      },
      zindex = 60,
      relative = "editor",
      border = {
        padding = { top = 0, bottom = 0, left = 0, right = 0, },
        style = vim.__icons.border.no,
        -- text = { top = NuiText(vim.__icons.space .. "File info" .. vim.__icons.space, "FloatTitle"), },
      },
      buf_options = {
        bufhidden = "wipe",
        buflisted = false,
        filetype = "fileinfo_popup",
      },
      win_options = {
        winblend = 0,
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
      },
    })
    win:mount()

    for i, text in ipairs(texts) do
      NuiLine({ text }):render(win.bufnr, -1, i)
    end

    return win
  end

  local success, win = pcall(open_popup)
  if success then
    vim.api.nvim_set_option_value("modifiable", false, { buf = win.bufnr })
    vim.api.nvim_set_option_value("readonly", true, { buf = win.bufnr })

    win:map("n", "q", function(...) -- bufnr
      win:unmount()
    end, { noremap = true })

    local event = require("nui.utils.autocmd").event
    win:on({ event.BufLeave, event.BufDelete, event.WinLeave }, vim.schedule_wrap(function()
      win:unmount()
    end), { once = true })

    vim.api.nvim_set_current_win(win.winid)
  else
    vim.__logger.error(win)
    win:unmount()
  end
end

-- ui.ProgressWorkerState = {
--   PENDING = 1,
--   RUNNING = 2,
--   STOPED = 3,
--   CLOSED = 4,
-- }

-- ui.Progresser = vim.__class.def(function(this)
--   local conf, L = {}, {}

--   local w_state = ui.ProgressWorkerState

--   local function format_display(msg, is_ended)
--     msg = msg or L.last_msg

--     local icon
--     if is_ended then
--       icon = conf.icon_ok
--     else
--       icon = conf.icon_pinner  [L.spinner]
--     end

--     return msg, icon
--   end

--   local need_ensure = function()
--     return conf.ensure > 0
--   end

--   local function notify(_msg, _opts)
--     local msg, icon = format_display(_msg, _opts.ended)

--     L.stat.cur = vim.__notifier(msg, conf.level, {
--       title = conf.title,
--       hide_from_history = true,
--       on_close = _opts.on_close,
--       replace = _opts.replace and L.stat.cur or nil,
--       icon = icon,
--       on_open = _opts.on_open,
--     })

--     vim.api.nvim__redraw({ win = L.stat.win, flush = true })

--     if msg then
--       L.last_msg = msg
--     end
--   end

--   -- stylua: ignore
--   local function process()
--     L.worker.ins:start(conf.period, conf.period, vim.__async.schedule_wrap(function()
--       if L.worker.stat ~= w_state.RUNNING then
--         return
--       end

--       local next_s = L.spinner + 1
--       if next_s > L.spinner_size then
--         L.spinner = 1
--         L.counter = L.counter + 1
--       else
--         L.spinner = (next_s == L.spinner_size and next_s or (next_s % L.spinner_size))
--       end

--       if need_ensure() and L.counter >= conf.ensure and L.dismiss_ensure then
--         return this:dismiss(L.dismiss_ensure.msg, true)
--       end

--       this:update()
--     end))
--   end

--   -- stylua: ignore
--   local function reset()
--     L.spinner        = 1
--     L.spinner_size   = #conf.icon_pinner  
--     L.counter        = 0
--     L.dismiss_ensure = nil
--     L.last_msg       = nil
--     if not L.worker then
--       L.worker = {}
--     end
--     L.worker.ins  = vim.loop.new_timer()
--     L.worker.stat = w_state.PENDING

--     L.stat = {
--       id = nil,
--       win = nil,
--     }
--   end

--   -- stylua: ignore
--   function this:__init(args)
--     conf.title         = args.title or nil
--     conf.timeout       = args.timeout or 500
--     conf.period        = args.period or 70
--     conf.level         = args.level or vim.log.levels.INFO
--     conf.ensure        = args.ensure or 1

--     local icon = args.icon or vim.__icons.spinner_frames_8
--     conf.icon_pinner   = icon.spinner
--     conf.icon_ok       = icon.ok

--     reset()
--   end

--   function this:get_worker_stat()
--     return L.worker.stat
--   end

--   function this:start(msg)
--     if L.worker.stat ~= w_state.PENDING then
--       return
--     end

--     notify(msg, {
--       on_close = function()
--         this:close()
--       end,
--       on_open = function(win)
--         L.stat.win = win
--         L.worker.stat = w_state.RUNNING
--       end,
--     })

--     if not L.stat.win then
--       return reset()
--     end

--     process()
--   end

--   function this:update(msg)
--     if L.worker.stat ~= w_state.RUNNING then
--       return
--     end

--     notify(msg, {
--       replace = true,
--     })
--   end

--   function this:dismiss(msg, ignore_ensure)
--     if L.worker.stat ~= w_state.RUNNING then
--       return
--     end

--     if not ignore_ensure and need_ensure() then
--       L.dismiss_ensure = { msg = msg }
--     else
--       notify(msg, {
--         replace = true,
--         ended = true,
--         timeout = conf.timeout,
--       })

--       L.worker.ins:stop()
--       L.worker.stat = w_state.STOPED
--     end
--   end

--   function this:close()
--     if not L.stat.win or L.worker.stat == w_state.CLOSED then
--       return
--     end

--     vim.__win.close(L.stat.win)

--     L.worker.ins:close()
--     L.worker.stat = w_state.CLOSED
--   end
-- end)

ui.input = function(opts, cb)
  local prompt = opts.prompt or ""
  local default = opts.default or ""
  local relative = opts.relative

  local wrap_call = function(f, ...)
    f(...)
  end

  if relative then
    wrap_call = function(f, ...)
      local src = vim.__util.copy(require("dressing.config"))
      local new = vim.__tbl.rr_extend(src, { input = { relative = relative } })

      require("dressing.config").update(new)

      f(...)

      require("dressing.config").update(src)
    end
  end

  wrap_call(vim.ui.input, { prompt = prompt, default = default }, function(res)
    cb(res)
  end)
end

return ui

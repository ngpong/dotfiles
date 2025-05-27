return {
  "folke/snacks.nvim",
  optional = true,
  commands = {
    {
      "Notification",
      function(_)
        require("snacks").picker.notifications()
      end,
    }
  },
  dispatchs = {
    {
      "notifier",
      function(this0)
        local notifier = setmetatable({}, {
          __call = function(t, msg, level, opts)
            opts = opts or {}
            return require("snacks.notifier").notify(msg, level, opts)
          end,
        })

        function this0:info(msg, opts)
          return notifier(msg, vim.log.levels.INFO, opts)
        end
        function this0:err(msg, opts)
          return notifier(msg, vim.log.levels.ERROR, opts)
        end
        function this0:warn(msg, opts)
          return notifier(msg, vim.log.levels.WARN, opts)
        end
        function this0:trace(msg, opts)
          return notifier(msg, vim.log.levels.TRACE, opts)
        end
        function this0:debug(msg, opts)
          return notifier(msg, vim.log.levels.DEBUG, opts)
        end
        function this0:close(id)
          return require("snacks.notifier").hide(id)
        end

        local running_progresser = {}
        this0.progresser = vim.__class.def(function(this1)
          local conf = {}
          local rt = {}

          function this1:__init(args)
            assert(args)
            conf.title  = args.title or nil
            conf.period = args.period or 70
            conf.level  = args.level or vim.log.levels.INFO
            conf.icons  = args.icons or vim.__icons.spinner_frames_8

            if args.msg then
              conf.start_msg = args.msg[1] or ""
              conf.ended_msg = args.msg[2]
            end

            rt.id = string.format("%s:%s", tostring(vim.loop.hrtime()), tostring(vim.__util.rand()))
            rt.spinner_idx  = 1
            rt.spinner_size = #conf.icons.spinner
          end

          function this1:start()
            if running_progresser[rt.id] then
              return
            end
            running_progresser[rt.id] = true

            notifier(conf.start_msg, conf.level, {
              id = rt.id,
              title = conf.title,
              icon = conf.icons.spinner[rt.spinner_idx]
            })

            ---@diagnostic disable: need-check-nil
            local timer = vim.loop.new_timer()
            timer:start(conf.period, conf.period, vim.__async.schedule_wrap(function()
              if not running_progresser[rt.id] then
                timer:stop()
                timer:close()
                return
              end

              local next_s = rt.spinner_idx + 1
              if next_s > rt.spinner_size then
                rt.spinner_idx = 1
              else
                rt.spinner_idx = (next_s == rt.spinner_size and next_s or (next_s % rt.spinner_size))
              end

              notifier(conf.start_msg, conf.level, {
                id = rt.id,
                title = conf.title,
                icon = conf.icons.spinner[rt.spinner_idx]
              })
            end))
          end

          function this1:complete(force)
            running_progresser[rt.id] = nil

            if not force then
              notifier(conf.ended_msg or conf.start_msg, conf.level, {
                id = rt.id,
                title = conf.title,
                icon = conf.icons.ok,
                timeout = 2000
              })
            else
              this0:close(rt.id)
            end
          end
        end)
      end
    }
  },
  opts = {
    notifier = {
      enabled = true,
      timeout = 3500,
      width = { min = 40, max = 0.99 },
      height = { min = 1 },
      margin = { top = 1, right = 1, bottom = 0 },
      padding = true,
      sort = { "level", "added" },
      level = vim.log.levels.TRACE, -- minimum log level to display. TRACE is the lowest. all notifications are stored in history
      icons = {
        error = vim.__icons.diagnostic_error,
        warn = vim.__icons.diagnostic_warn,
        info = vim.__icons.diagnostic_info,
        debug = vim.__icons.debugger,
        trace = vim.__icons.pen,
      },
      keep = function(notif) -- global keep
        -- return vim.fn.getcmdpos() > 0
        return false
      end,
      style = "compact",
      top_down = true, -- false bottom
      date_format = "%R",
      more_format = " ↓ %d lines ",
      refresh = 50, -- refresh at most every 50ms
    },
    styles = {
      notification = {
        zindex = 1,
        ft = "markdown",
        wo = {
          winblend = 20,
          wrap = false,
          conceallevel = 2,
          colorcolumn = "",
        },
        bo = { filetype = "notify" },
      },
      notification_history = {
        border = vim.__icons.border.no,
        width = 0.8,
        height = 0.60,
        backdrop = false,
        minimal = false,
        ft = "markdown",
        bo = {
          filetype = "notify_history",
          modifiable = false
        },
        wo = {
          winhighlight = "Normal:NormalFloat,EndOfBuffer:FloatEndOfBuffer,FloatTitle:FloatTitle",
          statuscolumn = "",
          signcolumn = "no",
          wrap = true,
          cursorline = false,
          number = false,
          relativenumber = false,
          numberwidth = 1
        },
        keys = { q = "close" },
      },
    }
  }
}

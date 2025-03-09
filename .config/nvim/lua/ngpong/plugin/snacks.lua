return {
  "folke/snacks.nvim",
  lazy = false,
  opts = function()
    local notifier = setmetatable({}, {
      __call = function(t, msg, level, opts)
        opts = opts or {}
        return require("snacks.notifier").notify(msg, level, opts)
      end,
    })
    vim.__notifier = notifier

    function notifier.info(msg, opts)
      return notifier(msg, vim.log.levels.INFO, opts)
    end
    function notifier.err(msg, opts)
      return notifier(msg, vim.log.levels.ERROR, opts)
    end
    function notifier.warn(msg, opts)
      return notifier(msg, vim.log.levels.WARN, opts)
    end
    function notifier.close(id)
      return require("snacks.notifier").hide(id)
    end

    local running_progresser = {}
    notifier.progresser = vim.__class.def(function(this)
      local conf = {}
      local rt = {}

      function this:__init(args)
        conf.title  = args.title or nil
        conf.period = args.period or 70
        conf.level  = args.level or vim.log.levels.INFO
        conf.icons  = args.icons or vim.__icons.spinner_frames_8
        conf.id     = "Progress:" .. (args.id or tostring(vim.loop.hrtime()))
        conf.msg    = args.msg or { [1] = "", [2] = "" }

        rt.spinner_idx  = 1
        rt.spinner_size = #conf.icons.spinner
      end

      function this:start()
        if running_progresser[conf.id] then
          return
        end
        running_progresser[conf.id] = true

        notifier(conf.msg[1], conf.level, {
          id = conf.id,
          title = conf.title,
          icon = conf.icons.spinner[rt.spinner_idx]
        })

        local timer = vim.loop.new_timer()
        timer:start(conf.period, conf.period, vim.__async.schedule_wrap(function()
          if not running_progresser[conf.id] then
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

          notifier(conf.msg[1], conf.level, {
            id = conf.id,
            title = conf.title,
            icon = conf.icons.spinner[rt.spinner_idx]
          })
        end))
      end

      function this:complete(force)
        running_progresser[conf.id] = nil

        if not force and conf.msg[2] then
          notifier(conf.msg[2], conf.level, {
            id = conf.id,
            title = conf.title,
            icon = conf.icons.ok,
            timeout = 2000
          })
        else
          notifier.close(conf.id)
        end
      end
    end)

    vim.api.nvim_create_user_command(
      "Notification",
      function(_)
        require("snacks").notifier.show_history()
      end,
      {}
    )
  end
}
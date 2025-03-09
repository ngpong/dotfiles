-- return {
--   "rcarriga/nvim-notify",
--   lazy = true,
--   init = function()
--     vim.opt.termguicolors = true
--     vim.notify = vim.__lazy.require("notify")
--   end,
--   opts = {
--     timeout = 500,
--     max_width = nil,
--     max_height = nil,
--     stages = "fade_in_slide_out", -- fade_in_slide_out, fade, slide, static
--     render = "default", -- default, minimal, simple, compact
--     background_colour = vim.__color.dark0_soft,
--     on_open = function(win, opts)
--       vim.api.nvim_win_set_config(win, { zindex = 175 })

--       -- We need to wait for the LazyFile event to be emitted
--       if not vim.__plugin.loaded("nvim-treesitter") then
--         return
--       end

--       vim.wo[win].spell = false
--       vim.wo[win].conceallevel = 3

--       local buf = vim.__win.bufnr(win)
--       vim.treesitter.start(buf, "markdown")
--       vim.bo[buf].syntax = "markdown"
--     end,
--     on_close = nil,
--     minimum_width = 40,
--     fps = (vim.g.neovide and 100 or 60),
--     top_down = true,
--     time_formats = {
--       notification_history = "%FT%X",
--       notification = "%X",
--     },
--     icons = {
--       ERROR = vim.__icons.diagnostic_err,
--       WARN = vim.__icons.diagnostic_warn,
--       INFO = vim.__icons.diagnostic_info,
--       DEBUG = vim.__icons.debugger,
--       TRACE = vim.__icons.pen,
--     },
--   }
-- }

return {
  "folke/snacks.nvim",
  optional = true,
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
        error = vim.__icons.diagnostic_err,
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
        border = "rounded",
        zindex = 100,
        ft = "markdown",
        wo = {
          winblend = 0,
          wrap = false,
          conceallevel = 2,
          colorcolumn = "",
        },
        bo = { filetype = "notify" },
      },
      ["notification.history"] = {
        border = "rounded",
        zindex = 100,
        width = 0.82,
        height = 0.85,
        backdrop = false,
        minimal = false,
        title = " Notification History ",
        title_pos = "center",
        ft = "markdown",
        bo = { filetype = "notify_history", modifiable = false },
        -- 1. FloatTitle|FloatFooter|FloatBorder|NormalNC|Normal:
        -- 2. SnacksNotifierHistoryTitle
        -- wo = { winhighlight = "Normal:SnacksNotifierHistory" },
        keys = { q = "close" },
      },
    }
  }
}
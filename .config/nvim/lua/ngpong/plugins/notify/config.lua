local M = {}

local Icons  = require('ngpong.utils.icon')
local Lazy   = require('ngpong.utils.lazy')
local Notify = Lazy.require('notify')

M.setup = function()
  Notify.setup {
    -- level = vim.log.levels.INFO,
    timeout = 4000,
    max_width = nil,
    max_height = nil,
    stages = (Helper.is_neovide() and 'fade' or 'static'), -- fade_in_slide_out, fade, slide, static
    render = 'default', -- default, minimal, simple, compact
    background_colour = 'NotifyBackground',
    on_open = function(win, opts)
      vim.api.nvim_win_set_config(win, { zindex = 175 })

      -- We need to wait for the VeryLazyFile event to be emitted
      if not Plgs.is_loaded('nvim-treesitter') then
        return
      end

      vim.wo[win].spell = false
      vim.wo[win].conceallevel = 3

      local buf = vim.api.nvim_win_get_buf(win)
      if not pcall(vim.treesitter.start, buf, 'markdown') then
        vim.bo[buf].syntax = 'markdown'
      end
    end,
    on_close = nil,
    minimum_width = 50,
    fps = 30,
    top_down = true,
    time_formats = {
      notification_history = '%FT%X',
      notification = '%X',
    },
    icons = {
      ERROR = Icons.diagnostic_err,
      WARN = Icons.diagnostic_warn,
      INFO = Icons.diagnostic_info,
      DEBUG = Icons.debugger,
      TRACE = Icons.pen,
    },
  }
end

return M

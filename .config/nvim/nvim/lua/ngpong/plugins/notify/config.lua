local M = {}

local icons  = require('ngpong.utils.icon')
local lazy   = require('ngpong.utils.lazy')
local notify = lazy.require('notify')

M.setup = function()
  notify.setup {
    -- level = vim.log.levels.INFO,
    timeout = 4000,
    max_width = nil,
    max_height = nil,
    stages = (HELPER.is_neovide() and 'fade' or 'static'), -- fade_in_slide_out, fade, slide, static
    render = 'default', -- default, minimal, simple, compact
    background_colour = 'NotifyBackground',
    on_open = function(win, opts)
      vim.api.nvim_win_set_config(win, { zindex = 175 })

      -- We need to wait for the VeryLazyFile event to be emitted
      if not PLGS.is_loaded('nvim-treesitter') then
        return
      end

      vim.wo[win].conceallevel = 3

      local buf = vim.api.nvim_win_get_buf(win)
      if not pcall(vim.treesitter.start, buf, 'markdown') then
        vim.bo[buf].syntax = 'markdown'
      end

      vim.wo[win].spell = false
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
      ERROR = icons.diagnostic_err,
      WARN = icons.diagnostic_warn,
      INFO = icons.diagnostic_info,
      DEBUG = icons.debugger,
      TRACE = icons.pen,
    },
  }
end

return M
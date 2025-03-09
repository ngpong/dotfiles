local M = {}

M.setup = function()
  require("notify").setup {
    timeout = 500,
    max_width = nil,
    max_height = nil,
    stages = "fade_in_slide_out", -- fade_in_slide_out, fade, slide, static
    render = "default", -- default, minimal, simple, compact
    background_colour = "NotifyBackground",
    on_open = function(win, opts)
      vim.api.nvim_win_set_config(win, { zindex = 175 })

      -- We need to wait for the LazyFile event to be emitted
      if not vim.__plugin.loaded("nvim-treesitter") then
        return
      end

      vim.wo[win].spell = false
      vim.wo[win].conceallevel = 3

      local buf = vim.__win.bufnr(win)
      if not pcall(vim.treesitter.start, buf, "markdown") then
        vim.bo[buf].syntax = "markdown"
      end
    end,
    on_close = nil,
    minimum_width = 40,
    fps = (vim.g.neovide and 100 or 60),
    top_down = true,
    time_formats = {
      notification_history = "%FT%X",
      notification = "%X",
    },
    icons = {
      ERROR = vim.__icons.diagnostic_err,
      WARN = vim.__icons.diagnostic_warn,
      INFO = vim.__icons.diagnostic_info,
      DEBUG = vim.__icons.debugger,
      TRACE = vim.__icons.pen,
    },
  }
end

return M

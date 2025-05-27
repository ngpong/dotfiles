-- NOTE:
--
-- 参考 nvchad 的 nui 部分，但是要注意几点
--  * nvchad 没有 scroll 功能
--  * nvchad 与 barbar 在更新 tabline 的事件上有差异，不太清楚 nvchad 的实现是否有 bug
--  * nvchad 的 tab 管理方案是非常不错的
--
-- 为什么要自己实现？
--  * 原先配置中有太多的自定义内容，以更好的和这些自定义内容做融合
--  * 目前看 barbar 的实现其实还有很多优化的空间，比如尽可能的使用缓存减少运算

return {
  "romgrk/barbar.nvim",
  main = "barbar",
  lazy = false,
  dispatchs = {
    {
      "barbar",
      function(this)
        local function filter()
          local winid = vim.__win.current()
          if vim.__win.is_diff(winid) then
            return false
          end
          if vim.__win.is_float(winid) then
            return false
          end

          local ft = vim.__buf.filetype(0)
          if vim.__filter.contain_fts(ft) then
            return false
          end

          return true
        end

        function this:next()
          if not filter() then return end
          vim.cmd("BufferNext")
        end

        function this:previous()
          if not filter() then return end
          vim.cmd("BufferPrevious")
        end

        function this:move_next()
          if not filter() then return end
          vim.cmd("BufferMoveNext")
        end

        function this:move_previous()
          if not filter() then return end
          vim.cmd("BufferMovePrevious")
        end

        function this:pin()
          if not filter() then return end
          vim.cmd("BufferPin")
        end

        function this:pick()
          if not filter() then return end
          vim.cmd("BufferPick")
        end

        function this:restore()
          if not filter() then return end
          vim.cmd("BufferRestore")
        end

        function this:delete()
          if not filter() then return end

          local BarbarState = vim.__lazy.require("barbar.state")
          local BarbarBbye  = vim.__lazy.require("barbar.bbye")

          local bufnr = vim.__buf.current()

          if vim.bo[bufnr].modified then
            return vim.__echo.warn("No write since last change.")
          end

          if BarbarState.is_pinned(bufnr) then
            return vim.__echo.warn("Can't not close pinned buffer.")
          end

          BarbarBbye.bdelete(false, bufnr)
        end

        function this:delete_all()
          if not filter() then return end

          local BarbarState = vim.__lazy.require("barbar.state")
          local BarbarBbye  = vim.__lazy.require("barbar.bbye")

          vim.ui.input({ prompt = "Delete all buffers, y/N: ", }, function(ip)
            if not ip or string.lower(ip) ~= "y" then
              return
            end

            for _, bufnr in ipairs(BarbarState.buffers) do
              local is_pinned   = BarbarState.is_pinned(bufnr)
              local is_modified = vim.bo[bufnr].modified

              if not is_modified and not is_pinned then
                BarbarBbye.bdelete(false, bufnr)
              end
            end
          end)
        end

        function this:delete_except()
          if not filter() then return end

          local BarbarState = vim.__lazy.require("barbar.state")
          local BarbarBbye  = vim.__lazy.require("barbar.bbye")

          vim.ui.input({ prompt = "Delete all buffers except current, y/N: ", }, function(ip)
            if not ip or string.lower(ip) ~= "y" then
              return
            end

            local curbufnr = vim.__buf.current()
            for _, bufnr in ipairs(BarbarState.buffers) do
              local is_current  = curbufnr == bufnr
              local is_pinned   = BarbarState.is_pinned(bufnr)
              local is_modified = vim.bo[bufnr].modified

              if not is_modified and not is_pinned and not is_current then
                BarbarBbye.bdelete(false, bufnr)
              end
            end
          end)
        end
      end
    }
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  keys = {
    -- { "]b", buffer_next },
    -- { "[b", buffer_previous },
    { "<C-.>", function() vim.__barbar:next() end },
    { "<C-,>", function() vim.__barbar:previous() end },
    { "<C->>", function() vim.__barbar:move_next() end },
    { "<C-<>", function() vim.__barbar:move_previous() end },
    { "<C-b>p", function() vim.__barbar:pin() end },
    { "<C-b><C-p>", function() vim.__barbar:pin() end },
    { "<C-b>g", function() vim.__barbar:pick() end },
    { "<C-b><C-g>", function() vim.__barbar:pick() end },
    { "<C-b>r", function() vim.__barbar:restore() end },
    { "<C-b><C-r>", function() vim.__barbar:restore() end },
    { "<C-b>d", function() vim.__barbar:delete() end },
    { "<C-b><C-d>", function() vim.__barbar:delete() end },
    { "<C-b>o", function() vim.__barbar:delete_except() end },
    { "<C-b><C-o>", function() vim.__barbar:delete_except() end },
  },
  highlights = {
    { "BufferTabpageFill", bg = vim.__color.dark0, fg = vim.__color.light1 },
    { "BufferTabpages", bg = vim.__color.bright_yellow, fg = vim.__color.bright_yellow },
    { "BufferTabpagesSep", bg = vim.__color.bright_yellow, fg = vim.__color.bright_yellow },

    { "BufferScrollArrow", bg = vim.__color.dark0, fg = vim.__color.bright_red },
    { "BufferOffset", bg = vim.__color.dark0_hard, fg = vim.__color.light2, bold = true, italic = true },

    { "BufferCurrent", bg = vim.__color.dark1, fg = vim.__color.light1 },
    { "BufferCurrentBtn", bg = vim.__color.dark1, fg = vim.__color.light4  },
    -- { "BufferCurrentIndex", bg = vim.__color.dark1, fg = vim.__color.bright_blue },
    -- { "BufferCurrentNumber", bg = vim.__color.dark1, fg = vim.__color.bright_blue },
    { "BufferCurrentPin", bg = vim.__color.dark1, fg = vim.__color.light1, bold = true },
    { "BufferCurrentPinBtn", bg = vim.__color.dark1, fg = vim.__color.bright_red },
    { "BufferCurrentMod", bg = vim.__color.dark1, fg = vim.__color.light1 },
    { "BufferCurrentModBtn", bg = vim.__color.dark1, fg = vim.__color.bright_yellow },
    { "BufferCurrentSignRight", bg = vim.__color.dark1, fg = vim.__color.dark0 },
    { "BufferCurrentTarget", bg = vim.__color.dark1, fg = vim.__color.bright_red },

    { "BufferInactive", bg = vim.__color.dark0, fg = vim.__color.light2 },
    { "BufferInactiveBtn", bg = vim.__color.dark0, fg = vim.__color.light4  },
    -- { "BufferInactiveIndex", bg = vim.__color.dark0, fg = vim.__color.bright_blue },
    -- { "BufferInactiveNumber", bg = vim.__color.dark0, fg = vim.__color.bright_blue },
    { "BufferInactivePin", bg = vim.__color.dark0, fg = vim.__color.light2, bold = true },
    { "BufferInactivePinBtn", bg = vim.__color.dark0, fg = vim.__color.bright_red },
    { "BufferInactiveMod", bg = vim.__color.dark0, fg = vim.__color.light2 },
    { "BufferInactiveModBtn", bg = vim.__color.dark0, fg = vim.__color.bright_yellow },
    { "BufferInactiveSignRight", bg = vim.__color.dark0, fg = vim.__color.dark0 },
    { "BufferInactiveTarget", bg = vim.__color.dark0, fg = vim.__color.bright_red },
  },
  opts = {
    animation = false,
    auto_hide = false,
    tabpages = true,
    clickable = true,
    exclude_ft = vim.__filter.filetypes[1],
    exclude_name = {},
    focus_on_close = "previous", -- "left", "previous", "right"
    hide = {
      extensions = false,
      inactive = false,
      alternate = false,
      current = false,
      visible = true
    },
    highlight_alternate = false,
    highlight_visible = false,
    highlight_inactive_file_icons = true,
    icons = {
      diagnostics = {
        [vim.diagnostic.severity.ERROR] = { enabled = false, icon = "" },
        [vim.diagnostic.severity.WARN] = { enabled = false, icon = "" },
        [vim.diagnostic.severity.INFO] = { enabled = false, icon = "" },
        [vim.diagnostic.severity.HINT] = { enabled = false, icon = "" },
      },
      gitsigns = {
        added = { enabled = false, icon = "" },
        changed = { enabled = false, icon = "" },
        deleted = { enabled = false, icon = "" },
      },
      filetype = {
        custom_colors = false,
        enabled = true,
      },
      buffer_index = false,
      buffer_number = false,
      button = "",
      separator = { left = "", right = "" },
      separator_at_end = true,
      preset = "default", -- "powerline", "slanted"
      scroll = { left = "❮", right = "❯" },

      -- alternate = { filetype = { enabled = false } },
      -- current = { buffer_index = false, modified = { buffer_number = false } },
      -- visible = { modified = {buffer_number = false} },
      pinned = { button = vim.__icons.pinned_2, filename = true },
      modified = { button = "●" },
      current = { separator = { left = "", right = "▕" } },
      inactive = { separator = { left = "", right = "▕" } },
    },
    insert_at_end = false,
    insert_at_start = false,
    maximum_padding = 1,
    minimum_padding = 1,
    maximum_length = 999,
    minimum_length = 0,
    semantic_letters = true,
    letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",
    sidebar_filetypes = {
      NvimTree = {
        text = "Explorer",
        align = "left",
        event = "BufWinLeave"
      },
    },
    no_name_title = "[No Name]",
    sort = {
      ignore_case = true,
    }
  },
  hackers = {
    before = {
      function(opts)
        require("barbar.utils").notify = function(msg, level)
          if msg == "Couldn't find buffer" then return end
          vim.notify(msg, level, { title = "SYSTEM" })
        end
      end,
      function(opts)
        require("barbar.utils").notify_once = function(msg, level)
          vim.notify_once(msg, level, { title = "SYSTEM" })
        end
      end,
    },
    after = {
      function(opts)
        for _, ac in ipairs(vim.api.nvim_get_autocmds({ group = "barbar_render" })) do
          if
            ac.event == "DiagnosticChanged" or
            ac.pattern == "GitSignsUpdate"
          then
            vim.api.nvim_del_autocmd(ac.id)
          end
        end
      end,
    }
  }
}

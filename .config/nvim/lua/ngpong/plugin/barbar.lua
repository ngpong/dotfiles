local function action_filter()
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

local function action_wrap(f)
  if type(f) == "string" then
    return function()
      if not action_filter() then
        return
      end

      vim.cmd(f)
    end
  else
    return function()
      if not action_filter() then
        return
      end

      f()
    end
  end
end

return {
  "romgrk/barbar.nvim",
  lazy = false,
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  highlights = {
    { "BufferTabpageFill", bg = vim.__color.dark0, fg = vim.__color.light1 },
    { "BufferTabpages", bg = vim.__color.bright_yellow, fg = vim.__color.bright_yellow },
    { "BufferTabpagesSep", bg = vim.__color.bright_yellow, fg = vim.__color.bright_yellow },

    { "BufferScrollArrow", bg = vim.__color.dark0, fg = vim.__color.bright_red },
    { "BufferOffset", bg = vim.__color.dark0_hard, fg = vim.__color.light1, bold = true, italic = true },

    { "BufferCurrent", bg = vim.__color.dark1, fg = vim.__color.light1 },
    { "BufferCurrentBtn", bg = vim.__color.dark1, fg = vim.__color.light4  },
    -- { "BufferCurrentIndex", bg = vim.__color.dark1, fg = vim.__color.bright_blue },
    -- { "BufferCurrentNumber", bg = vim.__color.dark1, fg = vim.__color.bright_blue },
    { "BufferCurrentPin", bg = vim.__color.dark1, fg = vim.__color.light1, bold = true },
    { "BufferCurrentPinBtn", bg = vim.__color.dark1, fg = vim.__color.bright_red },
    { "BufferCurrentMod", bg = vim.__color.dark1, fg = vim.__color.light1 },
    { "BufferCurrentModBtn", bg = vim.__color.dark1, fg = vim.__color.bright_yellow },
    { "BufferCurrentSignRight", bg = vim.__color.dark1, fg = vim.__color.dark0_hard },
    { "BufferCurrentTarget", bg = vim.__color.dark1, fg = vim.__color.bright_red },

    { "BufferInactive", bg = vim.__color.dark0, fg = vim.__color.light2 },
    { "BufferInactiveBtn", bg = vim.__color.dark0, fg = vim.__color.light4  },
    -- { "BufferInactiveIndex", bg = vim.__color.dark0, fg = vim.__color.bright_blue },
    -- { "BufferInactiveNumber", bg = vim.__color.dark0, fg = vim.__color.bright_blue },
    { "BufferInactivePin", bg = vim.__color.dark0, fg = vim.__color.light2, bold = true },
    { "BufferInactivePinBtn", bg = vim.__color.dark0, fg = vim.__color.bright_red },
    { "BufferInactiveMod", bg = vim.__color.dark0, fg = vim.__color.light2 },
    { "BufferInactiveModBtn", bg = vim.__color.dark0, fg = vim.__color.bright_yellow },
    { "BufferInactiveSignRight", bg = vim.__color.dark0, fg = vim.__color.dark0_hard },
    { "BufferInactiveTarget", bg = vim.__color.dark0, fg = vim.__color.bright_red },
  },
  keys = {
    { "]b"   , action_wrap("BufferNext") },
    { "[b"   , action_wrap("BufferPrevious") },
    { "]B"   , action_wrap("BufferMoveNext") },
    { "[B"   , action_wrap("BufferMovePrevious") },
    { "<A-.>", action_wrap("BufferNext") },
    { "<A-,>", action_wrap("BufferPrevious")  },
    { "<A->>", action_wrap("BufferMoveNext") },
    { "<A-<>", action_wrap("BufferMovePrevious") },
    { "`p"   , action_wrap("BufferPin") },
    { "`s"   , action_wrap("BufferPick") },
    { "`r"   , action_wrap("BufferRestore") },
    { "`d"   , action_wrap(function()
      local BarbarState = vim.__lazy.require("barbar.state")
      local BarbarBbye  = vim.__lazy.require("barbar.bbye")  

      local bufnr = vim.__buf.current()

      if vim.bo[bufnr].modified then
        return vim.__notifier.warn("No write since last change.")
      end

      if not BarbarState.is_pinned(bufnr) then
        BarbarBbye.bdelete(false, bufnr)
      end
    end) },
    { "`o"   , action_wrap(function()
      local BarbarState = vim.__lazy.require("barbar.state")
      local BarbarBbye  = vim.__lazy.require("barbar.bbye")

      vim.__ui.input({ prompt = "This operation will delete all buffers except current, yes(y) or no(n,...)?", relative = "editor" }, function(res)
        if res ~= "y" then
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
    end) },
    {
      "<leader>bb",
      function()
        vim.__util.wrap_f(t_api.toggle, "buffers")
      end
    },
  },
  opts = {
    animation = false,
    auto_hide = false,
    tabpages = true,
    clickable = true,
    exclude_ft = vim.__filter.filetypes[2],
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
  config = function(_, opts)
    -- HACK:
    require("barbar.utils").notify = function(msg, level)
      if msg == "Couldn't find buffer" then return end
      vim.notify(msg, level, { title = "SYSTEM" })
    end
    require("barbar.utils").notify_once = function(msg, level)
      vim.notify_once(msg, level, { title = "SYSTEM" })
    end

    require("barbar").setup(opts)
  end
}
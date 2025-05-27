local M = {}

M.setup = function()
  require("bufferline").setup({
    options = {
      mode = "buffers",
      show_buffer_close_icons = false,
      show_close_icon = false,
      separator_style = "slant", --{"█", "█"},
      -- numbers = function(opts)
      --   return string.format("%s·%s", opts.ordinal, opts.lower(opts.id))
      -- end,
      numbers = nil,
      left_trunc_marker = vim.__icons.arrow_left_1,
      right_trunc_marker = vim.__icons.arrow_right_2,
      indicator = {
        -- icon = "▎",
        style = "underline",
      },
      sort_by = "none", -- "insert_at_end", "insert_after_current"
      persist_buffer_sort = false, -- bufferline.session 已经实现了这个功能了
      tab_size = 12,
      show_tab_indicators = true,
      max_name_length = 99,
      enforce_regular_tabs = false, -- 标签长度是否保持一致
      diagnostics = false,
      diagnostics_update_in_insert = false,
      diagnostics_indicator = nil,
      -- stylua: ignore
      close_command = function(n) vim.__buf.del(n) end,
      -- stylua: ignore
      right_mouse_command = function(n) vim.__buf.del(n) end,
      offsets = {
        {
          filetype = "NvimTree",
          text = vim.__icons.files_1 .. vim.__icons.space .. "EXPLORER [" .. string.upper(vim.__path.cwd()) .. "]",
          text_align = "center",
          padding = 0,
          separator = "|",
        },
      },
      groups = {
        items = {
          require("bufferline.groups").builtin.pinned:with({ icon = vim.__icons.pinned_3 }),
        },
      },
      custom_filter = function(bufnr, _)
        return not vim.__filter.contain_fts(vim.__buf.filetype(bufnr))
      end
      -- style_preset = {
      --   buffline.style_preset.no_italic,
      --   buffline.style_preset.no_bold
      -- },
    },
    highlights = {
      offset_separator = {
        bg = vim.__color.dark0_soft,
      },
      indicator_visible = {
        fg = vim.__color.bright_red,
        bg = vim.__color.dark0_soft,
      },
      indicator_selected = {
        fg = vim.__color.bright_red,
        sp = vim.__color.bright_red,
        bg = vim.__color.dark0_soft,
      },
      duplicate_selected = {
        sp = vim.__color.bright_red,
        italic = true,
      },
      buffer_selected = {
        sp = vim.__color.bright_red,
        italic = true,
      },
      separator_selected = {
        sp = vim.__color.bright_red,
      },
      modified_selected = {
        sp = vim.__color.bright_red,
      },
      -- fill = {
      --   fg = vim.__color.dark1,
      --   bg = vim.__color.dark1,
      -- },
    },
  })
end

return M

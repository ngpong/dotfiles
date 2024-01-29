local M = {}

local icons = require('ngpong.utils.icon')

local this   = PLGS.bufferline
local colors = PLGS.colorscheme.colors

M.setup = function()
  require('bufferline').setup({
    options = {
      mode = 'buffers',
      show_buffer_close_icons = false,
      show_close_icon = false,
      separator_style = 'slant', --{'█', '█'},
      -- numbers = function(opts)
      --   return string.format('%s·%s', opts.ordinal, opts.lower(opts.id))
      -- end,
      numbers = nil,
      left_trunc_marker = icons.arrow_left_1,
      right_trunc_marker = icons.arrow_right_2,
      indicator = {
        -- icon = '▎',
        style = 'underline',
      },
      tab_size = 12,
      show_tab_indicators = true,
      max_name_length = 99,
      enforce_regular_tabs = false, -- 标签长度是否保持一致
      diagnostics = false,
      diagnostics_update_in_insert = false,
      diagnostics_indicator = nil,
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'EXPLORER',
          -- highlight = 'Directory',
          text_align = 'center',
          padding = 0,
          separator = '|',
        }
      },
      groups = {
        items = {
          require('bufferline.groups').builtin.pinned:with({ icon = icons.pinned_3 })
        }
      },
      custom_filter = this.filter()
      -- style_preset = {
      --   buffline.style_preset.no_italic,
      --   buffline.style_preset.no_bold
      -- },
    },
    highlights = {
      offset_separator = {
        bg = colors.dark0_soft,
      },
      indicator_visible = {
        fg = colors.bright_red,
        bg = colors.dark0_soft,
      },
      indicator_selected = {
        fg = colors.bright_red,
        sp = colors.bright_red,
        bg = colors.dark0_soft,
      },
      duplicate_selected = {
        sp = colors.bright_red,
        italic = true,
      },
      buffer_selected = {
        sp = colors.bright_red,
      },
      separator_selected = {
        sp = colors.bright_red,
      },
      -- fill = {
      --   fg = colors.dark1,
      --   bg = colors.dark1,
      -- },
    },
  })
end

return M

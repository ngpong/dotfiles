local M = {}

local icons           = require('ngpong.utils.icon')
local buffline        = require('bufferline')
local buffline_lazy   = require('bufferline.lazy')
local buffline_groups = buffline_lazy.require('bufferline.groups')

local this   = PLGS.bufferline
local colors = PLGS.colorscheme.colors

M.setup = function()
  buffline.setup({
    options = {
      mode = 'buffers',
      show_buffer_close_icons = false,
      show_close_icon = false,
      separator_style = 'thick', --{'█', '█'},
      -- numbers = function(opts)
      --   return string.format('%s·%s', opts.ordinal, opts.lower(opts.id))
      -- end,
      numbers = nil,
      left_trunc_marker = icons.arrow_left_1,
      right_trunc_marker = icons.arrow_right_2,
      indicator = {
        icon = '▎',
        style = 'icon',
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
          buffline_groups.builtin.pinned:with({ icon = '' })
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
        bg = colors.dark0_soft,
      },
      -- fill = {
      --   fg = colors.dark1,
      --   bg = colors.dark1,
      -- },
    },
  })
end

return M
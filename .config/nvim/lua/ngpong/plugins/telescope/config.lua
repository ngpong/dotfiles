local M = {}

local events    = require('ngpong.common.events')
local icons     = require('ngpong.utils.icon')
local lazy      = require('ngpong.utils.lazy')
local telescope = lazy.require('telescope')

local this = PLGS.telescope
local e_events = events.e_name

M.setup = function()
  local cfg = {
    defaults = {
      sorting_strategy = 'ascending', -- ascending, descending
      winblend = 0, -- 完全不透明
      wrap_results = false,
      initial_mode = 'normal',
      border = true,
      hl_result_eol = true,
      dynamic_preview_title = true,
      results_title = false,
      history = {
        path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
        limit = 100,
      },
      prompt_prefix = icons.space .. icons.search .. icons.space,
      selection_caret = icons.dapstopped .. icons.space,
      vimgrep_arguments = {
        'rg',
        -- telescope defaults
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        -- custom
        '--fixed-strings',
        '--sort=path',
      },
      file_ignore_patterns = {
        '^.git/',
        '^.cache/',
        '^scratch/',
        '%.npz',
      },
      preview = {
        -- filesize_limit = 25,
        -- treesitter = false,
        hide_on_startup = true,
        timeout = 250,
      },
    },
  }

  local layout_cfg = {
    defaults = {
      layout_strategy = 'horizontal', -- horizontal, vertical, center
      layout_config = { -- configure if you need change the default layout strategy
        horizontal = {
          height = this.api.resolve_height(0.9),
          preview_cutoff = 1,
          preview_width = this.api.resolve_width(0.6),
          prompt_position = 'top',
          width = this.api.resolve_width(0.9)
        },
        center = {
          height = 0.4,
          preview_cutoff = 1,
          prompt_position = 'top',
          width = 0.8,
        },
        vertical = {
          anchor = 'S',
          height = 0.9,
          preview_cutoff = 10,
          prompt_position = 'bottom',
          width = 0.8
        }
      },
    }
  }

  local picker_cfg = {
    pickers = {
      -- current_buffer_fuzzy_find = {
      --   preview = {
      --     hide_on_startup = false,
      --   }
      -- },
      -- live_grep = {
      --   preview = {
      --     hide_on_startup = false,
      --   }
      -- }
    },
  }

  local extensions_cfg = {
    extensions = {
      fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                         -- the default case_mode is "smart_case"
      },
      live_grep_args = {
        auto_quoting = false, -- enable/disable auto-quoting
        mappings = { -- extend mappings
          i = {
            ['<TAB>'] = require('telescope-live-grep-args.actions').quote_prompt(), -- { postfix = " --iglob " }
          },
        },
      }
    }
  }

  TOOLS.tbl_r_extend(cfg, layout_cfg,
                          picker_cfg,
                          extensions_cfg)

  events.emit(e_events.SETUP_TELESCOPE, cfg)

  telescope.setup(cfg)
  telescope.load_extension('fzf')
  telescope.load_extension('smart_history')
end

return M

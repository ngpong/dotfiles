local M = {}

local Events = require('ngpong.common.events')
local Icons = require('ngpong.utils.icon')
local Lazy = require('ngpong.utils.lazy')
local Telescope = Lazy.require('telescope')

local this = Plgs.telescope

local e_name = Events.e_name

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
      multi_icon = '', -- Icons.small_dot,
      prompt_prefix = Icons.space .. Icons.search .. Icons.space,
      selection_caret = '> ', --Icons.dapstopped .. Icons.space,
      vimgrep_arguments = {
        'rg',
        -- telescope defaults
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        -- '--smart-case',
        '--sort-files',
        '--fixed-strings',
        '--hidden',
        '--no-ignore-vcs',
      },
      -- 由 .ignore 文件去控制
      --  * '^.git/',
      --  * '^.cache/',
      --  * '^scratch/',
      --  * '%.npz',
      file_ignore_patterns = {},
      preview = {
        -- filesize_limit = 25,
        -- treesitter = false,
        hide_on_startup = true,
        timeout = 250,
      },
      cache_picker = {
        num_pickers = -1,
      },
    },
  }

  local layout_cfg = {
    defaults = {
      layout_strategy = 'horizontal', -- horizontal, vertical, center
      layout_config = { -- configure if you need change the default layout strategy
        horizontal = {
          anchor = 'S',
          height = this.api.resolve_height(0.9),
          preview_cutoff = 1,
          preview_width = this.api.resolve_width(0.6),
          prompt_position = 'top',
          width = this.api.resolve_width(0.9),
        },
        center = {
          anchor = 'N',
          height = 0.4,
          preview_cutoff = 1,
          prompt_position = 'top',
          preview_width = this.api.resolve_width(0.6),
          mirror = true,
          width = 0.9,
        },
        vertical = {
          anchor = 'S',
          mirror = true,
          height = 0.9,
          preview_cutoff = 10,
          prompt_position = 'bottom',
          width = 0.9,
        },
      },
    },
  }

  local picker_cfg = {
    pickers = {
      find_files = {
        find_command = {
          'rg',
          '--files',
          '--hidden',
          '--sort-files',
          '--no-ignore-vcs',
        },
      },
      git_status = {
        git_icons = {
          added = Icons.git_add,
          changed = Icons.git_change,
          deleted = Icons.git_delete,
          renamed = Icons.git_renamed,
          unmerged = Icons.git_conflict,
          untracked = Icons.git_untracked,
        },
      },
      lsp_document_symbols = {
        symbol_kinds = Icons.lsp_kinds
      },
      lsp_workspace_symbols = {
        symbol_kinds = Icons.lsp_kinds
      },
      lsp_dynamic_workspace_symbols = {
        symbol_kinds = Icons.lsp_kinds
      },
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
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
      live_grep_args = {
        auto_quoting = false, -- enable/disable auto-quoting
        mappings = { -- extend mappings
          i = {
            ['<TAB>'] = require('telescope-live-grep-args.actions').quote_prompt(), -- { postfix = " --iglob " }
          },
        },
      },
    },
  }

  Tools.tbl_r_extend(cfg, layout_cfg,
                          picker_cfg,
                          extensions_cfg)

  Events.emit(e_name.SETUP_TELESCOPE, cfg)

  Telescope.setup(cfg)
  Telescope.load_extension('fzf')
  Telescope.load_extension('smart_history')
end

return M

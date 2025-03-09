local M = {}

local Telescope = vim.__lazy.require("telescope")

local t_api = vim._plugins.telescope.api

local etypes = vim.__event.types

M.setup = function()
  local cfg = {
    defaults = {
      sorting_strategy = "ascending", -- ascending, descending
      winblend = 0, -- 完全不透明
      wrap_results = false,
      initial_mode = "normal",
      border = true,
      hl_result_eol = true,
      dynamic_preview_title = true,
      results_title = false,
      history = {
        path = "~/.local/share/nvim/databases/telescope_history.sqlite3",
        limit = 100,
      },
      multi_icon = "", -- vim.__icons.small_dot,
      prompt_prefix = vim.__icons.space .. vim.__icons.search .. vim.__icons.space,
      selection_caret = vim.__icons.arrow_right_3 .. vim.__icons.space,
      vimgrep_arguments = {
        "rg",
        -- telescope defaults
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        -- "--smart-case",
        "--sort-files",
        "--fixed-strings",
        "--hidden",
        "--no-ignore-vcs",
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
      layout_strategy = "horizontal", -- horizontal, vertical, center
      layout_config = { -- configure if you need change the default layout strategy
        horizontal = {
          anchor = "S",
          height = t_api.resolve_height(0.9),
          preview_cutoff = 1,
          preview_width = t_api.resolve_width(0.6),
          prompt_position = "top",
          width = t_api.resolve_width(0.9),
        },
        center = {
          anchor = "N",
          height = 0.4,
          preview_cutoff = 1,
          prompt_position = "top",
          preview_width = t_api.resolve_width(0.6),
          mirror = true,
          width = 0.9,
        },
        vertical = {
          anchor = "S",
          mirror = true,
          height = 0.9,
          preview_cutoff = 10,
          prompt_position = "bottom",
          width = 0.9,
        },
      },
    },
  }

  local picker_cfg = {
    pickers = {
      find_files = {
        find_command = {
          "rg",
          "--files",
          "--hidden",
          "--sort-files",
          "--no-ignore-vcs",
        },
      },
      git_status = {
        git_icons = {
          added = vim.__icons.git_add,
          changed = vim.__icons.git_change,
          deleted = vim.__icons.git_delete,
          renamed = vim.__icons.git_renamed,
          unmerged = vim.__icons.git_conflict,
          untracked = vim.__icons.git_untracked,
        },
      },
      lsp_document_symbols = {
        symbol_kinds = vim.__icons.lsp_kinds
      },
      lsp_workspace_symbols = {
        symbol_kinds = vim.__icons.lsp_kinds
      },
      lsp_dynamic_workspace_symbols = {
        symbol_kinds = vim.__icons.lsp_kinds
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
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
      live_grep_args = {
        auto_quoting = false, -- enable/disable auto-quoting
        mappings = { -- extend mappings
          i = {
            ["<TAB>"] = require("telescope-live-grep-args.actions").quote_prompt(), -- { postfix = " --iglob " }
          },
        },
      },
    },
  }

  vim.__tbl.r_extend(cfg, layout_cfg,
                         picker_cfg,
                         extensions_cfg)

  vim.__event.emit(etypes.SETUP_TELESCOPE, cfg)

  Telescope.setup(cfg)
  Telescope.load_extension("fzf")
  -- Telescope.load_extension("smart_history")
end

return M

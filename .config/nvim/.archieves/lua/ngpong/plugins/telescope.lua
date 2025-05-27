return {
  "nvim-telescope/telescope.nvim",
  lazy = true,
  cmd = "Telescope",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make"
    },
    "nvim-telescope/telescope-smart-history.nvim",
    "NGPONG/telescope-live-grep-args.nvim",
  },
  autocmds = {
    {
      "ExitPre",
      function()
        for _, bufnr in ipairs(vim.__buf.all()) do
          if vim.__buf.is_valid(bufnr) and vim.__buf.filetype(bufnr) == "TelescopePrompt" then
            require("telescope.actions").actions.close(bufnr)
            vim.schedule(function() vim.cmd("wqall") end)
            return
          end
        end
      end
    }
  },
  highlights = {
    { "TelescopePromptTitle", fg = vim.__color.bright_green, italic = true, bold = true },
    { "TelescopePreviewTitle", fg = vim.__color.bright_green, italic = true, bold = true },
    { "TelescopeMatching", fg = vim.__color.bright_red, italic = true, bold = true },
    { "TelescopeSelection", bg = vim.__color.dark2 },
    { "TelescopeSelectionCaret", bg = vim.__color.dark2, fg = vim.__color.light1 },
    { "TelescopeMultiSelection", fg = vim.__color.light1, bg = vim.__color.dark2, bold = true, italic = true },
    { "TelescopeResultsDiffUntracked", fg = vim.__color.bright_orange },
    { "TelescopeResultsDiffAdd", fg = vim.__color.bright_green },
    { "TelescopeResultsDiffchange", fg = vim.__color.bright_yellow },
    { "TelescopeResultsDiffDelete", fg = vim.__color.bright_red },
  },
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<f4>"] = function(...) require("telescope.actions.layout").toggle_preview(...) end,
        }
      },
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
      file_ignore_patterns = {},
      preview = {
        wrap = true,
        number = true,
        filesize_limit = 25,
        treesitter = true,
        hide_on_startup = true,
        timeout = 250,
      },
    },
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
            ["<TAB>"] = function() return require("telescope-live-grep-args.actions").quote_prompt() end, -- { postfix = " --iglob " }
          },
        },
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")

    local group = vim.__autocmd.augroup("telescope")
    group:on(
      "User",
      function ()
        -- https://github.com/nvim-telescope/telescope.nvim/issues/2777
        vim.opt.wrap = opts.defaults.preview.wrap
        -- https://github.com/nvim-telescope/telescope.nvim/issues/1186
        vim.opt.number = opts.defaults.preview.number
      end,
      { pattern = "TelescopePreviewerLoaded" }
    )

    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("smart_history")
  end
}
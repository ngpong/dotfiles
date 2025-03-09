local M = {}

local etypes = vim.__event.types

M.setup = function()
  local cfg = {
    log_level = "fatal",
    log_to_file = true,
    close_if_last_window = true,
    default_source = "last",
    popup_border_style = "rounded", -- "double", "none", "rounded", "shadow", "single" or "solid"
    enable_diagnostics = true,
    enable_opened_markers = false,
    enable_refresh_on_write = true,
    enable_modified_markers = true,
    enable_git_status = true,
    open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
    sort_case_insensitive = false, -- used when sorting files and directories in the tree
    sort_function = nil, -- use a custom function for sorting files and directories in the tree
    nesting_rules = {},
    use_default_mappings = false,
    hide_root_node = true,
    retain_hidden_root_indent = false,
    add_blank_line_at_top = false,
    auto_clean_after_session_restore = true, -- Automatically clean up broken neo-tree buffers saved in sessions
    open_files_in_last_window = true,
    resize_timer_interval = 200,
    default_component_configs = {
      container = {
        enable_character_fade = true,
        width = "100%",
        right_padding = 0,
      },
      name = {
        trailing_slash = false,
        highlight_opened_files = false,
        use_git_status_colors = true,
        highlight = "NeoTreeFileName",
      },
    },
    window = {
      position = "left",
      width = 30,
    },
    filesystem = {
      filtered_items = {
        visible = false, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = true,
        hide_gitignored = true,
        hide_hidden = true, -- only works on Windows for hidden files/directories
        hide_by_name = {
          ".DS_Store",
          "thumbs.db",
        },
        hide_by_pattern = { -- uses glob style patterns
          --"*.meta",
          --"*/src/*/tsconfig.json",
        },
        always_show = { -- remains visible even if other settings would normally hide it
          --".gitignored",
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          --".DS_Store",
          --"thumbs.db"
        },
        never_show_by_pattern = { -- uses glob style patterns
          --".null-ls_*",
        },
      },
      use_libuv_file_watcher = false,
      bind_to_cwd = true,
      follow_current_file = {
        enabled = false,
        leave_dirs_open = false,
      },
      group_empty_dirs = true,
      async_directory_scan = "always",
      scan_mode = "deep",
    },
    -- 仅保留 filesystem，其余功能例如 buffer symbols 都有其余按键可以替代
    sources = {
      "filesystem",
    },
  }

  local hook_cfg = {
    event_handlers = {
      {
        event = "neo_tree_window_after_open",
        handler = function(_)
          vim.__event.emit(etypes.OPEN_NEOTREE, { bufnr = vim.__buf.current() })
        end,
      },
      {
        event = "neo_tree_window_after_close",
        handler = function(_)
          vim.__event.emit(etypes.FREE_NEOTREE)
        end,
      },
    },
  }

  local fixicon_cfg = {
    default_component_configs = {
      indent = {
        indent_marker = vim.__icons.indent_marker_3,
        last_indent_marker = vim.__icons.indent_marker_2,
        expander_collapsed = vim.__icons.closepand,
        expander_expanded = vim.__icons.expand,
      },
      diagnostics = {
        symbols = {
          hint = vim.__icons.diagnostic_hint,
          info = vim.__icons.diagnostic_info,
          warn = vim.__icons.diagnostic_warn,
          error = vim.__icons.diagnostic_err,
        },
        highlights = {
          hint = "NeoTreeDiagnosticSignHint",
          info = "NeoTreeDiagnosticSignInfo",
          warn = "NeoTreeDiagnosticSignWarn",
          error = "NeoTreeDiagnosticSignError",
        },
      },
      icon = {
        folder_closed = vim.__icons.directory,
        folder_open = vim.__icons.directory_opened,
        folder_empty = vim.__icons.empty_directory,
        folder_empty_open = vim.__icons.empty_directory_opened,
        default = vim.__icons.file_3,
      },
      modified = {
        symbol = vim.__icons.big_dot,
      },
      git_status = {
        symbols = {
          added = vim.__icons.git_add,
          modified = vim.__icons.git_change,
          deleted = vim.__icons.git_delete,
          renamed = vim.__icons.git_renamed,
          untracked = vim.__icons.git_untracked,
          ignored = vim.__icons.git_ignored,
          unstaged = vim.__icons.git_unstaged,
          staged = vim.__icons.git_staged,
          conflict = vim.__icons.git_conflict,
        },
      },
    },
  }

  vim.__tbl.r_extend(cfg, hook_cfg,
                          fixicon_cfg)

  vim.__event.emit(etypes.SETUP_NEOTREE, cfg)

  require("neo-tree").setup(cfg)
end

return M

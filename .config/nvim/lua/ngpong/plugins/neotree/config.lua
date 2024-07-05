local M = {}

local Events = require('ngpong.common.events')
local Icons  = require('ngpong.utils.icon')

local e_name = Events.e_name

M.setup = function()
  local cfg = {
    log_level = 'fatal',
    log_to_file = true,
    close_if_last_window = true,
    default_source = 'last',
    popup_border_style = 'rounded', -- 'double', 'none', 'rounded', 'shadow', 'single' or 'solid'
    enable_diagnostics = true,
    enable_opened_markers = false,
    enable_refresh_on_write = false,
    enable_modified_markers = true,
    enable_git_status = true,
    open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
    sort_case_insensitive = false, -- used when sorting files and directories in the tree
    sort_function = nil , -- use a custom function for sorting files and directories in the tree
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
        width = '100%',
        right_padding = 0,
      },
      name = {
        trailing_slash = false,
        highlight_opened_files = false,
        use_git_status_colors = true,
        highlight = 'NeoTreeFileName',
      },
    },
    window = {
      position = 'left',
      width = 30,
    },
    filesystem = {
      filtered_items = {
        visible = false, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = true,
        hide_gitignored = true,
        hide_hidden = true, -- only works on Windows for hidden files/directories
        hide_by_name = {
          '.DS_Store',
          'thumbs.db'
        },
        hide_by_pattern = { -- uses glob style patterns
          --'*.meta',
          --'*/src/*/tsconfig.json',
        },
        always_show = { -- remains visible even if other settings would normally hide it
          --'.gitignored',
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          --'.DS_Store',
          --'thumbs.db'
        },
        never_show_by_pattern = { -- uses glob style patterns
          --'.null-ls_*',
        },
      },
      use_libuv_file_watcher = true,
      bind_to_cwd = true,
      follow_current_file = {
        enabled = false,
        leave_dirs_open = false,
      },
      group_empty_dirs = true,
      async_directory_scan = 'always',
      scan_mode = 'deep',
    },
    -- 仅保留 filesystem，其余功能例如 buffer symbols 都有其余按键可以替代
    sources = {
      'filesystem',
    },
  }

  local hook_cfg = {
    event_handlers = {
      {
        event = 'neo_tree_window_after_open',
        handler = function ()
          Events.emit(e_name.OPEN_NEOTREE, { bufnr = Helper.get_cur_bufnr() })
        end
      },
      {
        event = 'neo_tree_window_after_close',
        handler = function ()
          Events.emit(e_name.FREE_NEOTREE)
        end
      },
    },
  }

  local fixicon_cfg = {
    default_component_configs = {
      indent = {
        indent_marker = Icons.indent_marker_3,
        last_indent_marker = Icons.indent_marker_2,
        expander_collapsed = Icons.closepand,
        expander_expanded = Icons.expand,
      },
      diagnostics = {
        symbols = {
          hint = Icons.diagnostic_hint,
          info = Icons.diagnostic_info,
          warn = Icons.diagnostic_warn,
          error = Icons.diagnostic_err,
        },
        highlights = {
          hint = 'NeoTreeDiagnosticSignHint',
          info = 'NeoTreeDiagnosticSignInfo',
          warn = 'NeoTreeDiagnosticSignWarn',
          error = 'NeoTreeDiagnosticSignError',
        },
      },
      icon = {
        folder_closed = Icons.dir_closed,
        folder_open = Icons.dir_opened,
        folder_empty = Icons.dir_empty_opend,
        folder_empty_open = Icons.dir_empty_closed,
        default = Icons.file_3,
      },
      modified = {
        symbol = Icons.circular_big,
      },
      git_status = {
        symbols = {
          added     = Icons.git_add,
          modified  = Icons.git_change,
          deleted   = Icons.git_delete,
          renamed   = Icons.git_renamed,
          untracked = Icons.git_untracked,
          ignored   = Icons.git_ignored,
          unstaged  = Icons.git_unstaged,
          staged    = Icons.git_staged,
          conflict  = Icons.git_conflict,
        }
      },
    },
  }

  Tools.tbl_r_extend(cfg, hook_cfg,
                          fixicon_cfg)

  Events.emit(e_name.SETUP_NEOTREE, cfg)

  require('neo-tree').setup(cfg)
end

return M

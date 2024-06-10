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
    hide_root_node = false,
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
      width = 40,
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
      scan_mode = 'deep',
    },
    buffers = {
      bind_to_cwd = true,
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      group_empty_dirs = true,
      show_unloaded = true,
    },
    document_symbols = {
      follow_cursor = false,
      -- client_filters = {
      --   fn = function(name) return name ~= 'null-ls' end,
      -- },
      renderers = {
        root = {
          { 'indent' },
          { 'icon', default= 'C' },
          { 'name', zindex = 10},
        },
        symbol = {
          { 'indent', with_expanders = true },
          { 'kind_icon', default='?' },
          { 'container',
          content = {
              { 'name', zindex = 10 },
              { 'kind_name', zindex = 20, align = 'right' },
            }
          }
        },
      },
    },
    sources = {
      'filesystem',
      'git_status',
      -- 'buffers',
      'document_symbols',
    },
    source_selector = {
      sources = {
        {
          source = 'filesystem',
          display_name = Icons.space .. Icons.files_1 .. Icons.space .. 'FILES' .. Icons.space
        },
        {
          source = 'git_status',
          display_name = Icons.space .. Icons.git .. Icons.space .. 'GIT' .. Icons.space
        },
        {
          source = 'buffers',
          display_name = Icons.space .. Icons.files_2 .. Icons.space .. 'BUFFERS' .. Icons.space
        },
        {
          source = 'document_symbols',
          display_name = Icons.space .. Icons.symbol .. Icons.space .. 'SYMBOLS' .. Icons.space
        },
      },
      winbar = true,
      show_scrolled_off_parent_node = true,
      show_separator_on_edge = false,
      content_layout = 'center',
      tabs_layout = 'equal',
      separator = { left = Icons.left_harf_2, right= Icons.right_harf_2 },
    },
  }

  local hook_cfg = {
    event_handlers = {
      {
        event = 'neo_tree_window_after_open',
        handler = function ()
          Events.emit(e_name.INIT_NEOTREE)
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
    document_symbols = {
      kinds = {
        -- respect gruvbox.nvim CmpItemKind* settings
        File = { icon = Icons.lsp_kinds.File.val, hl = Icons.lsp_kinds.File.hl_link },
        Method = { icon = Icons.lsp_kinds.Method.val, hl = Icons.lsp_kinds.Method.hl_link },
        Field= { icon = Icons.lsp_kinds.Field.val, hl = Icons.lsp_kinds.Field.hl_link },
        Namespace = { icon = Icons.lsp_kinds.Module.val, hl = Icons.lsp_kinds.Module.hl_link },
        Constructor = { icon = Icons.lsp_kinds.Constructor.val, hl = Icons.lsp_kinds.Constructor.hl_link },
        Package = { icon = Icons.lsp_kinds.Package.val, hl = Icons.lsp_kinds.Package.hl_link },
        Class = { icon = Icons.lsp_kinds.Class.val, hl = Icons.lsp_kinds.Class.hl_link },
        Property = { icon = Icons.lsp_kinds.Property.val, hl = Icons.lsp_kinds.Property.hl_link },
        Enum = { icon = Icons.lsp_kinds.Enum.val, hl = Icons.lsp_kinds.Enum.hl_link },
        Function = { icon = Icons.lsp_kinds.Function.val, hl = Icons.lsp_kinds.Function.hl_link },
        Variable = { icon = Icons.lsp_kinds.Variable.val, hl = Icons.lsp_kinds.Variable.hl_link },
        String = { icon = Icons.lsp_kinds.String.val, hl = Icons.lsp_kinds.String.hl_link },
        Number = { icon = Icons.lsp_kinds.Value.val, hl = Icons.lsp_kinds.Value.hl_link },
        Array = { icon = Icons.lsp_kinds.Array.val, hl = Icons.lsp_kinds.Array.hl_link },
        Object = { icon = Icons.lsp_kinds.Class.val, hl = Icons.lsp_kinds.Class.hl_link },
        Key = { icon = Icons.lsp_kinds.Keyword.val, hl = Icons.lsp_kinds.Keyword.hl_link },
        Struct = { icon = Icons.lsp_kinds.Struct.val, hl = Icons.lsp_kinds.Struct.hl_link },
        Operator = { icon = Icons.lsp_kinds.Operator.val, hl = Icons.lsp_kinds.Operator.hl_link },
        TypeParameter = { icon = Icons.lsp_kinds.TypeParameter.val, hl = Icons.lsp_kinds.TypeParameter.hl_link },
        StaticMethod = { icon = Icons.lsp_kinds.StaticMethod.val, hl = Icons.lsp_kinds.StaticMethod.hl_link },
      }
    },
  }

  local fix_1312_cfg = {
    document_symbols = {
      client_filters = {
        fn = function(name) return name ~= 'bashls' end,
      },
    },
  }

  Tools.tbl_r_extend(cfg, hook_cfg,
                          fixicon_cfg,
                          fix_1312_cfg)

  Events.emit(e_name.SETUP_NEOTREE, cfg)

  require('neo-tree').setup(cfg)
end

return M

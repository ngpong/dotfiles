local M = {}

-- stylua: ignore
local NvimTree    = vim.__lazy.require("nvim-tree")
local NvimTreeAPI = vim.__lazy.require("nvim-tree.api")

local events = vim.__event
local etypes = vim.__event.types

local function setup_tree()
  local cfg = {
    on_attach = "default",
    hijack_cursor = false,
    auto_reload_on_write = false,
    disable_netrw = true,
    hijack_netrw = true,
    hijack_unnamed_buffer_when_opening = false,
    root_dirs = {},
    prefer_startup_root = false,
    sync_root_with_cwd = false,
    reload_on_bufenter = false,
    respect_buf_cwd = false,
    select_prompts = true,
    sort = {
      sorter = "name",
      folders_first = true,
      files_first = false,
    },
    view = {
      centralize_selection = false,
      cursorline = true,
      debounce_delay = 15,
      side = "left",
      preserve_window_proportions = false,
      number = false,
      relativenumber = false,
      signcolumn = "yes",
      width = 30,
      float = {
        enable = false,
        quit_on_focus_loss = true,
        open_win_config = {
          relative = "editor",
          border = "rounded",
          width = 30,
          height = 30,
          row = 1,
          col = 1,
        },
      },
    },
    renderer = {
      add_trailing = false,
      group_empty = false,
      full_name = false,
      root_folder_label = false,
      indent_width = 2,
      special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
      symlink_destination = true,
      highlight_git = "none",
      highlight_diagnostics = "none",
      highlight_opened_files = "none",
      highlight_modified = "none",
      highlight_hidden = "none",
      highlight_bookmarks = "none",
      highlight_clipboard = "name",
      indent_markers = {
        enable = false,
        inline_arrows = true,
        icons = {
          corner = "└",
          edge = "│",
          item = "│",
          bottom = "─",
          none = " ",
        },
      },
      icons = {
        web_devicons = {
          file = {
            enable = true,
            color = true,
          },
          folder = {
            enable = false,
            color = true,
          },
        },
        git_placement = "right_align",
        modified_placement = "right_align",
        hidden_placement = "right_align",
        diagnostics_placement = "right_align",
        bookmarks_placement = "right_align",
        padding = " ",
        symlink_arrow = " ➛ ",
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
          modified = true,
          hidden = false,
          diagnostics = true,
          bookmarks = true,
        },
        glyphs = {
          default = "",
          symlink = "",
          bookmark = "󰆤",
          modified = "●",
          hidden = "󰜌",
          folder = {
            arrow_closed = "",
            arrow_open = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
          },
          git = {
            deleted = vim.__icons.git_delete,
            renamed = vim.__icons.git_renamed,
            untracked = vim.__icons.git_untracked,
            ignored = vim.__icons.git_ignored,
            unstaged = vim.__icons.git_unstaged,
            staged = vim.__icons.git_staged,
          },
        },
      },
    },
    hijack_directories = {
      enable = true,
      auto_open = true,
    },
    update_focused_file = {
      enable = false,
      update_root = {
        enable = false,
        ignore_list = {},
      },
      exclude = false,
    },
    system_open = {
      cmd = "",
      args = {},
    },
    git = {
      enable = true,
      show_on_dirs = true,
      show_on_open_dirs = true,
      disable_for_dirs = {},
      timeout = 400,
      cygwin_support = false,
    },
    diagnostics = {
      enable = false,
      show_on_dirs = false,
      show_on_open_dirs = true,
      debounce_delay = 50,
      severity = {
        min = vim.diagnostic.severity.HINT,
        max = vim.diagnostic.severity.ERROR,
      },
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
      },
    },
    modified = {
      enable = false,
      show_on_dirs = true,
      show_on_open_dirs = true,
    },
    filters = {
      enable = true,
      git_ignored = true,
      dotfiles = false,
      git_clean = false,
      no_buffer = false,
      no_bookmark = false,
      custom = {},
      exclude = {},
    },
    live_filter = {
      prefix = "[FILTER]: ",
      always_show_folders = true,
    },
    filesystem_watchers = {
      enable = false,
      debounce_delay = 50,
      ignore_dirs = {},
    },
    actions = {
      use_system_clipboard = true,
      change_dir = {
        enable = true,
        global = false,
        restrict_above_cwd = false,
      },
      expand_all = {
        max_folder_discovery = 300,
        exclude = {},
      },
      file_popup = {
        open_win_config = {
          col = 1,
          row = 1,
          relative = "cursor",
          border = "shadow",
          style = "minimal",
        },
      },
      open_file = {
        quit_on_open = false,
        eject = true,
        resize_window = true,
        window_picker = {
          enable = true,
          picker = "default",
          chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
          exclude = {
            filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
            buftype = { "nofile", "terminal", "help" },
          },
        },
      },
      remove_file = {
        close_window = true,
      },
    },
    trash = {
      cmd = "gio trash",
    },
    tab = {
      sync = {
        open = false,
        close = false,
        ignore = {},
      },
    },
    notify = {
      threshold = vim.log.levels.INFO,
      absolute_path = true,
    },
    help = {
      sort_by = "key",
    },
    ui = {
      confirm = {
        remove = true,
        trash = true,
        default_yes = false,
      },
    },
    experimental = {
      actions = {
        open_file = {
          relative_path = false,
        },
      },
    },
    log = {
      enable = false,
      truncate = false,
      types = {
        all = false,
        config = false,
        copy_paste = false,
        dev = false,
        diagnostics = false,
        git = false,
        profile = false,
        watcher = false,
      },
    },
  }

  events.emit(etypes.SETUP_NVIMTREE, cfg)

  NvimTree.setup(cfg)
end

local function setup_preview()
  require("nvim-tree-preview").setup {
    -- Keymaps for the preview window (does not apply to the tree window).
    -- Keymaps can be a string (vimscript command), a function, or a table.
    --
    -- If a function is provided:
    --   When the keymap is invoked, the function is called.
    --   It will be passed a single argument, which is a table of the following form:
    --     {
    --       node: NvimTreeNode|NvimTreeRootNode, -- The tree node under the cursor
    --     }
    --   See the type definitions in `lua/nvim-tree-preview/types.lua` for a description
    --   of the fields in the table.
    --
    -- If a table, it must contain either an 'action' or 'open' key:
    --   Actions:
    --     { action = "close", unwatch? = false, focus_tree? = true }
    --     { action = "toggle_focus" }
    --
    --   Open modes:
    --     { open = "edit" }
    --     { open = "tab" }
    --     { open = "vertical" }
    --     { open = "horizontal" }
    --
    -- To disable a default keymap, set it to false.
    -- All keymaps are set in normal mode. Other modes are not currently supported.
    keymaps = {
      ["<Esc>"] = { action = "close", unwatch = true },
      ["<Tab>"] = { action = "toggle_focus" },
      ["<CR>"] = { open = "edit" },
      ["<C-t>"] = { open = "tab" },
      ["<C-v>"] = { open = "vertical" },
      ["<C-x>"] = { open = "horizontal" },
    },
    min_width = 10,
    min_height = 5,
    max_width = 85,
    max_height = 25,
    wrap = false, -- Whether to wrap lines in the preview window
    border = "rounded", -- Border style for the preview window
    zindex = 100, -- Stacking order. Increase if the preview window is shown below other windows.
    show_title = true, -- Whether to show the file name as the title of the preview window
    title_pos = "top-left", -- top-left|top-center|top-right|bottom-left|bottom-center|bottom-right
    title_format = " %s ",
  }
end

local setup_event = function()
  NvimTreeAPI.events.subscribe(NvimTreeAPI.events.Event.TreeOpen, function(data)
    vim.__event.emit(etypes.OPEN_NVIMTREE)
  end)

  NvimTreeAPI.events.subscribe(NvimTreeAPI.events.Event.TreeClose, function(data)
    vim.__event.emit(etypes.FREE_NVIMTREE)
  end)
end

M.setup = function()
  setup_tree()
  setup_event()
  setup_preview()
end

return M

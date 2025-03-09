local Module = vim.__class.def(function(this)
  local NvimTreeAPI = vim.__lazy.require("nvim-tree.api")

  function this:toggle(opts)
    NvimTreeAPI.tree.toggle(opts)
  end
end)

local function action_wrap_trigger(f)
  return function()
    f()
    vim.__autocmd.exec("User", { pattern = "NvimtreeToggleFilter" })
    vim.__stl.redraw(true)
  end
end

local function action_wrap_opentab()
  local api = require("nvim-tree.api")
  local node = api.tree.get_node_under_cursor()
  vim.cmd("wincmd l")
  api.node.open.tab(node)
end

return {
  {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    dependencies = {
      {
        "ngpong/nvim-tree-preview.lua",
        opts = {
          keymaps = {
            ["<CR>"] = { open = "edit" },
            ["q"] = { action = "close", unwatch = true },
            ["o"] = { open = "edit" },
            ["<C-o><C-t>"] = { open = "tab" },
            ["<C-o><C-v>"] = { open = "vertical" },
            ["<C-o><C-x>"] = { open = "horizontal" },
            ["<C-o>t"] = { open = "tab" },
            ["<C-o>v"] = { open = "vertical" },
            ["<C-o>x"] = { open = "horizontal" },
          },
          min_width = 60,
          min_height = 60,
          max_width = 999,
          max_height = 999,
          wrap = true,
          border = vim.__icons.border.yes,
          winhighlight = "Normal:NvimTreePreviewNormalFloat,FloatBorder:NvimTreePreviewFloatBorder",
          zindex = 1,
          show_title = true, -- Whether to show the file name as the title of the preview window
          title_pos = "top-center", -- top-left|top-center|top-right|bottom-left|bottom-center|bottom-right
          title_format = " %s ",
          on_open = function(winid, bufnr)
            vim.__autocmd.exec("User", { pattern = "UserPreview" })
            vim.__stl.redraw(true)
          end,
          on_close = function()
            vim.__autocmd.exec("User", { pattern = "UserPreview" })
            vim.__stl.redraw(true)
          end
        },
        config = function(_, opts)
          local set_win_options = require("nvim-tree-preview.preview").set_win_options
          require("nvim-tree-preview.preview").set_win_options = function(self)
            set_win_options(self)

            if self:is_valid() then
              local win = self.preview_win
              vim.api.nvim_set_option_value(
                "winhighlight",
                opts.winhighlight,
                { win = win, scope = "local" }
              )
            end
          end

          require("nvim-tree-preview").setup(opts)
        end
      }
    },
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile", "NvimTreeCollapse" },
    highlights = {
      { "NvimTreeIndentMarker", link = "IndentGuide" },
      { "NvimTreeFolderArrowClosed", fg = vim.__color.light1 },
      { "NvimTreeFolderArrowOpen", fg = vim.__color.light1 },
      { "NvimTreeFolderIcon", link = "DirectoryIcon" },
      { "NvimTreeHiddenFileHL", fg = vim.__color.dark3 },
      { "NvimTreeLiveFilterPrefix", fg = vim.__color.bright_blue },
      { "NvimTreeLiveFilterValue", link = "Normal" },
      { "NvimTreeBookmarkIcon", fg = vim.__color.bright_aqua },
      { "NvimTreeBookmarkHL", bold = true, fg = vim.__color.bright_aqua },
      { "NvimTreeCutHL", bold = true, fg = vim.__color.bright_red },
      { "NvimTreeCopiedHL", bold = true, fg = vim.__color.bright_yellow },
      { "NvimTreeNormal", fg = vim.__color.light2, bg = vim.__color.dark0_hard },
      { "NvimTreeWinSeparator", fg = vim.__color.dark0 },
      { "NvimTreeEndOfBuffer", fg = vim.__color.dark0_hard },
      { "NvimTreeCursorLine", bg = vim.__color.dark0_hard },

      { "NvimTreePreviewNormalFloat", bg = vim.__color.dark0 },
      { "NvimTreePreviewFloatBorder", bg = vim.__color.dark0, fg = vim.__color.dark2 },
    },
    keys = {
      { "<leader>e", function() vim.__explorer.toggle() end }
    },
    opts = {
      keys = {
        { "q", function()
          local PreviewManager = require("nvim-tree-preview.manager")
          if PreviewManager.instance and PreviewManager.instance:is_valid() then
            PreviewManager.instance:close({ unwatch = true, focus_tree = true })
          end

          require("nvim-tree.api").tree.close()
        end },
        { "=", function() vim.__win.resize_op("NvimTreeResize +") end },
        { "-", function() vim.__win.resize_op("NvimTreeResize -") end },
        { "<C-r>", function() require("nvim-tree.api").tree.reload() end },
        { "<2-LeftMouse>",  function() require("nvim-tree.api").node.open.edit() end },
        { "<2-RightMouse>", function() require("nvim-tree.api").tree.change_root_to_node() end },

        { "f", "<NOP>" },
        { "f", function()
          vim.__autocmd.on("WinNew", function()
            local winid = vim.__win.current()
            vim.wo[winid].winhighlight = "Normal:NvimTreeNormal"
          end, { once = true })
          require("nvim-tree.api").live_filter.start()
        end },
        { "F", function() require("nvim-tree.api").live_filter.clear() end },
        { "E", function() require("nvim-tree.api").tree.expand_all() end },
        { "W", function() require("nvim-tree.api").tree.collapse_all() end },

        { "i", function() require("nvim-tree.api").node.show_info_popup() end },
        { ".", function() require("nvim-tree.api").node.run.cmd() end },
        { "}", function() require("nvim-tree.api").node.navigate.sibling.last() end },
        { "{", function() require("nvim-tree.api").node.navigate.sibling.first() end },
        { ">", function() require("nvim-tree.api").node.navigate.sibling.next() end },
        { "<", function() require("nvim-tree.api").node.navigate.sibling.prev() end },

        { "M", function() require("nvim-tree.api").marks.clear() end, },
        { "mm", function() require("nvim-tree.api").marks.toggle() end, },
        { "md", function() require("nvim-tree.api").marks.bulk.delete() end, },
        { "mv", function() require("nvim-tree.api").marks.bulk.move() end, },
        { "mp", function()
          local NvimTreeAPI = require("nvim-tree.api")

          local marked_nodes = NvimTreeAPI.marks.list()
          if next(marked_nodes) == nil then
            vim.api.nvim_echo({{"No nodes are marked to paste","None"}},false,{})
          else
            for _, node in ipairs(marked_nodes) do
              NvimTreeAPI.fs.copy.node(node)
              NvimTreeAPI.fs.paste(NvimTreeAPI.tree.get_node_under_cursor())
            end
            NvimTreeAPI.marks.clear()
            NvimTreeAPI.fs.clear_clipboard()
          end
        end },

        { "[h", function() require("nvim-tree.api").node.navigate.git.prev() end },
        { "]h", function() require("nvim-tree.api").node.navigate.git.next() end },
        { "]d", function() require("nvim-tree.api").node.navigate.diagnostics.next() end },
        { "[d", function() require("nvim-tree.api").node.navigate.diagnostics.prev() end },

        { "r", function() require("nvim-tree.api").fs.rename() end},
        { "R", function() require("nvim-tree.api").fs.rename_full() end},
        { "a", function() require("nvim-tree.api").fs.create() end},
        { "c", function() require("nvim-tree.api").fs.copy.node() end},
        { "d", function() require("nvim-tree.api").fs.cut() end},
        { "x", function() require("nvim-tree.api").fs.remove() end},
        { "C", function() require("nvim-tree.api").fs.clear_clipboard() end},
        { "y", function() require("nvim-tree.api").fs.copy.filename() end}, -- NvimTreeAPI.fs.copy.relative_path 
        { "Y", function() require("nvim-tree.api").fs.copy.absolute_path() end},
        { "p", function() require("nvim-tree.api").fs.paste() end},

        { "t", "<NOP>" },
        { "T", "<NOP>" },
        { "T", action_wrap_trigger(function() require("nvim-tree.api").tree.toggle_enable_filters() end) },
        { "tg", action_wrap_trigger(function() require("nvim-tree.api").tree.toggle_gitignore_filter() end) },
        { "th", action_wrap_trigger(function() require("nvim-tree.api").tree.toggle_hidden_filter() end) },
        { "tb", action_wrap_trigger(function() require("nvim-tree.api").tree.toggle_no_buffer_filter() end) },
        { "tm", action_wrap_trigger(function() require("nvim-tree.api").tree.toggle_no_bookmark_filter() end) },

        { "<BS>", function() require("nvim-tree.api").node.navigate.parent_close() end },
        { "<CR>", function() require("nvim-tree.api").node.open.edit() end },
        { "<C-o>", "<NOP>" },
        { "<C-i>", "<NOP>" },
        { "O", function() require("nvim-tree.api").node.navigate.parent_close() end },
        { "o", function() require("nvim-tree.api").node.open.edit() end },
        { "<C-o>t", action_wrap_opentab },
        { "<C-o>v", function() require("nvim-tree.api").node.open.vertical() end },
        { "<C-o>s", function() require("nvim-tree.api").node.open.horizontal() end },
        { "<C-o><C-t>", action_wrap_opentab },
        { "<C-o><C-v>", function() require("nvim-tree.api").node.open.vertical() end },
        { "<C-o><C-s>", function() require("nvim-tree.api").node.open.horizontal() end },

        { "<C-f>", function() return require("nvim-tree-preview").scroll(4) end },
        { "<C-b>", function() return require("nvim-tree-preview").scroll(-4) end },
        { "<TAB>", function()
          local PreviewManager = require("nvim-tree-preview.manager")
          if PreviewManager.instance and (PreviewManager.instance:is_valid() or PreviewManager.instance.manager.is_watching()) then
            PreviewManager.instance:close({ unwatch = true, focus_tree = true })
          else
            require("nvim-tree-preview").watch()
          end
        end },
      },
      hijack_cursor = false,
      disable_netrw = true,
      hijack_netrw = true,
      sync_root_with_cwd = true,
      select_prompts = false,
      view = {
        debounce_delay = 30,
        signcolumn = "no",
        width = 30,
      },
      renderer = {
        full_name = false,
        root_folder_label = false, -- ":~:s?$?/..?",
        hidden_display = "none", -- all, simple
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
        indent_width = 2, -- 1
        indent_markers = {
          enable = false,
          inline_arrows = false,
          -- icons = {
          --   corner = "▏",
          --   edge = "▏",
          --   item = "▏",
          --   bottom = " ",
          --   none = " ",
          -- },
        },
        decorators = {
          "Git",
          -- "Open",
          "Hidden",
          -- "Modified",
          "Bookmark",
          "Diagnostics",
          "Copied",
          "Cut",
        },
        highlight_git = "none",
        highlight_diagnostics = "none",
        highlight_opened_files = "none",
        highlight_modified = "none",
        highlight_hidden = "name",
        highlight_bookmarks = "name",
        highlight_clipboard = "name",
        icons = {
          git_placement = "right_align",
          modified_placement = "right_align",
          hidden_placement = "right_align",
          diagnostics_placement = "right_align",
          bookmarks_placement = "right_align",
          show = {
            modified = false,
            hidden = true,
            bookmarks = false,
          },
          web_devicons = {
            file = {
              enable = true,
              color = true,
            },
            folder = {
              enable = false,
              color = false,
            },
          },
          padding = " ",
          symlink_arrow = " " .. vim.__icons.arrow_right_3 .. " ",
          glyphs = {
            default = vim.__icons.file_1,
            hidden = "",
            bookmark = "", -- vim.__icons.bookmarks
            folder = {
              arrow_closed = vim.__icons.closepand,
              arrow_open = vim.__icons.expand,
              default = vim.__icons.directory,
              open = vim.__icons.directory_opened,
              empty = vim.__icons.empty_directory,
              empty_open = vim.__icons.empty_directory_opened,
            },
            git = {
              unstaged = vim.__icons.git_unstaged,
              staged = vim.__icons.git_staged,
              unmerged = vim.__icons.git_6,
              renamed = vim.__icons.git_renamed,
              untracked = vim.__icons.git_untracked,
              deleted = vim.__icons.git_delete,
              ignored = vim.__icons.git_ignored,
            },
          },
        },
      },
      hijack_directories = {
        enable = false,
        auto_open = false,
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
          hint = vim.__icons.diagnostic_hint,
          info = vim.__icons.diagnostic_info,
          warning = vim.__icons.diagnostic_warn,
          error = vim.__icons.diagnostic_err,
        },
      },
      git = {
        timeout = 1000, -- 400
      },
      filters = {
        git_ignored = false,
      },
      live_filter = {
        prefix = " " .. vim.__icons.search .. " ",
        always_show_folders = false,
      },
      filesystem_watchers = {
        ignore_dirs = { "/.ccls-cache", "/build", "/node_modules", "/target" }
      },
      actions = {
        expand_all = {
          max_folder_discovery = 300,
          exclude = {},
        },
        file_popup = {
          open_win_config = {
            border = vim.__icons.border.no,
          },
        },
        open_file = {
          resize_window = false,
          window_picker = {
            enable = true,
            picker = function(...) return require("window-picker").pick_window(...) end,
          },
        },
      },
      notify = {
        threshold = vim.log.levels.ERROR, -- disable unnecessary notify message i.e. delete file
      },
    },
    config = function(_, opts)
      local NvimTree      = require("nvim-tree")
      local NvimTreeAPI   = require("nvim-tree.api")
      local NvimTreeUtils = require("nvim-tree.utils")

      local keys = opts.keys
      opts.keys = nil

      NvimTree.setup(vim.__tbl.rr_extend(opts, {
        on_attach = function(bufnr)
          local keyopts = {
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }

          for _, spec in ipairs(keys) do
            vim.__key.rg(vim.__key.e_mode.N, spec[1], spec[2], keyopts)
          end
        end
      }))
      vim.__explorer = Module:new()

      -- 不显示行号
      NvimTreeAPI.events.subscribe(NvimTreeAPI.events.Event.TreeOpen, function()
        local winid = NvimTreeAPI.tree.winid()
        if winid ~= nil then
          vim.wo[winid].number = false
          vim.wo[winid].relativenumber = false
          vim.wo[winid].signcolumn = "no"
          vim.wo[winid].statuscolumn = ""
          vim.wo[winid].foldcolumn = "0"
        end
      end)

      -- 由用户控制 buffer 的删除逻辑
      NvimTreeAPI.events.subscribe(NvimTreeAPI.events.Event.FileRemoved, function(state)
        if not state or not state.fname then
          return
        end

        local bufnr = vim.__buf.number(state.fname)
        if bufnr <= 0 then
          return
        end

        vim.__buf.wipeout(bufnr)
      end)

      -- 1. 删除文件改名后 buffer-list 中遗留改名前的 buffer
      -- 2. advanced rename
      local prev_node = { new_name = "", old_name = "" }
      NvimTreeAPI.events.subscribe(NvimTreeAPI.events.Event.NodeRenamed, function(state)
        local bufnr = vim.__buf.number(state.old_name)
        if bufnr and bufnr > 0 then
          vim.__buf.wipeout(bufnr)
        end

        if prev_node.new_name ~= state.new_name or prev_node.old_name ~= state.old_name then
          prev_node = state
          require("snacks").rename.on_rename_file(state.old_name, state.new_name)
        end
      end)

      -- HACK: clear_prompt 函数在用于 ui.input 当中，奇怪的是，如果
      --       不强制刷新 stl，则会导致 mod 状态出现不正确的指示。
      local org_clear_prompt = NvimTreeUtils.clear_prompt
      NvimTreeUtils.clear_prompt = function(...)
        org_clear_prompt(...)
        vim.__stl.redraw(true)
      end
    end
  },
  {
    "nvim-tree/nvim-web-devicons",
    optional = true,
    opts = {
      override_by_filetype = {
        NvimTree = {
          icon = "󰙅",
          color = vim.__color.bright_green,
          name = "NvimTree"
        },
      }
    }
  },
}
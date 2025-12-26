return {
  {
    "nvim-tree/nvim-tree.lua",
    main = "nvim-tree",
    lazy = true,
    dispatchs = {
      {
        "explorer",
        function(this)
          local NvimTreeAPI = vim.__lazy.require("nvim-tree.api")
          function this:toggle(opts)
            NvimTreeAPI.tree.toggle(opts)
          end
        end
      }
    },
    dependencies = {
      {
        "ngpong/nvim-tree-preview.lua",
        opts = {
          min_width = 50,
          min_height = 30,
          max_width = 120,
          max_height = 120,
          border = vim.__icons.border.no_but_title,
          zindex = 999,
          show_title = true,
          title_pos = "top-center",
          title_format = " %s ",
          wo = {
            statuscolumn = "  %=%{v:virtnum < 1 ? v:lnum : ''}%=%s",
            signcolumn = "yes:1",
            numberwidth = 5,
            relativenumber = false,
            wrap = true,
            showbreak = "➥►",
            winhighlight = table.concat({
              "Normal:NvimTreePreviewNormalFloat",
              "SignColumn:NvimTreePreviewSignColumn",
              "FloatBorder:NvimTreePreviewFloatBorder",
            }, ","),
            cursorline = false,
          },
        }
      }
    },
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile", "NvimTreeCollapse" },
    highlights = {
      { "NvimTreeIndentMarker", link = "IndentGuide" },
      { "NvimTreeFolderArrowClosed", fg = vim.__color.light4 },
      { "NvimTreeFolderArrowOpen", fg = vim.__color.light4 },
      { "NvimTreeFolderIcon", link = "DirectoryIcon" },
      { "NvimTreeHiddenFileHL", fg = vim.__color.dark2 },
      { "NvimTreeBookmarkIcon", fg = vim.__color.bright_aqua },
      { "NvimTreeBookmarkHL", bold = true, fg = vim.__color.bright_aqua },
      { "NvimTreeCutHL", bold = true, fg = vim.__color.bright_red },
      { "NvimTreeCopiedHL", bold = true, fg = vim.__color.bright_yellow },
      { "NvimTreeNormal", bg = vim.__color.dark0_hard, fg = vim.__color.light2 },
      { "NvimTreeWinSeparator", fg = vim.__color.dark0 },
      { "NvimTreeEndOfBuffer", fg = vim.__color.dark0_hard },
      { "NvimTreeCursorLine", link = "CursorLineDark" },

      { "NvimTreePreviewNormalFloat", bg = vim.__color.dark0_hard },
      { "NvimTreePreviewFloatBorder", bg = vim.__color.dark0_hard, fg = vim.__color.dark0_hard },
      { "NvimTreePreviewSignColumn", bg = vim.__color.dark0_hard },
    },
    keys = {
      { "<leader>e", function() vim.__explorer:toggle() end }
    },
    opts = {
      keys = {
        {
          "q",
          function()
            local PreviewManager = require("nvim-tree-preview.manager")
            if PreviewManager.instance and PreviewManager.instance:is_valid() then
              PreviewManager.instance:close({ unwatch = true, focus_tree = true })
            end

            require("nvim-tree.api").tree.close()
          end
        },
        { "=", function() vim.__win.resize_op("NvimTreeResize +") end },
        { "-", function() vim.__win.resize_op("NvimTreeResize -") end },
        { "<C-r>", function() require("nvim-tree.api").tree.reload() end },
        { "<2-LeftMouse>",  function() require("nvim-tree.api").node.open.edit() end },
        { "<2-RightMouse>", function() require("nvim-tree.api").tree.change_root_to_node() end },

        { "E", function() require("nvim-tree.api").tree.expand_all() end },
        { "W", function() require("nvim-tree.api").tree.collapse_all() end },

        { "i", function() require("nvim-tree.api").node.show_info_popup() end },
        { ".", function() require("nvim-tree.api").node.run.cmd() end },
        { "}", function() require("nvim-tree.api").node.navigate.sibling.last() end },
        { "{", function() require("nvim-tree.api").node.navigate.sibling.first() end },
        { ">", function() require("nvim-tree.api").node.navigate.sibling.next() end },
        { "<", function() require("nvim-tree.api").node.navigate.sibling.prev() end },

        { "F", function() require("nvim-tree.api").marks.clear() end, },
        { "ff", function() require("nvim-tree.api").marks.toggle() end, },
        { "fd", function() require("nvim-tree.api").marks.bulk.delete() end, },
        { "fm", function() require("nvim-tree.api").marks.bulk.move() end, },
        {
          "fp",
          function()
            local NvimTreeAPI = require("nvim-tree.api")

            local marked_nodes = NvimTreeAPI.marks.list()
            if next(marked_nodes) == nil then
              vim.__echo.warn("No nodes are marked to paste")
            else
              for _, node in ipairs(marked_nodes) do
                NvimTreeAPI.fs.copy.node(node)
                NvimTreeAPI.fs.paste(NvimTreeAPI.tree.get_node_under_cursor())
              end
              NvimTreeAPI.marks.clear()
              NvimTreeAPI.fs.clear_clipboard()
            end
          end
        },

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

        { "<BS>", function() require("nvim-tree.api").node.navigate.parent_close() end },
        { "<CR>", function() require("nvim-tree.api").node.open.edit() end },
        { "<C-o>", "<NOP>" },
        { "<C-i>", "<NOP>" },
        { "O", function() require("nvim-tree.api").node.navigate.parent_close() end },
        { "o", function() require("nvim-tree.api").node.open.edit() end },
        { "<C-o>v", function() require("nvim-tree.api").node.open.vertical() end },
        { "<C-o>s", function() require("nvim-tree.api").node.open.horizontal() end },
        { "<C-o><C-v>", function() require("nvim-tree.api").node.open.vertical() end },
        { "<C-o><C-s>", function() require("nvim-tree.api").node.open.horizontal() end },

        { "<C-e>", function() return require("nvim-tree-preview").scroll(8) end },
        { "<C-y>", function() return require("nvim-tree-preview").scroll(-8) end },
        {
          "<C-g>",
          function()
            local PreviewManager = require("nvim-tree-preview.manager")
            if PreviewManager.instance and (PreviewManager.instance:is_valid() or PreviewManager.instance.manager.is_watching()) then
              PreviewManager.instance:close({ unwatch = true, focus_tree = true })
            else
              require("nvim-tree-preview").watch()
            end
          end
        },
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
            bookmarks = true,
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
      -- 因为性能问题，暂时禁用掉 diagnostic 和 git；git 可能是最终祸首
      diagnostics = {
        enable = false,
        show_on_dirs = true,
        icons = {
          hint = vim.__icons.diagnostic_hint,
          info = vim.__icons.diagnostic_info,
          warning = vim.__icons.diagnostic_warn,
          error = vim.__icons.diagnostic_error,
        },
      },
      git = {
        enable = false,
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
            border = vim.__icons.border.raw_no,
          },
        },
        open_file = {
          resize_window = false,
          window_picker = {
            enable = false,
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
      local NvimTreeEvent = NvimTreeAPI.events

      local keys = opts.keys
      opts.keys = nil
      opts.on_attach = function(bufnr)
        local keyopts = {
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
        }

        for _, spec in ipairs(keys) do
          vim.__key.rg("n", spec[1], spec[2], keyopts)
        end
      end

      NvimTree.setup(opts)

      -- 不显示行号
      NvimTreeEvent.subscribe(NvimTreeEvent.Event.TreeOpen, function()
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
      NvimTreeEvent.subscribe(NvimTreeEvent.Event.FileRemoved, function(state)
        local bufnr = vim.__buf.number(state.fname)
        if bufnr <= 0 then
          return
        end

        vim.__buf.wipeout(bufnr)
      end)

      -- 删除文件改名后 buffer-list 中遗留改名前的 buffer
      NvimTreeEvent.subscribe(NvimTreeEvent.Event.NodeRenamed, function(state)
        local bufnr = vim.__buf.number(state.old_name)
        if bufnr and bufnr > 0 then
          vim.__buf.wipeout(bufnr)
        end
      end)
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

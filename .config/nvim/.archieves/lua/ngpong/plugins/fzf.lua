--                                                                                 hl,fg,bg                                                       
--                                                 header                             ▲                                                           
--            prompt                                 ▲      border                    │        spinner                                            
--              ▲                                    │        ▲                       │           ▲         ┌──────────────────────────┐          
--              │                                    │        │                       │           │         │                          │          
--             ┌┼┬───────────────────────────────────┼────────┴───────────────────────┼───────────┼───┬─────┴───────┐                  │          
--             │>│editor                             │                                │           ⠴   │442/21489 (0)│                  │          
--             ├─┴───────────────────────────────────┼────────────────────────────────┼───────────────┴─────────────┘                  │          
--             │  :: <ctrl-g> to Respect .gitignore──┘                                │                             │                  │          
-- pointer ◄───┼▌  .editorconfig ──────────►                                         │                            ┃┼───► scrollbar    │          
--             │ ┌────────────────────────────────────────────────────────────────────┴────────────────────────┐    │                  │          
--             │ │ dep/efsw/src/efsw/DirectorySnapshot.cpp                                                    │    │                  ├────► info
--  gutter ◄───┼─│ dep/efsw/src/efsw/DirectorySnapshotDiff.hpp                                                │    │                  │          
--             │ │ dep/fsw/src/efsw/DirectorySnapshotDiff.cpp                                                 │    │                  │          
--             │ │ cmake/compiler/msvc/Directory.Build.props                                                  │    │                  │          
--             │ │ src/server/shared/DataStores/DBStorageIterator.h                                           │    │                  │          
--  marker ◄───┼┃│ sql/old/10.x/world/24021_2024_05_11/2024_03_18_04_world_hallows_end_orgrimmar_stormwind.sql│    │                  │          
--             │┃│ dep/CascLib/src/common/Directory.h                                                         │    │                  │          
--             │ └─────────────────────────────────────────────────────────────────────────────────────────────┘    │                  │          
--             │┌───────────────────────────────────────────────────────────────────────────────────────────┬──────┐│                  │          
--             ││    1   [*]                                                                                │ 1/11 ├┼──────────────────┘          
--             ││    2   charset = utf-8                                                                    └──────┤│                             
--             ││    3   indent_size = 4                                                                           ││                             
--             ││    4   tab_width = 4                                                                             ││                             
--             ││    5   indent_style = space                                                                      ││                             
--             ││    6   insert_final_newline = true                                                               ││                             
--             ││    7   trim_trailing_whitespace = true                                                           ││                             
--             │└──────────────────────────────────────────────────────────────────────────────────────────────────┘│                             
--             └────────────────────────────────────────────────────────────────────────────────────────────────────┘                             

return {
  {
    "ibhagwan/fzf-lua",
    root = true,
    lazy = true,
    cmd = "FzfLua",
  },
  {
    "ibhagwan/fzf-lua",
    init = function()
      local min_h, max_h = 0.15, 0.70
      local min_w, max_w = 0.05, 0.70

      local function autosize(ui_opts, items)
        if ui_opts.kind == "codeaction" then
          return
        end

        local h = (#items + 2) / vim.o.lines
        if h < min_h then
          h = min_h
        elseif h > max_h then
          h = max_h
        end

        local longest = ui_opts.prompt and ui_opts.prompt:len() or 0
        for i, e in ipairs(items) do
          local format_entry = ui_opts.format_item and ui_opts.format_item(e) or tostring(e)
          local length = tostring(format_entry):len()
          if length > longest then
            longest = length
          end
        end

        local w = (longest + 14) / vim.o.columns
        if w < min_w then
          w = min_w
        elseif w > max_w then
          w = max_w
        end

        return h, w
      end

      vim.ui.select = function(...)
        require("fzf-lua").register_ui_select(function(ui_opts, items)
          local h, w = autosize(ui_opts, items)
          return {
            winopts = {
              split = "belowright new",
              height = h,
              width = w,
              title = "",
            },
            fzf_opts = {
              ["--layout"] = "reverse-list",
              ["--info"] = "hidden",
            },
          }
        end)
        return vim.ui.select(...)
      end
    end,
  },
  {
    "ibhagwan/fzf-lua",
    highlights = {
      -- global
      { "FzfLuaNormal", bg = vim.__color.dark0_hard },
      { "FzfLuaBorder", bg = vim.__color.dark0_hard, fg = vim.__color.dark0_hard },
      { "FzfLuaTitle", bg = vim.__color.bright_aqua, fg = vim.__color.dark0_soft, italic = true },
      { "FzfLuaDirIcon", link = "DirectoryIcon" },
      { "dir_part", bg = vim.__color.bright_yellow },

      -- preview
      { "FzfLuaPreviewNormal", bg = vim.__color.dark0_hard },
      { "FzfLuaPreviewBorder", bg = vim.__color.dark0_hard, fg = vim.__color.dark0 },
      { "FzfLuaPreviewTitle", bg = vim.__color.bright_yellow, fg = vim.__color.dark0_soft, italic = true },

      -- header consist of fzf_colors.header
      { "FzfLuaHeaderText", fg = vim.__color.dark4 },
      { "FzfLuaHeaderBind", fg = vim.__color.dark4 },

      -- picker
      -- tabs
      { "FzfLuaTabTitle", fg = vim.__color.bright_aqua },
      { "FzfLuaTabMarker", fg = vim.__color.bright_aqua },
      { "FzfLuaBufId", fg = vim.__color.dark4 },
    },
    opts = {
      fzf_colors = {
        ["border"]    = vim.__color.dark2,
        ["scrollbar"] = vim.__color.dark3,
        ["pointer"]   = vim.__color.bright_red,
        ["prompt"]    = vim.__color.bright_blue,
        ["info"]      = vim.__color.dark2,
        ["spinner"]   = vim.__color.dark2,
        ["gutter"]    = vim.__color.dark0_hard,
        ["marker"]    = vim.__color.bright_red,
        ["header"]    = vim.__color.dark4,
        ["hl"]        = vim.__color.bright_red .. ":bold:italic:underline",
        ["fg"]        = -1,
        ["bg"]        = -1,
        ["hl+"]       = vim.__color.bright_red .. ":bold:italic:underline",
        ["fg+"]       = vim.__color.light1,
        ["bg+"]       = vim.__color.dark0,
      },
    }
  },
  {
    "ibhagwan/fzf-lua",
    opts = {
      file_icon_padding = "",
      winopts = {
        -- split = "aboveleft new", -- belowright new, aboveleft new, belowright vnew, aboveleft vnew
        height = 0.8,
        width = 0.85,
        row = 0.50, -- x
        col = 0.50, -- y
        backdrop = false,
        border = vim.__icons.border.no_but_title,
        preview = {
          delay = 50,
          default = "bat", -- bat/cat/builtin
          wrap = "nowrap", -- wrap|nowrap
          hidden = "hidden", -- hidden|nohidden; need hidden by default?
          vertical = "down:50%", -- up|down:size
          horizontal = "right:50%", -- right|left:size
          layout = "vertical", -- horizontal|vertical|flex
          -- only work for builtin previewer
          border = vim.__icons.border.top,
          title = false,
        },
        on_create = function()
          vim.__g.guicursor = vim.go.guicursor
          vim.go.guicursor = "t:block"
        end,
        on_close = function()
          vim.go.guicursor = vim.__g.guicursor
          vim.__g.guicursor = nil
        end,
      },
      fzf_opts = {
        ["--ansi"] = true,
        ["--info"] = "inline: ", -- inline-right
        ["--height"] = "100%",
        -- display from the top of the screen
        ["--layout"] = "reverse",
        -- draw border around the finder
        ["--border"] = "none",
        -- draw border around the previewer
        -- ["--preview-border"] = "top",
        -- highlight the whole current line
        ["--highlight-line"] = true,
        -- scrollbar char
        ["--scrollbar"] = "┃",
        -- enable cyclic scroll
        ["--cycle"] = true,
        --  v2: Optimal scoring algorithm (quality)
        --  v1: Faster but not guaranteed to find the optimal result (performance)
        ["--algo"] = "v1",
        -- number of screen lines to keep above or below when scrolling to the top or to the bottom
        ["--scroll-off"] = 0,
        -- keep the right end of the line visible when it's too long
        ["--keep-right"] = false,
      },
      previewers = {
        -- bat 是一个很好的 previewer，但是存在性能问题
        bat = {
          cmd = "bat",
          args = {
            ["--wrap"] = "never",
            ["--color"] = "always",
            ["--style"] = "numbers,changes",
          },
          theme = "gruvbox (Dark) (Hard) NDC", -- bat cache --build; bat --list-themes
        },
      },
      defaults = {
        prompt = " " .. vim.__icons.search .. " ",
        multiprocess = true,
        git_icons = false,
        file_icons = "devicons",
        color_icons = true,
        dir_icon = vim.__icons.directory,
        path_shorten = false, -- 'true' or number, shorten path?
        cwd_header = false,
        cwd_prompt = false,
      },
      files = {
        winopts = {
          title = " FILES ",
        },
        -- priority: cmd(if set), fd, rg, find
        fd_opts = {
          ["--color"] = "never",
          ["--hidden"] = true,
          ["--follow"] = true,
          ["--no-ignore-vcs"] = true,
          ["--type"] = "file"
        },
        toggle_ignore_flag = "--no-ignore", -- flag toggled in `actions.toggle_ignore`
        toggle_hidden_flag = "--hidden",    -- flag toggled in `actions.toggle_hidden`
      },
      grep = {
        previewer = false,
        fzf_opts = {
          ["--delimiter"] = ":",
          ["--preview-window"] = "wrap,down:50%,+{2}-/2",
          ["--preview"] = {
            type = "cmd",
            fn = function(items)
              local path = require "fzf-lua.path"
              local entry = path.entry_to_file(items[1], {})
              return string.format("clp -h %d %s", entry.line, entry.path)
            end
          }
        },
        rg_opts = "--color=always --column --line-number --no-heading --hidden --with-filename --no-ignore-vcs --smart-case --max-columns=4096 -e",
        -- custom flags
        -- foo -- --word-regexp --glob="*.lua"
        rg_glob = true,
        rg_glob_fn = function(query, opts)
          local regex, flags = query:match("^(.-)" .. opts.glob_separator .. "(.*)$")
          return (regex or query), flags
        end,
        -- Enable with narrow term width, split results to multiple lines
        -- NOTE: multiline requires fzf >= v0.53 and is ignored otherwise
        -- multiline = 1,      -- Display as: PATH:LINE:COL\nTEXT
        -- multiline = 2,      -- Display as: PATH:LINE:COL\nTEXT\n
        no_header = false,    -- hide grep|cwd header?
        no_header_i = false,    -- hide interactive header?
        live_ast_prefix = true,
        winopts = {
          title = " GREP ",
          treesitter = false, -- only support grep ts highlight for now, so we disable both with consistence
        },
      },
      args = {
        files_only        = true,
      },
      oldfiles = {
        cwd_only          = false,
        stat_file         = true,         -- verify files exist on disk
        -- can also be a lua function, for example:
        -- stat_file = require("fzf-lua").utils.file_is_readable,
        -- stat_file = function() return true end,
        include_current_session = false,  -- include bufs from current session
      },
      buffers = {
        file_icons        = true,         -- show file icons (true|"devicons"|"mini")?
        color_icons       = true,         -- colorize file|git icons
        sort_lastused     = true,         -- sort buffers() by last used
        show_unloaded     = true,         -- show unloaded buffers
        cwd_only          = false,        -- buffers for the cwd only
        cwd               = nil,          -- buffers list for a given dir
      },
      tabs = {
        tab_title         = "Tab",
        tab_marker        = "<<",
        file_icons        = true,         -- show file icons (true|"devicons"|"mini")?
        color_icons       = true,         -- colorize file|git icons
        fzf_opts = {
          -- hide tabnr
          ["--delimiter"] = "[\\):]",
          ["--with-nth"]  = "2..",
        },
      },
      lines = {
        file_icons = true,
        show_bufname = true,
        show_unloaded = false,
        show_unlisted = false,
        no_term_buffers = true,
        sort_lastused = true,
        winopts = {
          title = " LINES ",
        },
      },
      blines = {
        file_icons = true,
        show_unloaded = false,
        show_unlisted = false,
        no_term_buffers = true,
        sort_lastused = true,
        winopts = {
          title = " BUFFER-LINES ",
        },
      },
      tags = {
        ctags_file            = nil,      -- auto-detect from tags-option
        multiprocess          = true,
        file_icons            = true,
        git_icons             = true,
        color_icons           = true,
        -- 'tags_live_grep' options, `rg` prioritizes over `grep`
        rg_opts               = "--no-heading --color=always --smart-case",
        grep_opts             = "--color=auto --perl-regexp",
        fzf_opts              = { ["--tiebreak"] = "begin" },
        no_header             = false,    -- hide grep|cwd header?
        no_header_i           = false,    -- hide interactive header?
      },
      btags = {
        ctags_file            = nil,      -- auto-detect from tags-option
        ctags_autogen         = true,     -- dynamically generate ctags each call
        multiprocess          = true,
        file_icons            = false,
        git_icons             = false,
        rg_opts               = "--color=never --no-heading",
        grep_opts             = "--color=never --perl-regexp",
        fzf_opts              = { ["--tiebreak"] = "begin" },
      },
      colorschemes = {
        live_preview      = true,       -- apply the colorscheme on preview?
        winopts           = { height = 0.55, width = 0.30, },
        -- uncomment to ignore colorschemes names (lua patterns)
        -- ignore_patterns   = { "^delek$", "^blue$" },
        -- uncomment to execute a callback on preview|close
        -- e.g. a call to reset statusline highlights
        -- cb_preview        = function() ... end,
        -- cb_exit           = function() ... end,
      },
      awesome_colorschemes = {
        live_preview      = true,       -- apply the colorscheme on preview?
        max_threads       = 5,          -- max download/update threads
        winopts           = { row = 0, col = 0.99, width = 0.50 },
        fzf_opts          = {
          ["--multi"]     = true,
          ["--delimiter"] = "[:]",
          ["--with-nth"]  = "3..",
          ["--tiebreak"]  = "index",
        },
        -- uncomment to execute a callback on preview|close
        -- cb_preview        = function() ... end,
        -- cb_exit           = function() ... end,
      },
      keymaps = {
        winopts           = { preview = { layout = "vertical" } },
        fzf_opts          = { ["--tiebreak"] = "index", },
        -- by default, we ignore <Plug> and <SNR> mappings
        -- set `ignore_patterns = false` to disable filtering
        ignore_patterns   = { "^<SNR>", "^<Plug>" },
      },
      quickfix = {
        file_icons        = true,
        git_icons         = true,
        only_valid        = false, -- select among only the valid quickfix entries
      },
      quickfix_stack = {
        prompt = "Quickfix Stack> ",
        marker = ">",                   -- current list marker
      },
      lsp = {
        prompt_postfix    = "❯ ",       -- will be appended to the LSP label
                                        -- to override use 'prompt' instead
        cwd_only          = false,      -- LSP/diagnostics for cwd only?
        async_or_timeout  = 5000,       -- timeout(ms) or 'true' for async calls
        file_icons        = true,
        git_icons         = false,
        -- The equivalent of using `includeDeclaration` in lsp buf calls, e.g:
        -- :lua vim.lsp.buf.references({includeDeclaration = false})
        includeDeclaration = true,      -- include current declaration in LSP context
        -- settings for 'lsp_{document|workspace|lsp_live_workspace}_symbols'
        symbols = {
          async_or_timeout  = true,       -- symbols are async by default
          symbol_style      = 1,          -- style for document/workspace symbols
                                          -- false: disable,    1: icon+kind
                                          --     2: icon only,  3: kind only
                                          -- NOTE: icons are extracted from
                                          -- vim.lsp.protocol.CompletionItemKind
          -- icons for symbol kind
          -- see https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
          -- see https://github.com/neovim/neovim/blob/829d92eca3d72a701adc6e6aa17ccd9fe2082479/runtime/lua/vim/lsp/protocol.lua#L117
          symbol_icons     = {
            File          = "󰈙",
            Module        = "",
            Namespace     = "󰦮",
            Package       = "",
            Class         = "󰆧",
            Method        = "󰊕",
            Property      = "",
            Field         = "",
            Constructor   = "",
            Enum          = "",
            Interface     = "",
            Function      = "󰊕",
            Variable      = "󰀫",
            Constant      = "󰏿",
            String        = "",
            Number        = "󰎠",
            Boolean       = "󰨙",
            Array         = "󱡠",
            Object        = "",
            Key           = "󰌋",
            Null          = "󰟢",
            EnumMember    = "",
            Struct        = "󰆼",
            Event         = "",
            Operator      = "󰆕",
            TypeParameter = "󰗴",
          },
          -- colorize using Treesitter '@' highlight groups ("@function", etc).
          -- or 'false' to disable highlighting
          symbol_hl         = function(s) return "@" .. s:lower() end,
          -- additional symbol formatting, works with or without style
          symbol_fmt        = function(s, opts) return "[" .. s .. "]" end,
          -- prefix child symbols. set to any string or `false` to disable
          child_prefix      = true,
          fzf_opts          = { ["--tiebreak"] = "begin" },
        },
        code_actions = {
          previewer = "codeaction_native", -- require git-delta
          winopts = {
            preview = {
              layout = "horizontal", -- horizontal|vertical|flex
            },
          }
        },
        finder = {
            file_icons  = true,
            color_icons = true,
            git_icons   = false,
            async       = true,         -- async by default
            silent      = true,         -- suppress "not found" 
            separator   = "| ",         -- separator after provider prefix, `false` to disable
            includeDeclaration = true,  -- include current declaration in LSP context
            -- by default display all LSP locations
            -- to customize, duplicate table and delete unwanted providers
            -- providers   = {
            --     { "references",      prefix = require("fzf-lua").utils.ansi_codes.blue("ref ") },
            --     { "definitions",     prefix = require("fzf-lua").utils.ansi_codes.green("def ") },
            --     { "declarations",    prefix = require("fzf-lua").utils.ansi_codes.magenta("decl") },
            --     { "typedefs",        prefix = require("fzf-lua").utils.ansi_codes.red("tdef") },
            --     { "implementations", prefix = require("fzf-lua").utils.ansi_codes.green("impl") },
            --     { "incoming_calls",  prefix = require("fzf-lua").utils.ansi_codes.cyan("in  ") },
            --     { "outgoing_calls",  prefix = require("fzf-lua").utils.ansi_codes.yellow("out ") },
            -- },
        }
      },
      diagnostics ={
        cwd_only          = false,
        file_icons        = true,
        git_icons         = false,
        diag_icons        = true,
        diag_source       = true,   -- display diag source (e.g. [pycodestyle])
        icon_padding      = "",     -- add padding for wide diagnostics signs
        multiline         = true,   -- concatenate multi-line diags into a single line
                                    -- set to `false` to display the first line only
        -- by default icons and highlights are extracted from 'DiagnosticSignXXX'
        -- and highlighted by a highlight group of the same name (which is usually
        -- set by your colorscheme, for more info see:
        --   :help DiagnosticSignHint'
        --   :help hl-DiagnosticSignHint'
        -- only uncomment below if you wish to override the signs/highlights
        -- define only text, texthl or both (':help sign_define()' for more info)
        -- signs = {
        --   ["Error"] = { text = "", texthl = "DiagnosticError" },
        --   ["Warn"]  = { text = "", texthl = "DiagnosticWarn" },
        --   ["Info"]  = { text = "", texthl = "DiagnosticInfo" },
        --   ["Hint"]  = { text = "󰌵", texthl = "DiagnosticHint" },
        -- },
        -- limit to specific severity, use either a string or num:
        --   1 or "hint"
        --   2 or "information"
        --   3 or "warning"
        --   4 or "error"
        -- severity_only:   keep any matching exact severity
        -- severity_limit:  keep any equal or more severe (lower)
        -- severity_bound:  keep any equal or less severe (higher)
      },
      marks = {
        marks = "", -- filter vim marks with a lua pattern
        -- for example if you want to only show user defined marks
        -- you would set this option as %a this would match characters from [A-Za-z]
        -- or if you want to show only numbers you would set the pattern to %d (0-9).
      },
      complete_path = {
        cmd          = nil, -- default: auto detect fd|rg|find
      },
      complete_file = {
        cmd          = nil, -- default: auto detect rg|fd|find
        file_icons   = true,
        color_icons  = true,
        git_icons    = false,
        -- previewer hidden by default
        winopts      = { preview = { hidden = "hidden" } },
      },
      -- uncomment to use fzf native previewers
      -- (instead of using a neovim floating window)
      -- manpages = { previewer = "man_native" },
      -- helptags = { previewer = "help_native" },
    },
    config = function(_, opts)
      local function normalize_args(args)
        local strs = {}
        for k, v in pairs(args) do
          table.insert(strs, v == true and k or string.format("%s=%s", k, v))
        end
        return table.concat(strs, " ")
      end

      opts.files.fd_opts = normalize_args(opts.files.fd_opts)
      opts.previewers.bat.args = normalize_args(opts.previewers.bat.args)

      require("fzf-lua").setup(opts)
    end
  },
  {
    "nvim-tree/nvim-web-devicons",
    optional = true,
    opts = {
      override_by_filetype = {
        fzf = {
          icon = "",
          color = vim.__color.dark4,
          name = "Fzf"
        },
      }
    }
  },
}
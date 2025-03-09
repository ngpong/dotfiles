return {
  {
    "ibhagwan/fzf-lua",
    enabled = true,
    lazy = true,
    cmd = "FzfLua",
    highlights = {
      --                                                                                 hl,fg,bg                                                       
      --                                                 header                             ▲                                                           
      --            prompt                                 ▲      border                    │        spinner                                            
      --              ▲                                    │        ▲                       │           ▲         ┌──────────────────────────┐          
      --              │                                    │        │                       │           │         │                          │          
      --             ┌┴┬───────────────────────────────────┼────────┴───────────────────────┼───────────┼───┬─────┴───────┐                  │          
      --             │>│editor                             │                                │           ⠴   │442/21489 (0)│                  │          
      --             ├─┴───────────────────────────────────┼────────────────────────────────┼───────────────┴─────────────┘                  │          
      --             │  :: <ctrl-g> to Respect .gitignore──┘                                │                             │                  │          
      -- pointer ◄───┼▌  .editorconfig ──────────►                                         │                            ┃┼───► scrollbar    │          
      --             │ ┌────────────────────────────────────────────────────────────────────┴────────────────────────┐    │                  │          
      --             │ │ dep/efsw/src/efsw/DirectorySnapshot.cpp                                                    │    │                  ├────► info
      --  gutter ◄───┼─│ dep/efsw/src/efsw/DirectorySnapshotDiff.hpp                                                │    │                  │          
      --             │ │ dep/▼fsw/src/efsw/DirectorySnapshotDiff.cpp                                                │    │                  │          
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

      -- global
      { "FzfLuaNormal", link = "NormalFloat" },
      { "FzfLuaBorder", link = "FloatBorder" },
      { "FzfLuaTitle", bg = vim.__color.bright_aqua, fg = vim.__color.dark0_soft, italic = true },
      { "FzfLuaBackdrop", link = "Normal" },

      -- preview
      { "FzfLuaPreviewNormal", link = "Normal" },
      { "FzfLuaPreviewBorder", link = "Normal" },
      { "FzfLuaPreviewTitle", bg = vim.__color.bright_yellow, fg = vim.__color.dark0_soft, italic = true },

      -- header consist of fzf_colors.header
      { "FzfLuaHeaderText", fg = vim.__color.dark4 },
      { "FzfLuaHeaderBind", fg = vim.__color.dark4 },

      -- picker
      -- tabs
      { "FzfLuaTabTitle", fg = vim.__color.bright_aqua },
      { "FzfLuaTabMarker", fg = vim.__color.bright_aqua },
    },
    opts = {
      fzf_colors = {
        ["border"]    = vim.__color.dark2,
        ["scrollbar"] = vim.__color.dark4,
        ["pointer"]   = vim.__color.bright_red,
        ["prompt"]    = vim.__color.bright_blue .. ":italic",
        ["info"]      = vim.__color.dark2,
        ["spinner"]   = vim.__color.dark2,
        ["gutter"]    = vim.__color.dark0_soft,
        ["marker"]    = vim.__color.bright_red,
        ["header"]    = vim.__color.dark4,
        ["hl"]        = vim.__color.bright_red .. ":bold:italic:underline",
        ["fg"]        = -1,
        ["bg"]        = -1,
        ["hl+"]       = vim.__color.bright_red .. ":bold:italic:underline",
        ["fg+"]       = vim.__color.light1,
        ["bg+"]       = "#363332",
      },
      winopts = {
        -- split = "aboveleft new", -- belowright new, aboveleft new, belowright vnew, aboveleft vnew
        height = 0.85,
        width = 0.85,
        row = 0.50, -- x
        col = 0.50, -- y
        backdrop = 100,
        border = vim.__icons.border.yes,
        title = "",
        title_pos = "center", -- left, center, right
        preview = {
          default = "bat", -- bat/cat/builtin
          wrap = "nowrap", -- wrap|nowrap
          hidden = "hidden", -- hidden|nohidden; need hidden by default?
          vertical = "down:45%", -- up|down:size
          horizontal = "right:55%", -- right|left:size
          layout = "horizontal", -- horizontal|vertical|flex
          flip_columns = 120, -- #cols to switch to horizontal on flex
        },
        -- on_create = function() end
        -- on_close = function() end
      },
      fzf_opts = {
        ["--ansi"]           = true,
        ["--info"]           = "inline-right",
        ["--height"]         = "100%",
        ["--layout"]         = "reverse", -- display from the top of the screen
        ["--border"]         = "none",    -- draw border around the finder
        ["--highlight-line"] = true,      -- highlight the whole current line
        ["--scrollbar"]      = "┃",       -- scrollbar char
        ["--cycle"]          = true,      -- enable cyclic scroll
        ["--algo"]           = "v1",      -- fuzzy matching algorithm
                                          --  v2: Optimal scoring algorithm (quality)
                                          --  v1: Faster but not guaranteed to find the optimal result (performance)
        ["--scroll-off"]     = 0,         -- number of screen lines to keep above or below when scrolling to the top or to the bottom
        ["--keep-right"]     = false,
      },
      previewers = {
        -- builtin, cat, bat, head, git_diff, man, codeaction, codeaction_native
        bat = {
          cmd = "bat",
          args = "--color=always --style=numbers,changes",
          theme = "gruvbox (Dark) (Medium)", -- bat --list-themes
        },
      },
      defaults = {
        prompt       = " " .. vim.__icons.search .. " ",
        multiprocess = true,
        git_icons    = false,
        file_icons   = "devicons",
        color_icons  = true,
        path_shorten = false, -- 'true' or number, shorten path?
        -- formatter = "path.filename_first", -- "fzf-lua/previewer/fzf.lua" => "fzf.lua previewer/fzf-lua"
        cwd_header = false,
        cwd_prompt = false,
        cwd_prompt_shorten_len = 32,        -- shorten prompt beyond this length
        cwd_prompt_shorten_val = 1,         -- shortened path parts length
      },
      files = {
        winopts = {
          title = " FILES ",
        },
        -- priority: cmd(if set), fd, rg, find
        rg_opts = "--color=never --files --hidden --follow --no-ignore-vcs",
        -- fd 本身并不附带原生排序的选项，还需要借助管道等工具来实现。
        -- 如果需要排序，不管是 rg 还是 fd 也好，必定会走某个节点回退到单线程运行，或许不排序是一种更好的选择。
        fd_opts = "--color=never --type f --hidden --follow --no-ignore-vcs",
        toggle_ignore_flag = "--no-ignore", -- flag toggled in `actions.toggle_ignore`
        toggle_hidden_flag = "--hidden",    -- flag toggled in `actions.toggle_hidden`
      },
      grep = {
        rg_opts = "--column --line-number --no-heading --hidden --with-filename --no-ignore-vcs --color=always --smart-case --max-columns=4096 -e",

        -- custom flags
        -- foo -- --word-regexp --glob="*.lua"
        rg_glob = true,
        rg_glob_fn = function(query, opts)
          local regex, flags = query:match("^(.-)" .. opts.glob_separator .. "(.*)$")
          return (regex or query), flags
        end,

        -- Enable with narrow term width, split results to multiple lines
        -- NOTE: multiline requires fzf >= v0.53 and is ignored otherwise
        -- multiline      = 1,      -- Display as: PATH:LINE:COL\nTEXT
        -- multiline      = 2,      -- Display as: PATH:LINE:COL\nTEXT\n
        no_header             = false,    -- hide grep|cwd header?
        no_header_i           = false,    -- hide interactive header?
        live_ast_prefix       = true,
        winopts = {
          title = " GREP ",
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
        previewer         = "builtin",    -- set to 'false' to disable
        show_unloaded     = true,         -- show unloaded buffers
        show_unlisted     = false,        -- exclude 'help' buffers
        no_term_buffers   = true,         -- exclude 'term' buffers
        fzf_opts = {
          -- do not include bufnr in fuzzy matching
          -- tiebreak by line no.
          ["--delimiter"] = "[\\]:]",
          ["--nth"]       = "2..",
          ["--tiebreak"]  = "index",
          ["--tabstop"]   = "1",
        },
      },
      blines = {
        previewer         = "builtin",    -- set to 'false' to disable
        show_unlisted     = true,         -- include 'help' buffers
        no_term_buffers   = false,        -- include 'term' buffers
        -- start          = "cursor"      -- start display from cursor?
        fzf_opts = {
          -- hide filename, tiebreak by line no.
          ["--delimiter"] = "[:]",
          ["--with-nth"]  = "2..",
          ["--tiebreak"]  = "index",
          ["--tabstop"]   = "1",
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
            async_or_timeout  = 5000,
            -- when git-delta is installed use "codeaction_native" for beautiful diffs
            -- try it out with `:FzfLua lsp_code_actions previewer=codeaction_native`
            -- scroll up to `previewers.codeaction{_native}` for more previewer options
            previewer        = "codeaction",
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
      -- 
      -- padding can help kitty term users with double-width icon rendering
      file_icon_padding = "",
      -- uncomment if your terminal/font does not support unicode character
      -- "EN SPACE" (U+2002), the below sets it to "NBSP" (U+00A0) instead
      -- nbsp = "\xc2\xa0",
    }
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
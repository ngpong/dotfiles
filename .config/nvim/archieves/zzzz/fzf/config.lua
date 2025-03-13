local M = {}

local Fzflua        = vim.__lazy.require("fzf-lua")
local FzfluaActions = vim.__lazy.require("fzf-lua.actions")

local etypes = vim.__event.types

M.setup = function()
  local cfg = {
    winopts = {
      -- split         = "belowright new",-- open in a split instead?
                                          -- "belowright new"  : split below
                                          -- "aboveleft new"   : split above
                                          -- "belowright vnew" : split right
                                          -- "aboveleft vnew   : split left
      -- Only valid when using a float window
      -- (i.e. when 'split' is not defined, default)
      height           = 0.85,            -- window height
      width            = 0.85,            -- window width
      row              = 0.6,            -- window row position (0=top, 1=bottom)
      col              = 0.50,            -- window col position (0=left, 1=right)
      -- border argument passthrough to nvim_open_win(), also used
      -- to manually draw the border characters around the preview
      -- window, can be set to 'false' to remove all borders or to
      -- 'none', 'single', 'double', 'thicc' (+cc) or 'rounded' (default)
      border           = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      -- Backdrop opacity, 0 is fully opaque, 100 is fully transparent (i.e. disabled)
      backdrop         = 100,
      -- requires neovim > v0.9.0, passed as is to `nvim_open_win`
      -- can be sent individually to any provider to set the win title
      -- title         = "Title",
      -- title_pos     = "center",    -- 'left', 'center' or 'right'
      fullscreen       = false,           -- start fullscreen?
      preview = {
        default     = "bat",              -- override the default previewer?
                                          -- default uses the 'builtin' previewer
        border         = "border",        -- border|noborder, applies only to
                                          -- native fzf previewers (bat/cat/git/etc)
        wrap           = "nowrap",        -- wrap|nowrap
        hidden         = "hidden",        -- hidden|nohidden
        vertical       = "down:45%",      -- up|down:size
        horizontal     = "right:60%",     -- right|left:size
        layout         = "flex",          -- horizontal|vertical|flex
        flip_columns   = 120,             -- #cols to switch to horizontal on flex
        -- Only used with the builtin previewer:
        title          = true,            -- preview border title (file/buf)?
        title_pos      = "center",        -- left|center|right, title alignment
        scrollbar      = "float",         -- `false` or string:'float|border'
                                          -- float:  in-window floating border
                                          -- border: in-border chars (see below)
        scrolloff      = "-2",            -- float scrollbar offset from right
                                          -- applies only when scrollbar = 'float'
        scrollchars    = {"█", "" },      -- scrollbar chars ({ <full>, <empty> }
                                          -- applies only when scrollbar = 'border'
        delay          = 100,             -- delay(ms) displaying the preview
                                          -- prevents lag on fast scrolling
        winopts = {                       -- builtin previewer window options
          number            = true,
          relativenumber    = false,
          cursorline        = true,
          cursorlineopt     = "both",
          cursorcolumn      = false,
          signcolumn        = "no",
          list              = false,
          foldenable        = false,
          foldmethod        = "manual",
        },
      },
      on_create = function()
        -- called once upon creation of the fzf main window
        -- can be used to add custom fzf-lua mappings, e.g:
        --   vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
        vim.__event.emit(etypes.FZFLUA_LOAD, { bufnr = vim.__buf.current() })
      end,
      -- called once _after_ the fzf interface is closed
      -- on_close = function() ... end
    },
    fzf_opts = {
      -- options are sent as `<left>=<right>`
      -- set to `false` to remove a flag
      -- set to `true` for a no-value flag
      -- for raw args use `fzf_args` instead
      ["--ansi"]           = true,
      ["--info"]           = "inline-right", -- fzf < v0.42 = "inline"
      ["--height"]         = "100%",
      ["--layout"]         = "reverse",
      ["--border"]         = "none",
      ["--highlight-line"] = true,           -- fzf >= v0.53
      ["--scrollbar"]      = "┃",
    },
    -- Only used when fzf_bin = "fzf-tmux", by default opens as a
    -- popup 80% width, 80% height (note `-p` requires tmux > 3.2)
    -- and removes the sides margin added by `fzf-tmux` (fzf#3162)
    -- for more options run `fzf-tmux --help`
    fzf_tmux_opts       = { ["-p"] = "80%,80%", ["--margin"] = "0,0" },
    previewers = {
      cat = {
        cmd             = "cat",
        args            = "-n",
      },
      bat = {
        cmd             = "bat",
        args            = "--color=always --style=numbers,changes",
        -- uncomment to set a bat theme, `bat --list-themes`
        theme           = "gruvbox-dark",
      },
      head = {
        cmd             = "head",
        args            = nil,
      },
      git_diff = {
        -- if required, use `{file}` for argument positioning
        -- e.g. `cmd_modified = "git diff --color HEAD {file} | cut -c -30"`
        cmd_deleted     = "git diff --color HEAD --",
        cmd_modified    = "git diff --color HEAD",
        cmd_untracked   = "git diff --color --no-index /dev/null",
        -- git-delta is automatically detected as pager, set `pager=false`
        -- to disable, can also be set under 'git.status.preview_pager'
      },
      man = {
        -- NOTE: remove the `-c` flag when using man-db
        -- replace with `man -P cat %s | col -bx` on OSX
        cmd             = "man -c %s | col -bx",
      },
      builtin = {
        syntax          = true,         -- preview syntax highlight?
        syntax_limit_l  = 0,            -- syntax limit (lines), 0=nolimit
        syntax_limit_b  = 1024*1024,    -- syntax limit (bytes), 0=nolimit
        limit_b         = 1024*1024*10, -- preview limit (bytes), 0=nolimit
        -- previewer treesitter options:
        -- enable specific filetypes with: `{ enable = { "lua" } }
        -- exclude specific filetypes with: `{ disable = { "lua" } }
        -- disable fully with: `{ enable = false }`
        treesitter      = { enable = true, disable = {} },
        -- By default, the main window dimensions are calculated as if the
        -- preview is visible, when hidden the main window will extend to
        -- full size. Set the below to "extend" to prevent the main window
        -- from being modified when toggling the preview.
        toggle_behavior = "default",
        -- Title transform function, by default only displays the tail
        -- title_fnamemodify = function(s) vim.fn.fnamemodify(s, ":t") end,
        -- preview extensions using a custom shell command:
        -- for example, use `viu` for image previews
        -- will do nothing if `viu` isn't executable
        extensions      = {
          -- neovim terminal only supports `viu` block output
          ["png"]       = { "viu", "-b" },
          -- by default the filename is added as last argument
          -- if required, use `{file}` for argument positioning
          ["svg"]       = { "chafa", "{file}" },
          ["jpg"]       = { "ueberzug" },
        },
        -- if using `ueberzug` in the above extensions map
        -- set the default image scaler, possible scalers:
        --   false (none), "crop", "distort", "fit_contain",
        --   "contain", "forced_cover", "cover"
        -- https://github.com/seebye/ueberzug
        ueberzug_scaler = "cover",
        -- Custom filetype autocmds aren't triggered on
        -- the preview buffer, define them here instead
        -- ext_ft_override = { ["ksql"] = "sql", ... },
      },
      -- Code Action previewers, default is "codeaction" (set via `lsp.code_actions.previewer`)
      -- "codeaction_native" uses fzf's native previewer, recommended when combined with git-delta
      codeaction = {
        -- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
        diff_opts = { ctxlen = 3 },
      },
      codeaction_native = {
        diff_opts = { ctxlen = 3 },
        -- git-delta is automatically detected as pager, set `pager=false`
        -- to disable, can also be set under 'lsp.code_actions.preview_pager'
        -- recommended styling for delta
        --pager = [[delta --width=$COLUMNS --hunk-header-style="omit" --file-style="omit"]],
      },
    },
    -- PROVIDERS SETUP
    -- use `defaults` (table or function) if you wish to set "global-provider" defaults
    -- for example, using "mini.icons" globally and open the quickfix list at the top
    --   defaults = {
    --     file_icons   = "mini",
    --     copen        = "topleft copen",
    --   },
    files = {
      -- previewer      = "bat",          -- uncomment to override previewer
                                          -- (name from 'previewers' table)
                                          -- set to 'false' to disable
      prompt            = false,
      multiprocess      = true,           -- run command in a separate process
      git_icons         = false,          -- show git icons?
      file_icons        = true,           -- show file icons (true|"devicons"|"mini")?
      color_icons       = true,           -- colorize file|git icons
      path_shorten      = false,          -- 'true' or number, shorten path?
      -- Uncomment for custom vscode-like formatter where the filename is first:
      -- e.g. "fzf-lua/previewer/fzf.lua" => "fzf.lua previewer/fzf-lua"
      -- formatter      = "path.filename_first",
      -- executed command priority is 'cmd' (if exists)
      -- otherwise auto-detect prioritizes `fd`:`rg`:`find`
      -- default options are controlled by 'fd|rg|find|_opts'
      -- NOTE: 'find -printf' requires GNU find
      -- cmd            = "find . -type f -printf '%P\n'",
      find_opts         = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
      rg_opts           = [[--color=never --files --hidden --follow --no-ignore-vcs]],
      -- fd 本身并不附带原生排序的选项，还需要借助管道等工具来实现。
      -- 如果需要排序，不管是 rg 还是 fd 也好，必定会走某个节点回退到单线程运行，或许不排序是一种更好的选择。
      fd_opts           = [[--color=never --type f --hidden --follow --no-ignore-vcs]],
      -- by default, cwd appears in the header only if {opts} contain a cwd
      -- parameter to a different folder than the current working directory
      -- uncomment if you wish to force display of the cwd as part of the
      -- query prompt string (fzf.vim style), header line or both
      -- cwd_header = true,
      cwd_prompt             = false,
      cwd_prompt_shorten_len = 32,        -- shorten prompt beyond this length
      cwd_prompt_shorten_val = 1,         -- shortened path parts length
      toggle_ignore_flag = "--no-ignore", -- flag toggled in `actions.toggle_ignore`
      toggle_hidden_flag = "--hidden",    -- flag toggled in `actions.toggle_hidden`
      winopts = {
        title     = " Files ",
        title_pos = "center",
      },
    },
    git = {
      files = {
        prompt        = "GitFiles❯ ",
        cmd           = "git ls-files --exclude-standard",
        multiprocess  = true,           -- run command in a separate process
        git_icons     = true,           -- show git icons?
        file_icons    = true,           -- show file icons (true|"devicons"|"mini")?
        color_icons   = true,           -- colorize file|git icons
        -- force display the cwd header line regardless of your current working
        -- directory can also be used to hide the header when not wanted
        -- cwd_header = true
      },
      status = {
        prompt        = "GitStatus❯ ",
        cmd           = "git -c color.status=false --no-optional-locks status --porcelain=v1 -u",
        multiprocess  = true,           -- run command in a separate process
        file_icons    = true,
        git_icons     = true,
        color_icons   = true,
        previewer     = "git_diff",
        -- git-delta is automatically detected as pager, uncomment to disable
        -- preview_pager = false,
      },
      commits = {
        prompt        = "Commits❯ ",
        cmd           = [[git log --color --pretty=format:"%C(yellow)%h%Creset ]]
            .. [[%Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset"]],
        preview       = "git show --color {1}",
        -- git-delta is automatically detected as pager, uncomment to disable
        -- preview_pager = false,
      },
      bcommits = {
        prompt        = "BCommits❯ ",
        -- default preview shows a git diff vs the previous commit
        -- if you prefer to see the entire commit you can use:
        --   git show --color {1} --rotate-to={file}
        --   {1}    : commit SHA (fzf field index expression)
        --   {file} : filepath placement within the commands
        cmd           = [[git log --color --pretty=format:"%C(yellow)%h%Creset ]]
            .. [[%Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset" {file}]],
        preview       = "git show --color {1} -- {file}",
        -- git-delta is automatically detected as pager, uncomment to disable
        -- preview_pager = false,
      },
      branches = {
        prompt   = "Branches❯ ",
        cmd      = "git branch --all --color",
        preview  = "git log --graph --pretty=oneline --abbrev-commit --color {1}",
        -- If you wish to add branch and switch immediately
        -- cmd_add  = { "git", "checkout", "-b" },
        cmd_add  = { "git", "branch" },
        -- If you wish to delete unmerged branches add "--force"
        -- cmd_del  = { "git", "branch", "--delete", "--force" },
        cmd_del  = { "git", "branch", "--delete" },
      },
      tags = {
        prompt   = "Tags> ",
        cmd      = [[git for-each-ref --color --sort="-taggerdate" --format ]]
            .. [["%(color:yellow)%(refname:short)%(color:reset) ]]
            .. [[%(color:green)(%(taggerdate:relative))%(color:reset)]]
            .. [[ %(subject) %(color:blue)%(taggername)%(color:reset)" refs/tags]],
        preview  = [[git log --graph --color --pretty=format:"%C(yellow)%h%Creset ]]
            .. [[%Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset" {1}]],
      },
      stash = {
        prompt          = "Stash> ",
        cmd             = "git --no-pager stash list",
        preview         = "git --no-pager stash show --patch --color {1}",
      },
      icons = {
        ["M"]           = { icon = "M", color = "yellow" },
        ["D"]           = { icon = "D", color = "red" },
        ["A"]           = { icon = "A", color = "green" },
        ["R"]           = { icon = "R", color = "yellow" },
        ["C"]           = { icon = "C", color = "yellow" },
        ["T"]           = { icon = "T", color = "magenta" },
        ["?"]           = { icon = "?", color = "magenta" },
        -- override git icons?
        -- ["M"]        = { icon = "★", color = "red" },
        -- ["D"]        = { icon = "✗", color = "red" },
        -- ["A"]        = { icon = "+", color = "green" },
      },
    },
    grep = {
      prompt            = "Rg❯ ",
      input_prompt      = "Grep For❯ ",
      multiprocess      = true,           -- run command in a separate process
      git_icons         = true,           -- show git icons?
      file_icons        = true,           -- show file icons (true|"devicons"|"mini")?
      color_icons       = true,           -- colorize file|git icons
      -- executed command priority is 'cmd' (if exists)
      -- otherwise auto-detect prioritizes `rg` over `grep`
      -- default options are controlled by 'rg|grep_opts'
      -- cmd            = "rg --vimgrep",
      grep_opts         = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e",
      rg_opts           = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
      -- Uncomment to use the rg config file `$RIPGREP_CONFIG_PATH`
      -- RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH
      --
      -- Set to 'true' to always parse globs in both 'grep' and 'live_grep'
      -- search strings will be split using the 'glob_separator' and translated
      -- to '--iglob=' arguments, requires 'rg'
      -- can still be used when 'false' by calling 'live_grep_glob' directly
      rg_glob           = false,        -- default to glob parsing?
      glob_flag         = "--iglob",    -- for case sensitive globs use '--glob'
      glob_separator    = "%s%-%-",     -- query separator pattern (lua): ' --'
      -- advanced usage: for custom argument parsing define
      -- 'rg_glob_fn' to return a pair:
      --   first returned argument is the new search query
      --   second returned argument are additional rg flags
      -- rg_glob_fn = function(query, opts)
      --   ...
      --   return new_query, flags
      -- end,
      --
      -- Enable with narrow term width, split results to multiple lines
      -- NOTE: multiline requires fzf >= v0.53 and is ignored otherwise
      -- multiline      = 1,      -- Display as: PATH:LINE:COL\nTEXT
      -- multiline      = 2,      -- Display as: PATH:LINE:COL\nTEXT\n
      no_header             = false,    -- hide grep|cwd header?
      no_header_i           = false,    -- hide interactive header?
      fzf_opts = {
        -- ['--history'] = Path.join(phistory_grep, ws_sha1)
      }
    },
    args = {
      prompt            = "Args❯ ",
      files_only        = true,
    },
    oldfiles = {
      prompt            = "History❯ ",
      cwd_only          = false,
      stat_file         = true,         -- verify files exist on disk
      -- can also be a lua function, for example:
      -- stat_file = require("fzf-lua").utils.file_is_readable,
      -- stat_file = function() return true end,
      include_current_session = false,  -- include bufs from current session
    },
    buffers = {
      prompt            = "Buffers❯ ",
      file_icons        = true,         -- show file icons (true|"devicons"|"mini")?
      color_icons       = true,         -- colorize file|git icons
      sort_lastused     = true,         -- sort buffers() by last used
      show_unloaded     = true,         -- show unloaded buffers
      cwd_only          = false,        -- buffers for the cwd only
      cwd               = nil,          -- buffers list for a given dir
    },
    tabs = {
      prompt            = "Tabs❯ ",
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
      prompt            = "Lines❯ ",
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
      prompt            = "BLines❯ ",
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
      prompt                = "Tags❯ ",
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
      prompt                = "BTags❯ ",
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
      prompt            = "Colorschemes❯ ",
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
      prompt            = "Colorschemes❯ ",
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
      prompt            = "Keymaps> ",
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
          prompt            = "Code Actions> ",
          async_or_timeout  = 5000,
          -- when git-delta is installed use "codeaction_native" for beautiful diffs
          -- try it out with `:FzfLua lsp_code_actions previewer=codeaction_native`
          -- scroll up to `previewers.codeaction{_native}` for more previewer options
          previewer        = "codeaction",
      },
      finder = {
          prompt      = "LSP Finder> ",
          file_icons  = true,
          color_icons = true,
          git_icons   = false,
          async       = true,         -- async by default
          silent      = true,         -- suppress "not found" 
          separator   = "| ",         -- separator after provider prefix, `false` to disable
          includeDeclaration = true,  -- include current declaration in LSP context
          -- by default display all LSP locations
          -- to customize, duplicate table and delete unwanted providers
          providers   = {
              { "references",      prefix = require("fzf-lua").utils.ansi_codes.blue("ref ") },
              { "definitions",     prefix = require("fzf-lua").utils.ansi_codes.green("def ") },
              { "declarations",    prefix = require("fzf-lua").utils.ansi_codes.magenta("decl") },
              { "typedefs",        prefix = require("fzf-lua").utils.ansi_codes.red("tdef") },
              { "implementations", prefix = require("fzf-lua").utils.ansi_codes.green("impl") },
              { "incoming_calls",  prefix = require("fzf-lua").utils.ansi_codes.cyan("in  ") },
              { "outgoing_calls",  prefix = require("fzf-lua").utils.ansi_codes.yellow("out ") },
          },
      }
    },
    diagnostics ={
      prompt            = "Diagnostics❯ ",
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

  vim.__event.emit(etypes.SETUP_FZFLUA, cfg)

  Fzflua.setup(cfg)
end

return M

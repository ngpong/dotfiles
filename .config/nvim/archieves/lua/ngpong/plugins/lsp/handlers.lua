local M = {}

local setup_diagnostics = function()
  -- 仅设置 publishDiagnostics handlers 所产生的 diagnostic
  --  REF1: https://www.reddit.com/r/neovim/comments/xqsboa/lsp_how_can_i_only_show_diagnostic_text_on_the/
  --  REF2: https://www.reddit.com/r/neovim/comments/og1cdv/neovim_lsp_how_do_you_get_diagnostic_mesages_to/
  --
  -- 如果想要该配置应用于全局(因为可能会有不同的源会设置 diagnostic)
  --  REF1: https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.config()
  --  vim.diagnostic.config({
  --    update_in_insert = true,
  --    virtual_text = true,
  --    signs = false,
  --    underline = true,
  --  })
  --
  -- 对于 windows terimal 下划线没有颜色的问题
  --  REF1: https://github.com/microsoft/language-server-protocol/issues/257
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = {
      severity = {
        vim.diagnostic.severity.ERROR,
        vim.diagnostic.severity.WARN,
        vim.diagnostic.severity.INFO,
        vim.diagnostic.severity.HINT,
      },
    },
    virtual_text = false,
    signs = false,
    update_in_insert = false,
  })

  vim.lsp.handlers["textDocument/diagnostic"] = vim.lsp.with(vim.lsp.diagnostic.on_diagnostic, {
    underline = {
      severity = {
        vim.diagnostic.severity.ERROR,
        vim.diagnostic.severity.WARN,
        vim.diagnostic.severity.INFO,
        vim.diagnostic.severity.HINT,
      },
    },
    virtual_text = false,
    signs = false,
    update_in_insert = false,
  })
end

local setup_hover = function()
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
    relative = "cursor",
    noautocmd = true,
    silent = true,
  })
end

local setup_signaturehelp = function()
  -- handler:
  --  vim.lsp.handlers["textDocument/signatureHelp"]
  --
  -- NOTE: for maunmal setup handler checkout NVChad::signatureHelp

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
    relative = "cursor",
    noautocmd = true,
    silent = true,
  })

  require("lsp_signature").setup({
    debug = false,
    log_path = vim.__path.standard("state") .. "/lsp_signature.log", -- ~/.cache/nvim/lsp_signature.log
    verbose = false, -- show debug line number
    bind = false, -- This is mandatory, otherwise border config won't get registered.
    -- If you want to hook lspsaga or other signature handler, pls set to false
    doc_lines = 0, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
    -- set to 0 if you DO NOT want any API comments be shown
    -- This setting only take effect in insert mode, it does not affect signature help in normal
    -- mode, 10 by default
    max_height = 12, -- max height of signature floating_window
    max_width = 200, -- max_width of signature floating_window, line will be wrapped if exceed max_width
    -- the value need >= 40
    wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
    floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
    floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
    -- will set to true when fully tested, set to false will use whichever side has more space
    -- this setting will be helpful if you do not want the PUM and floating win overlap
    floating_window_off_x = 1, -- adjust float windows x position.
    -- can be either a number or function
    floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
    -- can be either number or function, see examples
    close_timeout = 4000, -- close floating window after ms when laster parameter is entered
    fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
    hint_enable = false, -- virtual hint enable
    hint_prefix = {
      above = "↙ ", -- when the hint is on the line above the current line
      current = "← ", -- when the hint is on the same line
      below = "↖ ", -- when the hint is on the line below the current line
    },
    hint_scheme = "String",
    hint_inline = function()
      return false
    end, -- should the hint be inline(nvim 0.10 only)?  default false
    -- return true | 'inline' to show hint inline, return 'eol' to show hint at end of line, return false to disable
    -- return 'right_align' to display hint right aligned in the current line
    hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
    handler_opts = {
      border = "rounded", -- double, rounded, single, shadow, none, or a table of borders
    },
    always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58
    auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
    extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {'(', ','}
    zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom
    padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
    transparency = nil, -- disabled by default, allow floating win transparent value 1~100
    shadow_blend = nil, -- if you using shadow as border use this set the opacity
    shadow_guibg = "Black", -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
    timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
    toggle_key = "<C-k>", -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
    toggle_key_flip_floatwin_setting = true, -- true: toggle floating_windows: true|false setting after toggle key pressed
    -- false: floating_windows setup will not change, toggle_key will pop up signature helper, but signature
    -- may not popup when typing depends on floating_window setting
    select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
    move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
    cursorhold_update = false,
  })
end

local setup_lsp_notify = function()
  -- handler:
  --  vim.lsp.handlers["$/progress"]

  -- local caches = {}
  --
  -- local function get_cache(cli_id, token)
  --   if not caches[cli_id] then
  --     caches[cli_id] = {}
  --   end
  --
  --   return caches[cli_id][token]
  -- end
  --
  -- local function del_cache(cli_id, token)
  --   if not get_cache(cli_id, token) then
  --     return
  --   end
  --
  --   caches[cli_id][token] = nil
  -- end
  --
  -- local function ini_cache(cli_id, token)
  --   if get_cache(cli_id, token) then
  --     return
  --   end
  --
  --   caches[cli_id][token] = {}
  --
  --   return caches[cli_id][token]
  -- end
  --
  -- local function format_title(title, client_name)
  --   return client_name .. (#title > 0 and ": " .. title or "")
  -- end
  --
  -- local function format_message(message, percentage)
  --   return (percentage and percentage .. "%\t" or "") .. (message or "")
  -- end
  --
  -- vim.lsp.handlers["$/progress"] = function(_, res, ctx)
  --   if res.value.kind == "begin" then
  --     local cli = vim.lsp.get_client_by_id(ctx.client_id)
  --     if not cli then
  --       return
  --     end
  --
  --     if get_cache(ctx.client_id, res.token) then
  --       return
  --     end
  --
  --     -- NOTE: lua_ls 的某些消息会一直频繁的刷新
  --     local can_notify = not (cli.name == "lua_ls" and (res.value.title == "Diagnosing" or res.value.title == "Processing file symbols..."))
  --
  --     if can_notify then
  --       local cache = ini_cache(ctx.client_id, res.token)
  --       if not cache then
  --         return
  --       end
  --
  --       cache.can_notify = true
  --       cache.notifier = vim.__helper.NotifierFactory.get { title = format_title(res.value.title, cli.name) }
  --
  --       cache.notifier:start(format_message(res.value.message, res.value.percentage))
  --     end
  --   elseif res.value.kind == "report" then
  --     local cache = get_cache(ctx.client_id, res.token)
  --     if not cache then
  --       return
  --     end
  --
  --     if cache.can_notify then
  --       cache.notifier:update(format_message(res.value.message, res.value.percentage))
  --     end
  --   elseif res.value.kind == "end" then
  --     local cache = get_cache(ctx.client_id, res.token)
  --     if not cache then
  --       return
  --     end
  --
  --     if cache.can_notify then
  --       cache.notifier:dismiss(res.value.message and format_message(res.value.message) or "Complete")
  --       del_cache(ctx.client_id, res.token)
  --     end
  --   end
  -- end

  require("fidget").setup({
    -- Options related to LSP progress subsystem
    progress = {
      poll_rate = 0, -- How and when to poll for progress messages
      suppress_on_insert = false, -- Suppress new messages while in insert mode
      ignore_done_already = true, -- Ignore new tasks that are already complete
      ignore_empty_message = false, -- Ignore new tasks that don't contain a message
      -- Clear notification group when LSP server detaches
      clear_on_detach = function(client_id)
        local client = vim.lsp.get_client_by_id(client_id)
        return client and client.name or nil
      end,
      -- How to get a progress message's notification group key
      notification_group = function(msg)
        return msg.lsp_client.name
      end,
      ignore = { -- List of LSP servers to ignore
        function(msg)
          return false
        end,
      },

      -- Options related to how LSP progress messages are displayed as notifications
      display = {
        render_limit = 16, -- How many LSP messages to show at once
        done_ttl = 2, -- How long a message should persist after completion
        done_icon = "", -- Icons.lsp_loaded, -- Icon shown when all LSP progress tasks are complete
        done_style = "FidgetDone", -- Highlight group for completed LSP tasks
        progress_ttl = math.huge, -- How long a message should persist when in progress
        -- Icon shown when LSP progress tasks are in progress
        progress_icon = { pattern = { "" } }, -- { pattern = { unpack(Icons.spinner_frames_8) }, period = 1 },
        -- Highlight group for in-progress LSP tasks
        progress_style = "FidgetProgress",
        group_style = "FidgetGroup", -- Highlight group for group name (LSP server name)
        icon_style = "FidgetIcon", -- Highlight group for group icons
        priority = 30, -- Ordering priority for LSP notification group
        skip_history = true, -- Whether progress notifications should be omitted from history
        -- How to format a progress message
        format_message = require("fidget.progress.display").default_format_message,
        -- How to format a progress annotation
        format_annote = function(msg)
          return msg.title
        end,
        -- How to format a progress notification group's name
        format_group_name = function(group)
          return "" -- tostring(group)
        end,
        overrides = { -- Override options from the default notification config
          rust_analyzer = { name = "rust-analyzer" },
        },
      },

      -- Options related to Neovim's built-in LSP client
      lsp = {
        progress_ringbuf_size = 0, -- Configure the nvim's LSP progress ring buffer size
        log_handler = false, -- Log `$/progress` handler invocations (for debugging)
      },
    },

    -- Options related to notification subsystem
    notification = {
      poll_rate = 10, -- How frequently to update and render notifications
      filter = vim.log.levels.INFO, -- Minimum notifications level
      history_size = 128, -- Number of removed messages to retain in history
      override_vim_notify = false, -- Automatically override vim.notify() with Fidget
      -- How to configure notification groups when instantiated
      configs = {
        default = vim.__tbl.r_extend(require("fidget.notification").default_config, { icon_on_left = true }),
      },
      -- Conditionally redirect notifications to another backend
      redirect = function(msg, level, opts)
        if opts and opts.on_open then
          return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
        end
      end,

      -- Options related to how notifications are rendered as text
      view = {
        stack_upwards = false, -- Display notification items from bottom to top
        icon_separator = " ", -- Separator between group name and icon
        group_separator = "---", -- Separator between notification groups
        -- Highlight group used for group separator
        group_separator_hl = "Comment",
        -- How to render notification messages
        render_message = function(msg, cnt)
          return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
        end,
      },

      -- Options related to the notification window and buffer
      window = {
        normal_hl = "Comment", -- Base highlight group in the notification window
        winblend = 0, -- Background color opacity in the notification window
        border = "none", -- Border around the notification window
        zindex = 45, -- Stacking priority of the notification window
        max_width = 0, -- Maximum width of the notification window
        max_height = 0, -- Maximum height of the notification window
        x_padding = 0, -- Padding from right edge of window boundary
        y_padding = 0, -- Padding from bottom edge of window boundary
        align = "bottom", -- How to align the notification window
        relative = "editor", -- What the notification window position is relative to
      },
    },

    -- Options related to integrating with other plugins
    integration = {
      ["nvim-tree"] = {
        enable = false, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
      },
      ["xcodebuild-nvim"] = {
        enable = false, -- Integrate with wojciech-kulik/xcodebuild.nvim (if installed)
      },
    },

    -- Options related to logging
    logger = {
      level = vim.log.levels.ERROR, -- Minimum logging level
      max_size = 10000, -- Maximum log file size, in KB
      float_precision = 0.01, -- Limit the number of decimals displayed for floats
      path = string.format("%s/fidget.nvim.log", vim.__path.standard("state")),
    },
  })
end

M.setup = function()
  setup_diagnostics()

  setup_hover()

  setup_signaturehelp()

  setup_lsp_notify()
end

return M

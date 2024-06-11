local M = {}

local Icons = require('ngpong.utils.icon')
local libP = require('ngpong.common.libp')

local setup_jumping = function()
  local real_textDocument_definition = vim.lsp.handlers['textDocument/definition']
  vim.lsp.handlers['textDocument/definition'] = libP.async.void(function(...)
    VAR.set('DisablePresistCursor', true)

    real_textDocument_definition(...)

    libP.async.util.scheduler()

    VAR.unset('DisablePresistCursor')
  end)

  local real_textDocument_references = vim.lsp.handlers['textDocument/references']
  vim.lsp.handlers['textDocument/references'] = libP.async.void(function(...)
    VAR.set('DisablePresistCursor', true)

    real_textDocument_references(...)

    libP.async.util.scheduler()

    VAR.unset('DisablePresistCursor')
  end)

  local real_textDocument_declaration = vim.lsp.handlers['textDocument/declaration']
  vim.lsp.handlers['textDocument/declaration'] = libP.async.void(function(...)
    VAR.set('DisablePresistCursor', true)

    real_textDocument_declaration(...)

    libP.async.util.scheduler()

    VAR.unset('DisablePresistCursor')
  end)
end

local setup_diagnostics = function()
  -- 仅设置 publishDiagnostics handlers 所产生的 diagnostic
  --  REF1: https://www.reddit.com/r/neovim/comments/xqsboa/lsp_how_can_i_only_show_diagnostic_text_on_the/
  --  REF2: https://www.reddit.com/r/neovim/comments/og1cdv/neovim_lsp_how_do_you_get_diagnostic_mesages_to/
  --
  -- 如果想要该配置应用于全局(因为可能会有不同的源会设置 diagnostic)
  --  REF1: https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.config()
  --
  -- 对于 windows terimal 下划线没有颜色的问题
  --  REF1: https://github.com/microsoft/language-server-protocol/issues/257
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
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

  vim.lsp.handlers['textDocument/diagnostic'] = vim.lsp.with(vim.lsp.diagnostic.on_diagnostic, {
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
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = 'rounded',
    relative = 'cursor',
    noautocmd = true,
    silent = true,
  })
end

local setup_signaturehelp = function()
  -- handler:
  --  vim.lsp.handlers['textDocument/signatureHelp']
  --
  -- NOTE: for maunmal setup handler checkout NVChad::signatureHelp

  local lsp_signature = require('lsp_signature')

  _LSP_SIG_CFG.cursorhold_update = false

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'rounded',
    relative = 'cursor',
    noautocmd = true,
    silent = true,
  })

  lsp_signature.setup({
    debug = false,
    log_path = vim.fn.stdpath('cache') .. '/lsp_signature.log', -- ~/.cache/nvim/lsp_signature.log
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
      above = "↙ ",  -- when the hint is on the line above the current line
      current = "← ",  -- when the hint is on the same line
      below = "↖ "  -- when the hint is on the line below the current line
    },
    hint_scheme = 'String',
    hint_inline = function()
      return false
    end, -- should the hint be inline(nvim 0.10 only)?  default false
    -- return true | 'inline' to show hint inline, return 'eol' to show hint at end of line, return false to disable
    -- return 'right_align' to display hint right aligned in the current line
    hi_parameter = 'LspSignatureActiveParameter', -- how your parameter will be highlight
    handler_opts = {
      border = 'rounded', -- double, rounded, single, shadow, none, or a table of borders
    },
    always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58
    auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
    extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {'(', ','}
    zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom
    padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc
    transparency = nil, -- disabled by default, allow floating win transparent value 1~100
    shadow_blend = nil, -- if you using shadow as border use this set the opacity
    shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
    timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
    toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
    toggle_key_flip_floatwin_setting = false, -- true: toggle floating_windows: true|false setting after toggle key pressed
    -- false: floating_windows setup will not change, toggle_key will pop up signature helper, but signature
    -- may not popup when typing depends on floating_window setting
    select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
    move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
  })
end

local setup_lsp_notify = function()
  -- handler:
  --  vim.lsp.handlers['$/progress']
  --  vim.lsp.handlers['window/showMessage']

  local caches = {}

  local function get_cache(cli_id, token)
    if not caches[cli_id] then
      caches[cli_id] = {}
    end

    return caches[cli_id][token]
  end

  local function del_cache(cli_id, token)
    if not get_cache(cli_id, token) then
      return
    end

    caches[cli_id][token] = nil
  end

  local function ini_cache(cli_id, token)
    if get_cache(cli_id, token) then
      return
    end

    caches[cli_id][token] = {}

    return caches[cli_id][token]
  end

  local function update_spinner(cli_id, token)
    local cache = get_cache(cli_id, token)
    if not cache then
      return
    end

    local new_spinner = (cache.spinner + 1) % #Icons.spinner_frames

    cache.spinner = new_spinner
    cache.notification = vim.notify(nil, nil, {
      hide_from_history = true,
      icon = Icons.spinner_frames[new_spinner],
      replace = cache.notification,
    })

    vim.defer_fn(function()
      update_spinner(cli_id, token)
    end, 100)
  end

  local function format_title(title, client_name)
    return client_name .. (#title > 0 and ': ' .. title or '')
  end

  local function format_message(message, percentage)
    return (percentage and percentage .. '%\t' or '') .. (message or '')
  end

  vim.lsp.handlers['$/progress'] = function(_, res, ctx)
    if res.value.kind == 'begin' then
      local cli = vim.lsp.get_client_by_id(ctx.client_id)
      if not cli then
        return
      end

      local cache = ini_cache(ctx.client_id, res.token)
      if not cache then
        return
      end

      -- NOTE: lua_ls 的某些消息会一直频繁的刷新
      cache.can_notify = not (cli.name == 'lua_ls' and res.value.title == 'Diagnosing')

      if cache.can_notify then
        cache.notification = vim.notify(format_message(res.value.message, res.value.percentage), 'info', {
          title = format_title(res.value.title, cli.name),
          icon = Icons.spinner_frames[1],
          timeout = false,
          hide_from_history = false,
        })

        cache.spinner = 1
        update_spinner(ctx.client_id, res.token)
      end
    elseif res.value.kind == 'report' then
      local cache = get_cache(ctx.client_id, res.token)
      if not cache then
        return
      end

      if cache.can_notify then
        cache.notification = vim.notify(format_message(res.value.message, res.value.percentage), 'info', {
          replace = cache.notification,
          hide_from_history = false,
        })
      end
    elseif res.value.kind == 'end' then
      local cache = get_cache(ctx.client_id, res.token)
      if not cache then
        return
      end

      if cache.can_notify then
        cache.notification = vim.notify(res.value.message and format_message(res.value.message) or 'Complete', 'info', {
          icon = Icons.lsp_loaded,
          replace = cache.notification,
          timeout = 3000,
        })
      end

      del_cache(ctx.client_id, res.token)
    end
  end

  local severity = { 'error', 'warn', 'info', 'info' } -- map both hint and info to info?

  vim.lsp.handlers['window/showMessage'] = function(err, method, params, client_id)
    vim.notify(method.message, severity[params.type])
  end
end

M.setup = function()
  setup_jumping()

  setup_diagnostics()

  setup_hover()

  setup_signaturehelp()

  setup_lsp_notify()
end

return M

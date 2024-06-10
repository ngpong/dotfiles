local M = {}

local libP       = require('ngpong.common.libp')
local Events     = require('ngpong.common.events')
local Keymap     = require('ngpong.common.keybinder')
local Lazy       = require('ngpong.utils.lazy')
local Lspcfg     = Lazy.require('lspconfig')
local Extensions = Lazy.require('clangd_extensions')
local InlayHints = Lazy.require('clangd_extensions.inlay_hints')

local e_mode   = Keymap.e_mode
local e_name = Events.e_name

local is_open_extensions = function(source)
  for _, winid in pairs(Helper.get_list_winids()) do
    local bufnr = Helper.get_bufnr(winid)
    if Helper.get_filetype(bufnr) == source then
      return winid
    end
  end
  return -1
end

local setup_server = function(cfg)
  Extensions.setup({
    inlay_hints = {
      inline = vim.fn.has('nvim-0.10') == 1,
      only_current_line = false,
      -- Event which triggers a refresh of the inlay hints.
      -- You can make this { 'CursorMoved' } or { 'CursorMoved,CursorMovedI' } but
      -- not that this may cause  higher CPU usage.
      -- This option is only respected when only_current_line and
      -- autoSetHints both are true.
      only_current_line_autocmd = { 'CursorHold' },
      -- whether to show parameter hints with the inlay hints or not
      show_parameter_hints = true,
      -- prefix for parameter hints
      parameter_hints_prefix = '<- ',
      -- prefix for all the other hints (type, chaining)
      other_hints_prefix = '=> ',
      -- whether to align to the length of the longest line in the file
      max_len_align = false,
      -- padding from the left if max_len_align is true
      max_len_align_padding = 1,
      -- whether to align to the extreme right or not
      right_align = false,
      -- padding from the right if right_align is true
      right_align_padding = 7,
      -- The color of the hints
      highlight = 'Comment',
      -- The highlight group priority for extmark
      priority = 100,
    },
    ast = {
      role_icons = {
        type = '',
        declaration = '',
        expression = '',
        specifier = '',
        statement = '',
        ['template argument'] = '',
      },
      kind_icons = {
        Compound = '',
        Recovery = '',
        TranslationUnit = '',
        PackExpansion = '',
        TemplateTypeParm = '',
        TemplateTemplateParm = '',
        TemplateParamObject = '',
      },
      highlights = {
        detail = 'Comment',
      },
    },
    memory_usage = {
      border = 'rounded',
    },
    symbol_info = {
      border = 'rounded',
    },
  })

  Lspcfg.clangd.setup({
    cmd = {
      'clangd',
      '-j=16',
      '--clang-tidy',
      '--background-index',
      '--background-index-priority=normal',
      '--ranking-model=decision_forest',
      '--completion-style=detailed',
      '--header-insertion=never', -- iwyu
      '--header-insertion-decorators=false',
      '--malloc-trim',
      '--pch-storage=memory',
      '--limit-references=0',
      '--limit-results=30',
      '--include-cleaner-stdlib',
      -- '--compile-commands-dir=/home/ngpong/code/cpp/CPP-Study-02/TEST/TEST_93/',
      -- '--log=verbose',
    },
    single_file_support = true,
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'tcc' },
    capabilities = cfg.cli_capabilities({ snippetSupport = false }),
    on_attach = cfg.on_attach(function()
      -- inlay_hints.setup_autocmd()
      -- inlay_hints.set_inlay_hints()
    end)
  })
end

local setup_keymaps = function(_)
  Events.rg(e_name.ATTACH_LSP, function(state)
    if state.cli.name ~= 'clangd' then
      return
    end

    Keymap.register(e_mode.NORMAL, 'dh', function()
      if M.__dh_key_executing then
        return
      end

      if is_open_extensions('ClangdTypeHierarchy') > 0 then
        return
      end

      M.__dh_key_executing = true

      libP.async.run(function()
        vim.go.splitbelow = true

        vim.cmd('ClangdTypeHierarchy')

        local timespan = 0
        while is_open_extensions('ClangdTypeHierarchy') < 0 do
          if timespan > 10000 then
            Helper.notify_warn('Type hierarchy not found or timeout.', 'LSP: clangd')
            break
          end
          timespan = timespan + 500

          libP.async.util.sleep(500)
        end

        vim.go.splitbelow = false

        M.__dh_key_executing = false
      end)
    end, { silent = true, buffer = state.bufnr, remap = false, desc = 'show type hierarchy.' })
    Keymap.register(e_mode.NORMAL, 'dm', Tools.wrap_f(vim.cmd, 'ClangdMemoryUsage'), { silent = true, buffer = state.bufnr, remap = false, desc = 'show clangd memory usage.' })
    Keymap.register(e_mode.NORMAL, 'ds', Tools.wrap_f(vim.cmd, 'ClangdSwitchSourceHeader'), { silent = true, buffer = state.bufnr, remap = false, desc = 'switch between source/header file.' })
    Keymap.register(e_mode.NORMAL, 'da', Tools.wrap_f(vim.cmd, 'ClangdAST'), { silent = true, buffer = state.bufnr, remap = false, desc = 'show AST.' })
  end)

  Events.rg(e_name.BUFFER_ENTER_ONCE, libP.async.void(function(state)
    libP.async.util.scheduler()

    if not Helper.is_buf_valid(state.buf) then
      return
    end

    if Helper.get_filetype(state.buf) ~= 'ClangdTypeHierarchy' then
      return
    end

    Keymap.hidegister(e_mode.NORMAL, 'd.', { buffer = state.buf })
    Keymap.hidegister(e_mode.NORMAL, 'd,', { buffer = state.buf })
    Keymap.hidegister(e_mode.NORMAL, 'dd', { buffer = state.buf })
    Keymap.hidegister(e_mode.NORMAL, 'dD', { buffer = state.buf })
    Keymap.hidegister(e_mode.NORMAL, 'dp', { buffer = state.buf })

    Keymap.unregister(e_mode.NORMAL, 'rc', { buffer = state.buf })

    local maparg = Keymap.get_keymap(e_mode.NORMAL, 'gd', state.buf)
    if maparg then
      Keymap.unregister(e_mode.NORMAL, 'gd', { buffer = state.buf })
      Keymap.register(e_mode.NORMAL, 'de', maparg.callback, { buffer = state.buf, desc = 'jump to definition.' })
    end

    Keymap.register(e_mode.NORMAL, '<ESC>', function()
      local winid = is_open_extensions('ClangdTypeHierarchy')
      if winid < 0 then
        return
      end

      Helper.close_win(winid)
    end, { remap = false, buffer = state.buf })
  end))
end

M.setup = function(cfg)
  setup_server(cfg)
  setup_keymaps(cfg)
end

return M

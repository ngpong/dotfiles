local M = {}

local Lspcfg     = vim.__lazy.require("lspconfig")
local Extensions = vim.__lazy.require("clangd_extensions")
local InlayHints = vim.__lazy.require("clangd_extensions.inlay_hints")

local kmodes = vim.__key.e_mode
local etypes = vim.__event.types

local is_open_extensions = function(source)
  for _, winid in pairs(vim.__win.all()) do
    local bufnr = vim.__buf.number(winid)
    if vim.__buf.filetype(bufnr) == source then
      return winid
    end
  end
  return -1
end

local setup_server = function(cfg)
  Extensions.setup({
    inlay_hints = {
      inline = vim.fn.has("nvim-0.10") == 1,
      only_current_line = false,
      -- Event which triggers a refresh of the inlay hints.
      -- You can make this { 'CursorMoved' } or { 'CursorMoved,CursorMovedI' } but
      -- not that this may cause  higher CPU usage.
      -- This option is only respected when only_current_line and
      -- autoSetHints both are true.
      only_current_line_autocmd = { "CursorHold" },
      -- whether to show parameter hints with the inlay hints or not
      show_parameter_hints = true,
      -- prefix for parameter hints
      parameter_hints_prefix = "<- ",
      -- prefix for all the other hints (type, chaining)
      other_hints_prefix = "=> ",
      -- whether to align to the length of the longest line in the file
      max_len_align = false,
      -- padding from the left if max_len_align is true
      max_len_align_padding = 1,
      -- whether to align to the extreme right or not
      right_align = false,
      -- padding from the right if right_align is true
      right_align_padding = 7,
      -- The color of the hints
      highlight = "Comment",
      -- The highlight group priority for extmark
      priority = 100,
    },
    ast = {
      role_icons = {
        type = "",
        declaration = "",
        expression = "",
        specifier = "",
        statement = "",
        ["template argument"] = "",
      },
      kind_icons = {
        Compound = "",
        Recovery = "",
        TranslationUnit = "",
        PackExpansion = "",
        TemplateTypeParm = "",
        TemplateTemplateParm = "",
        TemplateParamObject = "",
      },
      highlights = {
        detail = "Comment",
      },
    },
    memory_usage = {
      border = "rounded",
    },
    symbol_info = {
      border = "rounded",
    },
  })

  Lspcfg.clangd.setup({
    cmd = {
      "clangd",
      "-j=16",
      "--clang-tidy",
      "--background-index",
      "--background-index-priority=normal",
      "--ranking-model=decision_forest",
      "--completion-style=detailed",
      "--header-insertion=never", -- iwyu
      "--header-insertion-decorators=false",
      "--malloc-trim",
      "--pch-storage=memory",
      "--limit-references=0",
      "--limit-results=30",
      "--include-cleaner-stdlib",
      -- "--compile-commands-dir=/home/ngpong/code/cpp/CPP-Study-02/TEST/TEST_93/",
      -- "--log=verbose",
    },
    single_file_support = true,
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "tcc" },
    capabilities = cfg.cli_capabilities({ snippetSupport = false }),
    on_attach = cfg.on_attach(function()
      -- inlay_hints.setup_autocmd()
      -- inlay_hints.set_inlay_hints()
    end)
  })
end

local setup_keymaps = function(_)
  vim.__event.rg(etypes.ATTACH_LSP, function(state)
    if state.cli.name ~= "clangd" then
      return
    end

    vim.__key.rg(kmodes.N, "dh", function()
      if M.__dh_key_executing then
        return
      end

      if is_open_extensions("ClangdTypeHierarchy") > 0 then
        return
      end

      M.__dh_key_executing = true

      vim.__async.run(function()
        vim.go.splitbelow = true

        vim.cmd("ClangdTypeHierarchy")

        local timespan = 0
        while is_open_extensions("ClangdTypeHierarchy") < 0 do
          if timespan > 10000 then
            vim.__notifier.warn("Type hierarchy not found or timeout.")
            break
          end
          timespan = timespan + 500

          vim.__async.sleep(500)
        end

        vim.go.splitbelow = false

        M.__dh_key_executing = false
      end)
    end, { silent = true, buffer = state.bufnr, desc = "show type hierarchy." })
    vim.__key.rg(kmodes.N, "dm", vim.__util.wrap_f(vim.cmd, "ClangdMemoryUsage"), { silent = true, buffer = state.bufnr, desc = "show clangd memory usage." })
    vim.__key.rg(kmodes.N, "ds", vim.__util.wrap_f(vim.cmd, "ClangdSwitchSourceHeader"), { silent = true, buffer = state.bufnr, desc = "switch between source/header file." })
    vim.__key.rg(kmodes.N, "da", vim.__util.wrap_f(vim.cmd, "ClangdAST"), { silent = true, buffer = state.bufnr, desc = "show AST." })
  end)

  vim.__event.rg(etypes.BUFFER_ENTER_ONCE, function(state)
    if not vim.__buf.is_valid(state.buf) then
      return
    end

    if vim.__buf.filetype(state.buf) ~= "ClangdTypeHierarchy" then
      return
    end

    vim.__key.hide(kmodes.N, "d.", { buffer = state.buf })
    vim.__key.hide(kmodes.N, "d,", { buffer = state.buf })
    vim.__key.hide(kmodes.N, "dd", { buffer = state.buf })
    vim.__key.hide(kmodes.N, "dD", { buffer = state.buf })
    vim.__key.hide(kmodes.N, "dp", { buffer = state.buf })

    vim.__key.unrg(kmodes.N, "rc", { buffer = state.buf })

    local maparg = vim.__key.get(kmodes.N, "gd", state.buf)
    if maparg then
      vim.__key.unrg(kmodes.N, "gd", { buffer = state.buf })
      vim.__key.rg(kmodes.N, "de", maparg.callback, { buffer = state.buf, desc = "jump to definition." })
    end

    vim.__key.rg(kmodes.N, "<ESC>", function()
      local winid = is_open_extensions("ClangdTypeHierarchy")
      if winid < 0 then
        return
      end

      vim.__win.close(winid)
    end, { buffer = state.buf })
  end)
end

M.setup = function(cfg)
  setup_server(cfg)
  setup_keymaps(cfg)
end

return M

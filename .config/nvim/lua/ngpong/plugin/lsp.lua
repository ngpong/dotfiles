local kmodes = vim.__key.e_mode
local etypes = vim.__event.types

return {
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "LazyFile", "VeryLazy" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "j-hui/fidget.nvim",
    },
    highlights = {
      { "LspInfoBorder"      , fg = vim.__color.light1 },
      { "DiagnosticSignError", fg = vim.__color.bright_red },
      { "DiagnosticSignWarn" , fg = vim.__color.bright_yellow },
      { "DiagnosticSignInfo" , fg = vim.__color.bright_blue },
      { "DiagnosticSignHint" , fg = vim.__color.bright_aqua },
    },
    keys = {
      { "[d"        , function() vim.diagnostic.jump({ count = -1 }) end },
      { "]d"        , function() vim.diagnostic.jump({ count = 1 }) end },
      { "<leader>dd", function() t_api.toggle("document_diagnostics") end },
      { "<leader>dD", function() t_api.toggle("workspace_diagnostics") end },
      { "<leader>dp", function() vim.diagnostic.open_float() end },
    },
    opts = {
      keys = {
        { "<leader>ls", "textDocument/documentSymbol", function() t_api.toggle("lsp_document_symbols_extra") end },
        { "gr"        , "textDocument/references"    , function() vim.lsp.buf.references() --[[ t_api.open("lsp_references_extra") --]] end },
        { "gd"        , "textDocument/definition"    , function() vim.lsp.buf.definition() --[[ t_api.open("lsp_definitions_extra") --]] end  },
        { "gD"        , "textDocument/declaration"   , function() vim.lsp.buf.declaration() --[[ t_api.open("lsp_declarations_extra") --]] end },
        { "fr"        , "textDocument/rename"        , function() vim.lsp.buf.rename() end },
        { "fa"        , "textDocument/codeAction"    , function() vim.lsp.buf.code_action() end },
        {
          "<leader>lk",
          "textDocument/signatureHelp",
          function()
            vim.lsp.buf.signature_help {
              border = "rounded",
              relative = "cursor",
              silent = true,
            }
          end
        },
        {
          "<leader>li",
          "textDocument/hover",
          function()
            vim.lsp.buf.hover {
              border = "rounded",
              relative = "cursor",
              silent = true,
            }
          end
        },
      },
      inlay_hints = {
        enabled = false,
      },
      codelens = {
        enabled = false,
      },
      diagnostics = {
        underline = {
          severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.INFO,
            vim.diagnostic.severity.HINT,
          },
        },
        update_in_insert = false, -- https://github.com/neovim/neovim/issues/26078
        virtual_text = {
          spacing = 1,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        jump = { -- vim.diagnostic.JumpOpts
          float = true,
          wrap = false,
        },
        float = { -- vim.diagnostic.Opts.Float
          scope = "line",
          border = vim.__icons.border.no,
          relative = "cursor",
        },
        signs = false,
        -- signs = {
        --   text = {
        --     [vim.diagnostic.severity.ERROR] = vim.__icons.diagnostic_err,
        --     [vim.diagnostic.severity.WARN]  = vim.__icons.diagnostic_warn,
        --     [vim.diagnostic.severity.INFO]  = vim.__icons.diagnostic_info,
        --     [vim.diagnostic.severity.HINT]  = vim.__icons.diagnostic_hint,
        --   },
        -- },
      },
      capabilities = {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true
          }
        }
      },
      on_attach = function(cli, bufnr)
        -- 禁用lsp提供的格式化能力
        -- cli.server_capabilities.documentFormattingProvider = false
        -- cli.server_capabilities.documentOnTypeFormattingProvider = false
        -- cli.server_capabilities.documentRangeFormattingProvider = false

        -- 禁用lsp提供的高亮能力
        -- cli.server_capabilities.semanticTokensProvider = nil
      end
    },
    config = function(_, opts)
      -- 禁用日志
      vim.lsp.set_log_level("off")

      -- setup diagnostic
      vim.diagnostic.config(opts.diagnostics)

      -- setup lsp keys
      vim.__event.rg(etypes.ATTACH_LSP, function(state)
        local cli   = state.cli
        local bufnr = state.bufnr

        for _, spec in ipairs(opts.keys) do
          if cli:supports_method(spec[2]) then
            vim.__key.rg(vim.__key.e_mode.N, spec[1], spec[3], { buffer = bufnr })
          end
        end

        local server = opts.servers[cli.name]
        if server.enabled then
          for _, spec in ipairs(server.keys or {}) do
            vim.__key.rg(spec.mode or kmodes.N, spec[1], spec[2], { buffer = bufnr, silent = spec.silent or nil })
          end
        end
      end)

      -- setup options
      vim.__event.rg(etypes.ATTACH_LSP, function(state, e)
        local cli   = state.cli
        local bufnr = state.bufnr

        -- options
        -- https://neovim.io/doc/user/lsp.html#lsp-quickstart
        -- vim.bo[bufnr].formatexpr = nil
        -- vim.bo[bufnr].omnifunc = nil
        -- vim.bo[bufnr].tagfunc = nil

        -- inlay hint
        if opts.inlay_hints.enabled and cli:supports_method("textDocument/inlayHint") then
          if vim.__buf.is_valid(bufnr) and
             vim.__buf.buftype(bufnr) == "" and
             not vim.tbl_contains(opts.inlay_hints.exclude, vim.__buf.filetype(bufnr))
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
        end

        -- code lens
        if opts.codelens.enabled and cli:supports_method("textDocument/codeLens") then
          vim.lsp.codelens.refresh()
          vim.__autocmd.on({ "BufEnter", "CursorHold", "InsertLeave" }, vim.lsp.codelens.refresh, { buffer = bufnr })
        end
      end)

      -- construct client capabilities
      local capabilities = {}
      do
        local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
        local usr_capabilities = opts.capabilities or {}

        local cmp_capabilities
        do
          local success, engine = pcall(require, "blink.cmp")
          if success then
            cmp_capabilities = engine.get_lsp_capabilities()
          else
            success, engine = pcall(require, "cmp_nvim_lsp")
            assert(success)

            cmp_capabilities = engine.default_capabilities()
          end
        end

        capabilities = vim.__tbl.rr_extend(
          {},
          cmp_capabilities,
          lsp_capabilities,
          usr_capabilities
        )
      end

      local function make_on_attach(extra)
        return function(cli, bufnr)
          opts.on_attach(cli, bufnr)
          if extra then extra(cli, bufnr) end
        end
      end
      local function setup_server(server, server_opts)
        if server_opts.enabled == false then
          return
        end

        server_opts.on_attach = make_on_attach(server_opts.on_attach)

        local final_opts = vim.__tbl.rr_extend(
          { capabilities = capabilities },
          server_opts or {}
        )

        require("lspconfig")[server].setup(final_opts)
      end

      for server, server_opts in pairs(opts.servers) do
        setup_server(server, server_opts)
      end
    end
  },
  {
    "williamboman/mason.nvim",
    lazy = true,
    event = { "LazyFile", "VeryLazy" },
    cmd = "Mason",
    keys = {
      { "<leader>P", "<CMD>Mason<CR>", desc = "open mason package manager.", },
    },
    opts_extend = { "ensure_installed" },
    opts = {
      log_level = vim.log.levels.OFF,
      max_concurrent_installers = 16,
      PATH = "prepend", -- prepend | append | skip
      ui = {
        check_outdated_packages_on_open = false,
        border = "rounded",
        width = 0.8,
        height = 0.8,
        icons = {
          package_installed = "◍",
          package_pending = "◍",
          package_uninstalled = "◍"
        },
        keymaps = {
            toggle_package_expand = "<CR>",
            install_package = "i",
            uninstall_package = "x",
            update_package = "u",
            update_all_packages = "U",
            check_package_version = "c",
            check_outdated_packages = "C",
            cancel_installation = "<C-c>",
            apply_language_filter = "f",
            toggle_package_install_log = "<CR>",
            toggle_help = "?",
        },
      },
      pip = {
        upgrade_pip = false,
        install_args = { "--proxy", "http://127.0.0.1:7890" },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      require("mason-lspconfig").setup()

      local mr         = require("mason-registry")
      local server_map = require("mason-lspconfig.mappings.server").lspconfig_to_package or {}

      local is_trigger_filetype = {}
      mr:on("package:install:success", vim.schedule_wrap(function(p)
        vim.__notifier.info(string.format("%s: successfully installed", p.name))

        vim.defer_fn(function()
          if not server_map[p.name] then
            return
          end

          local bufnr = vim.__buf.current()
          if is_trigger_filetype[bufnr] then
            return
          end
          is_trigger_filetype[bufnr] = true

          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.__buf.current(),
          })
        end, 100)
      end))

      mr:on("package:install:failed", vim.schedule_wrap(function(p)
        vim.__notifier.err(string.format("%s: failed to install", p.name))
      end))

      local function do_install(update)
        local servers = {}
        for server, server_opts in pairs(vim.__plugin.opts("nvim-lspconfig").servers) do
          if server_opts.mason_install ~= false then
            table.insert(servers, server)
          end
        end

        local ensure_installed = {}
        vim.__tbl.insert_arr(ensure_installed, opts.ensure_installed)
        vim.__tbl.insert_arr(ensure_installed, servers)

        for _, name in ipairs(ensure_installed) do
          name = server_map[name] or name

          if not mr.is_installed(name) then
            mr.get_package(name):install()
          elseif update then
            local p = mr.get_package(name)
            p:check_new_version(function(ok, version)
              if ok then
                p:install({ version = version.latest_version })
              end
            end)
          end
        end
      end
      local function install_necessary()
        local last_update_marker
        do
          local mason_settings = require("mason.settings").current
          local mason_root = mason_settings.install_root_dir
          last_update_marker = vim.__path.join(mason_root, "registry-last-update")
        end

        local content     = vim.__fs.read(last_update_marker)
        local last_update = content and tonumber(vim.trim(content))

        if not last_update or last_update <= 0 then
          last_update = 0
        end

        local now = vim.__timestamp.get_utc() or 0
        local max = 1000 * 60 * 60 * 24 * 7 -- 7天

        if now - last_update > max then
          vim.__fs.write(last_update_marker, tostring(now))
          mr.update(function(success)
            if not success then return vim.__notifier.err("update mason registry faild") end
            do_install(true)
          end)
        else
          do_install()
        end
      end

      install_necessary()
    end
  },
  {
    "j-hui/fidget.nvim",
    lazy = true,
    highlights = {
      { "FidgetOptsProgress", fg = vim.__color.light2 },
      { "FidgetOptsDone", fg = vim.__color.light2 },
      { "FidgetOptsGroup", fg = vim.__color.light2 },
      { "FidgetOptsIcon", fg = vim.__color.bright_green },
      { "FidgetOptsNotifyWindow", fg = vim.__color.gray },
    },
    opts = function() return {
      progress = {
        poll_rate = 0,
        suppress_on_insert = false,
        ignore_done_already = true,
        ignore_empty_message = true,
        ignore = {},
        display = {
          render_limit = 16,
          done_ttl = 2,
          done_icon = vim.__icons.spinner_frames_6.ok,
          progress_icon = { pattern = { unpack(vim.__icons.spinner_frames_6.spinner) }, period = 1 },
          progress_style = "FidgetOptsProgress",
          done_style = "FidgetOptsDone",
          group_style = "FidgetOptsGroup",
          icon_style = "FidgetOptsIcon",
          priority = 30,
          skip_history = true,
          format_group_name = function(group) return require("mason-lspconfig.mappings.server").lspconfig_to_package[group] or tostring(group) end, -- How to format a progress notification group's name
          overrides = {},
        },
      },
      notification = {
        override_vim_notify = false,
        configs = { default = vim.__tbl.r_extend(
          require("fidget.notification").default_config,
          { icon_on_left = true }
        )},
        redirect = false,
        view = {
          stack_upwards = false,
          icon_separator = " ",
          group_separator = "---",
          group_separator_hl = "Comment",
        },
        window = {
          normal_hl = "FidgetOptsNotifyWindow",
          winblend = 5,
          border = "none",
          zindex = 45,
          max_width = 0,
          max_height = 0,
          x_padding = 0,
          y_padding = 0,
          align = "bottom",
          relative = "editor",
        },
      },
      integration = {
        ["nvim-tree"] = {
          enable = false,
        },
        ["xcodebuild-nvim"] = {
          enable = false,
        },
      },
      logger = {
        level = vim.log.levels.ERROR,
        path = string.format("%s/fidget.nvim.log", vim.__path.standard("state")),
      },
    } end
  },
}
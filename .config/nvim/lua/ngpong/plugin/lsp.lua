return {
  {
    "neovim/nvim-lspconfig",
    main = "lspconfig",
    lazy = true,
    event = { "LazyFile", "VeryLazy" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "j-hui/fidget.nvim",
    },
    keys = {
      { "[d", function() vim.diagnostic.jump({ count = -1 }) end },
      { "]d", function() vim.diagnostic.jump({ count = 1 }) end },
      {
        "fd",
        function()
          for _, winid in ipairs(vim.__win.all()) do
            if vim.w[winid].line ~= nil then
              return vim.__win.close(winid)
            end
          end

          vim.diagnostic.open_float({ focusable = false, width = 60 })
        end
      },
    },
    autocmds = {
      {
        "User",
        vim.schedule_wrap(function(args)
          for _, wininfo in ipairs(args.data.wininfos) do
            local winid = wininfo.winid
            local variables = wininfo.variables
            if vim.__win.is_valid then
              if variables.line ~= nil or variables.lsp_floating_bufnr ~= nil then
                vim.__win.close(winid)
              end
            end
          end
        end),
        pattern = "UserPress_CTRLC"
      },
      {
        "User",
        function(args)
          for _, wininfo in ipairs(args.data.wininfos) do
            local variables = wininfo.variables
            if variables.line ~= nil or variables.lsp_floating_bufnr ~= nil then
              return vim.api.nvim_win_call(wininfo.winid, function()
                vim.cmd(string.format("normal! %s", vim.__key.kcode("<C-u>")))
              end)
            end
          end
        end,
        pattern = "UserPress_CTRLY"
      },
      {
        "User",
        function(args)
          for _, wininfo in ipairs(args.data.wininfos) do
            local variables = wininfo.variables
            if variables.line ~= nil or variables.lsp_floating_bufnr ~= nil then
              return vim.api.nvim_win_call(wininfo.winid, function()
                vim.cmd(string.format("normal! %s", vim.__key.kcode("<C-d>")))
              end)
            end
          end
        end,
        pattern = "UserPress_CTRLE"
      }
    },
    opts = {
      keys = {
        { "gr", "textDocument/references"    , function() vim.__trouble:open("lsp_references_extra") end },
        { "gd", "textDocument/definition"    , function() vim.__trouble:open("lsp_definitions_extra") end  },
        { "gD", "textDocument/declaration"   , function() vim.__trouble:open("lsp_declarations_extra") end },
        { "gi", "textDocument/implementation", function() vim.__trouble:open("lsp_implementations_extra") end },
        { "fr", "textDocument/rename"        , function() vim.lsp.buf.rename() end },
        { "fa", "textDocument/codeAction"    , function() vim.lsp.buf.code_action() end },
        {
          "fi",
          "textDocument/signatureHelp",
          function()
            for _, winid in ipairs(vim.__win.all()) do
              if vim.w[winid].lsp_floating_bufnr ~= nil then
                return vim.__win.close(winid)
              end
            end

            vim.lsp.buf.signature_help {
              focusable = false,
              border = vim.__icons.border.no,
              relative = "cursor",
              silent = true,
            }
          end
        },
        {
          "fk",
          "textDocument/hover",
          function()
            for _, winid in ipairs(vim.__win.all()) do
              if vim.w[winid].lsp_floating_bufnr ~= nil then
                return vim.__win.close(winid)
              end
            end

            vim.lsp.buf.hover {
              focusable = false,
              border = vim.__icons.border.no,
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
      renamed = {
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
        update_in_insert = true, -- actually hide_in_insert, see: https://github.com/neovim/neovim/issues/26078
        virtual_text = {
          spacing = 1,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        jump = { -- vim.diagnostic.JumpOpts
          float = false,
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
        --     [vim.diagnostic.severity.ERROR] = vim.__icons.diagnostic_error,
        --     [vim.diagnostic.severity.WARN]  = vim.__icons.diagnostic_warn,
        --     [vim.diagnostic.severity.INFO]  = vim.__icons.diagnostic_info,
        --     [vim.diagnostic.severity.HINT]  = vim.__icons.diagnostic_hint,
        --   },
        --   linehl = {
        --     [vim.diagnostic.severity.ERROR] = "DiagnosticErrorLn",
        --     [vim.diagnostic.severity.WARN]  = "DiagnosticWarnLn",
        --     [vim.diagnostic.severity.INFO]  = "DiagnosticInfoLn",
        --     [vim.diagnostic.severity.HINT]  = "DiagnosticHintLn",
        --   },
        -- },
      },
      capabilities = {},
      server_capabilities = {
        -- 禁用lsp提供的格式化能力
        -- documentFormattingProvider = false,
        -- documentOnTypeFormattingProvider = false,
        -- documentRangeFormattingProvider = false,

        -- 禁用lsp提供的高亮能力
        -- semanticTokensProvider = false,
      },
      on_attach = function(cli, bufnr, opts)
        cli.server_capabilities = vim.__tbl.rr_extend(
          {},
          cli.server_capabilities,
          opts.server_capabilities
        )
      end
    },
    config = function(_, opts)
      -- 禁用日志
      vim.lsp.set_log_level("off")

      -- setup diagnostic
      vim.diagnostic.config(opts.diagnostics)

      -- setup opts && keymaps
      vim.__autocmd.on("LspAttach", function(state)
        local bufnr = state.buf

        local cli = vim.lsp.get_client_by_id(state.data.client_id)
        if not cli then
          return
        end

        -- setup lsp keys
        do
          for _, spec in ipairs(opts.keys) do
            if cli:supports_method(spec[2]) then
              vim.__key.rg("n", spec[1], spec[3], { buffer = bufnr })
            end
          end

          local server_opts = opts.servers[cli.name]
          if server_opts.enabled ~= false then
            for _, spec in ipairs(server_opts.keys or {}) do
              vim.__key.rg(spec.mode or "n", spec[1], spec[2], { buffer = bufnr, silent = spec.silent or nil })
            end
          end
        end

        -- setup options
        do
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
        end
      end)

      -- 文件改名时触发 lsp-renamed action
      if opts.renamed.enabled then
        local NvimTreeEvent = require("nvim-tree.api").events

        local prev_node = { new_name = "", old_name = "" }
        NvimTreeEvent.subscribe(NvimTreeEvent.Event.NodeRenamed, function(state)
          if prev_node.new_name ~= state.new_name or prev_node.old_name ~= state.old_name then
            prev_node = state
            require("snacks").rename.on_rename_file(state.old_name, state.new_name)
          end
        end)

        local capabilities = vim.__tbl.rr_extend({}, {
            opts.capabilities,
            workspace = {
              fileOperations = {
                didRename = true,
                willRename = true,
              },
              didChangeWatchedFiles = {
                dynamicRegistration = true
              }
            },
          }
        )
        local server_capabilities = vim.__tbl.rr_extend({}, {
          opts.server_capabilities,
          workspace = {
            fileOperations = {
              didRename = true
            }
          }
        })
        opts.capabilities = capabilities
        opts.server_capabilities = server_capabilities
      end

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
            if not success then
              cmp_capabilities = {}
            else
              cmp_capabilities = engine.default_capabilities()
            end
          end
        end

        capabilities = vim.__tbl.rr_extend(
          {},
          lsp_capabilities,
          cmp_capabilities,
          usr_capabilities
        )
      end

      local function make_on_attach(extra)
        return function(cli, bufnr)
          opts.on_attach(cli, bufnr, opts)
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

        if server_opts.config then
          server_opts.config()
        end

        require("lspconfig")[server].setup(final_opts)
      end

      for server, server_opts in pairs(opts.servers) do
        setup_server(server, server_opts)
      end
    end
  },
  {
    "williamboman/mason.nvim",
    main = "mason",
    lazy = true,
    event = { "LazyFile", "VeryLazy" },
    cmd = "Mason",
    highlights = {
      { "MasonHeader", bg = vim.__color.dark0_soft, fg = vim.__color.dark0_soft }
    },
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
        border = vim.__icons.border.no,
        width = 0.8,
        height = 0.8,
        backdrop = 100,
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

      local mr = require("mason-registry")

      local is_trigger_filetype = {}
      mr:on("package:install:success", vim.schedule_wrap(function(p)
        vim.__echo.info(string.format("%s: successfully installed", p.name))

        vim.defer_fn(function()
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
        vim.__echo.err(string.format("%s: failed to install", p.name))
      end))

      local function do_install(update)
        for _, name in ipairs(opts.ensure_installed) do
          if not mr.is_installed(name) then
            mr.get_package(name):install()
          elseif update then
            local p = mr.get_package(name)

            local current_version = p:get_installed_version()
            local latest_version = p:get_latest_version()
            if current_version ~= latest_version then
              p:install({ version = latest_version })
            end
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
            if not success then return vim.__echo.err("update mason registry faild") end
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
    main = "fidget",
    lazy = true,
    highlights = {
      { "FidgetOptsProgress", fg = vim.__color.light2 },
      { "FidgetOptsDone", fg = vim.__color.light2 },
      { "FidgetOptsGroup", fg = vim.__color.light2 },
      { "FidgetOptsIcon", fg = vim.__color.bright_blue },
      { "FidgetOptsNotifyWindow", fg = vim.__color.gray },
    },
    opts = {
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
          -- format_group_name = function(group) return require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package[group] or tostring(group) end, -- How to format a progress notification group's name
          overrides = {},
        },
      },
      notification = {
        override_vim_notify = false,
        configs = {
          default = {
            icon_on_left = true
          }
        },
        redirect = false,
        view = {
          stack_upwards = false,
          icon_separator = " ",
          group_separator = "---",
          group_separator_hl = "Comment",
        },
        window = {
          normal_hl = "FidgetOptsNotifyWindow",
          winblend = 20,
          border = "none",
          zindex = 1,
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
    },
    config = function(_, opts)
      local notification_default_config = require("fidget.notification").default_config
      opts.notification.configs.default = vim.__tbl.rr_extend(
        notification_default_config,
        opts.notification.configs.default
      )

      require("fidget").setup(opts)
    end
  },
}

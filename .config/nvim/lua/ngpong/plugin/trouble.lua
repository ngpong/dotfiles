return {
  {
    "folke/trouble.nvim",
    main = "trouble",
    lazy = true,
    cmd = { "TroubleToggle", "Trouble" },
    autocmds = {
      {
        "FileType",
        function(args)
          local bufnr = args.buf

          local view = vim.__trouble:find_view({ bufnr = bufnr })
          if not view then
            return
          end

          vim.__autocmd.exec("User", {
            data = { bufnr = bufnr, mode = view.opts.mode },
            pattern = "TroubleWinMount"
          })

          vim.__autocmd.on("BufWipeout", function()
            vim.__autocmd.exec("User", {
              data = { bufnr = bufnr, mode = view.opts.mode },
              pattern = "TroubleWinClose"
            })
          end, { once = true, buffer = bufnr })
        end,
        pattern = "trouble"
      }
    },
    dispatchs = {
      {
        "trouble",
        function(this)
          function this:open(mode, opts)
            local default_opts = {
              mode = mode or "",
            }
            opts = vim.__tbl.rr_extend(opts or {}, default_opts)

            return require("trouble.api").open(opts)
          end

          function this:find_view(args)
            local mode = args.mode
            local bufnr = args.bufnr

            for view, _ in pairs(require("trouble.view")._views or {}) do
              if view.win:valid() or view.opts.auto_open or view.first_update:is_pending() then
                if mode and bufnr then
                  if view.opts.mode == mode and view.win.buf == bufnr then
                    return view
                  end
                elseif mode then
                  if view.opts.mode == mode then
                    return view
                  end
                elseif bufnr then
                  if view.win.buf == bufnr then
                    return view
                  end
                end
              end
            end

            return nil
          end
        end
      }
    },
    keys = {
      { "<leader>t<leader>", function() vim.cmd("Trouble") end, },
      { "<leader>td", function() vim.__trouble:open("document_diagnostics") end, },
      { "<leader>tD", function() vim.__trouble:open("workspace_diagnostics") end, },
      { "<leader>tb", function() vim.__trouble:open("buffers") end, },
      { "<leader>tm", function() vim.__trouble:open("bookmarks") end, },
      { "<leader>tf", function() vim.__trouble:open("snacks_picker") end, },
      { "<leader>ts", function() vim.__trouble:open("symbols") end, },
    },
    opts = {
      auto_close = false,
      auto_open = false, -- auto open when there are items
      auto_preview = false, -- automatically open preview when on an item
      auto_refresh = true, -- auto refresh when open
      auto_jump = false, -- auto jump to the item when there"s only one
      focus = true, -- Focus the window when opened
      restore = true, -- restores the last location in the list when opening
      follow = false, -- Follow the current item
      indent_guides = true, -- show indent guides
      max_items = 200, -- limit number of items that can be displayed per section
      multiline = true, -- render multi-line messages
      pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
      warn_no_results = true, -- show a warning when there are no results
      open_no_results = false, -- open the trouble window when there are no results
      win = { -- window options for the results window. Can be a split or a floating window.
        size = { height = 0.35 },
        wo = {
          winhighlight = table.concat({
            "Normal:TroubleNormal",
            "NormalNC:TroubleNormalNC",
            "EndOfBuffer:TroubleNormal",
            "CursorLine:TroubleCursorLine",
          }, ","),
        },
      },
      preview = {
        type = "main",
        scratch = true,
        -- type = "split",
        -- relative = "win",
        -- position = "right",
        -- size = 0.65,
        -- scratch = true,
      },
      throttle = {
        refresh = 100,
        update = 10,
        render = 10,
        follow = 100,
        preview = { ms = 50, debounce = true },
      },
      keys = {
        ["?"] = false,
        ["R"] = false,
        ["<2-leftmouse>"] = false,
        ["gb"] = false,
        ["s"] = false,
        ["zo"] = false,
        ["zO"] = false,
        ["zc"] = false,
        ["zC"] = false,
        ["za"] = false,
        ["zA"] = false,
        ["zm"] = false,
        ["zM"] = false,
        ["zr"] = false,
        ["zR"] = false,
        ["zx"] = false,
        ["zX"] = false,
        ["zn"] = false,
        ["zN"] = false,
        ["zi"] = false,
        ["dd"] = false,
        ["d"] = false,
        ["i"] = false,
        ["p"] = false,
        ["P"] = false,
        ["]]"] = false,
        ["[["] = false,
        ["<c-v>"] = false,
        ["<c-s>"] = false,
        ["{"] = false,
        ["}"] = false,
        ["<esc>"] = false,

        ["E"] = "fold_open_all",
        ["W"] = "fold_close_all",
        ["r"] = "refresh",
        ["q"] = "close",
        ["o"] = "jump",
        ["O"] = "fold_close",
        ["<cr>"] = "jump",
        ["<c-o>s"] = "jump_split",
        ["<c-o><c-s>"] = "jump_split",
        ["<c-o>v"] = "jump_vsplit",
        ["<c-o><c-v>"] = "jump_vsplit",
        ["<C-e>"] = function(self)
          local winid = self.preview_win.win
          if not winid then
            return
          end
          vim.api.nvim_win_call(winid, function()
            vim.cmd(string.format("normal! %s", vim.__key.kcode("<C-d>")))
          end)
        end,
        ["<C-y>"] = function(self)
          local winid = self.preview_win.win
          if not winid then
            return
          end
          vim.api.nvim_win_call(winid, function()
            vim.cmd(string.format("normal! %s", vim.__key.kcode("<C-u>")))
          end)
        end,
        ["<c-g>"] = function(self, ctx)
          self.opts.auto_preview = not self.opts.auto_preview
          if self.opts.auto_preview then
            if ctx.item then
              self:preview()
            end
          else
            require("trouble.view.preview").close()
          end
        end,
      },
      modes = {
        lsp_base = {
          groups = false,
          format = "{file}{text:ts} ({item.client})",
        },
        lsp_definitions_extra = {
          events = {},
          auto_jump = true,
          mode = "lsp_base",
          title = "{hl:TroubleTitle}Lsp Definitions",
          source = "lsp.definitions",
          desc = "Lsp definitions",
        },
        lsp_references_extra = {
          events = {},
          params = {
            include_declaration = false,
          },
          title = "{hl:TroubleTitle}Lsp References",
          auto_jump = false,
          mode = "lsp_base",
          source = "lsp.references",
          desc = "Lsp references",
        },
        lsp_implementations_extra = {
          events = {},
          auto_jump = true,
          title = "{hl:TroubleTitle}Lsp Implementations",
          mode = "lsp_base",
          source = "lsp.implementations",
          desc = "Lsp implementations",
        },
        lsp_declarations_extra = {
          events = {},
          auto_jump = true,
          title = "{hl:TroubleTitle}Lsp Declarations",
          mode = "lsp_base",
          source = "lsp.declarations",
          desc = "Lsp declarations",
        },
        diagnostics = {
          groups = false,
        },
        document_diagnostics = {
          mode = "diagnostics",
          filter = { buf = 0 },
          title = "{hl:TroubleTitle}Document Diagnostics",
          format = "{diagnostic_info}{file}",
          desc = "Document diagnostics",
        },
        workspace_diagnostics = {
          mode = "diagnostics",
          title = "{hl:TroubleTitle}Workspace Diagnostics",
          desc = "Workspace diagnostics",
          format = "{diagnostic_info}{file}",
        },
        qflist = {
          title = "{hl:TroubleTitle}Quckfix List",
        },
        locflist = {
          title = "{hl:TroubleTitle}Location List",
        },
      },
      formatters = {
        comma = function(_)
          return {
            text = ":",
            hl = "TroubleComma"
          }
        end,
        pos = function(ctx)
          local hl = "TroublePos"
          if ctx.item.invalid_pos then
            hl = "TroubleInvalidPos"
          end

          local pos = ctx.item.pos
          if not pos then
            return {
              text = "",
            }
          end

          return {
            text = string.format("[%d,%d]", pos[1], pos[2] + 1),
            hl = hl
          }
        end,
        file_icon = function(ctx)
          local filename = ctx.item.filename
          local basename = vim.__path.basename(filename)
          local icon, hl = vim.__icons.get_icon_color(basename)
          return { text = icon, hl = hl }
        end,
        file = function(ctx)
          local item = ctx.item

          local form = {}

          local filename = item.filename
          if filename then
            local basename = vim.__path.basename(filename)
            local icon, icon_hl = vim.__icons.get_icon_color(basename)

            local is_pinned = item.item.is_pinned

            table.insert(form, {
              text = icon,
              hl = icon_hl
            })
            table.insert(form, {
              text = " ",
            })
            table.insert(form, {
              text = vim.__path.relpath(filename, vim.__path.cwd()),
              hl = is_pinned and "TroubleBufPin" or nil
            })
          end

          local pos = item.pos
          if pos then
            local lnum = pos[1] or 1
            local col  = pos[2] or 0
            col = col + 1

            table.insert(form, {
              text = ":",
              hl = "TroubleComma"
            })
            table.insert(form, {
              text = tostring(lnum),
              hl = "TroubleRow"
            })
            table.insert(form, {
              text = ":",
              hl = "TroubleComma"
            })
            table.insert(form, {
              text = tostring(col),
              hl = "TroubleCol"
            })
          end

          if next(form) then
            table.insert(form, {
              text = " "
            })
          end

          return form
        end,
        diagnostic_info = function(ctx)
          local severity = ctx.item.item.severity
          local message  = ctx.item.item.message
          local code     = ctx.item.item.code
          local source   = ctx.item.item.source

          local form = {}

          if severity then
            local icon = vim.__plugin.opts("trouble.nvim").icons.diagnostic_severity[severity]
            local icon_hl
            if severity == 1 then
              icon_hl = "DiagnosticError"
            elseif severity == 2 then
              icon_hl = "DiagnosticWarn"
            elseif severity == 3 then
              icon_hl = "DiagnosticInfo"
            elseif severity == 4 then
              icon_hl = "DiagnosticHint"
            end
            table.insert(form, {
              text = icon,
              hl = icon_hl
            })
          end

          if message then
            table.insert(form, {
              text = " ",
            })
            table.insert(form, {
              text = message,
            })
          end

          if source then
            table.insert(form, {
              text = " ",
            })
            table.insert(form, {
              text = source,
              hl = "TroubleDiagnosticsItemSource"
            })
          end

          if code then
            table.insert(form, {
              text = " ",
            })
            table.insert(form, {
              text = string.format("(%s)", code),
              hl = "TroubleCode"
            })
          end

          if next(form) then
            table.insert(form, {
              text = " ",
            })
          end

          return form
        end,
        severity_icon = function(ctx)
          local severity = ctx.item.severity or 1

          local opts_icons = vim.__plugin.opts("trouble.nvim").icons

          local icon = opts_icons.diagnostic_severity[severity]
          local hl
          if severity == 1 then
            hl = "DiagnosticError"
          elseif severity == 2 then
            hl = "DiagnosticWarn"
          elseif severity == 3 then
            hl = "DiagnosticInfo"
          elseif severity == 4 then
            hl = "DiagnosticHint"
          end

          return {
            text = icon,
            hl = hl
          }
        end,
      },
    },
    hackers = {
      before = {
        -- 性能更好的 get_icon
        function()
          require("trouble.format").get_icon = vim.__icons.get_icon_color
        end,
        -- 当没有结果时的提示内容
        function()
          local warn = require("trouble.util").warn
          require("trouble.util").warn = function(msg, opts)
            if type(msg) == "table" and msg[1] then
              local match = msg[1]:match("^No results for %*%*(.-)%*%*")
              if not vim.__util.isempty(match) then
                msg = "No results for " .. match
              end
            end

            warn(msg, opts)
          end
        end,
        -- 当不存在 treesitter 的 paser 时不提醒
        function()
          local _attach_lang = require("trouble.view.treesitter")._attach_lang
          local notify_once = vim.notify_once
          require("trouble.view.treesitter")._attach_lang = function(...)
            vim.notify_once = function() end
            local ret = _attach_lang(...)
            vim.notify_once = notify_once
            return ret
          end
        end,
        function()
          require("trouble.item").generate_id = function(item)
            if item.id then
              return item.id
            end

            assert(item.source)

            return table.concat({
              item.source,
              item.filename or "",
              item.pos[1] or "",
              item.pos[2] or "",
              item.end_pos[1] or "",
              item.end_pos[2] or "",
              vim.__util.rand()
            }, ":")
          end
        end,
      }
    }
  },
  {
    "folke/trouble.nvim",
    opts = {
      -- stylua: ignore
      icons = {
        indent = {
          top = "",
          middle = "",
          last = "",
          ws = "",
          fold_open = "",
          fold_closed = "",
        },
        diagnostic_severity = {
          [vim.diagnostic.severity.ERROR] = vim.__icons.diagnostic_error,
          [vim.diagnostic.severity.WARN]  = vim.__icons.diagnostic_warn,
          [vim.diagnostic.severity.INFO]  = vim.__icons.diagnostic_info,
          [vim.diagnostic.severity.HINT]  = vim.__icons.diagnostic_hint,
        },
        folder_open = vim.__icons.directory_opened,
        folder_closed = vim.__icons.directory,
        kinds = {
          Array         = vim.__icons.lsp_kinds.Array.val,
          Boolean       = vim.__icons.lsp_kinds.Boolean.val,
          Class         = vim.__icons.lsp_kinds.Class.val,
          Constant      = vim.__icons.lsp_kinds.Constant.val,
          Constructor   = vim.__icons.lsp_kinds.Constructor.val,
          Enum          = vim.__icons.lsp_kinds.Enum.val,
          EnumMember    = vim.__icons.lsp_kinds.EnumMember.val,
          Event         = vim.__icons.lsp_kinds.Event.val,
          Field         = vim.__icons.lsp_kinds.Field.val,
          File          = vim.__icons.lsp_kinds.File.val,
          Function      = vim.__icons.lsp_kinds.Function.val,
          Interface     = vim.__icons.lsp_kinds.Interface.val,
          Key           = vim.__icons.lsp_kinds.Key.val,
          Method        = vim.__icons.lsp_kinds.Method.val,
          Module        = vim.__icons.lsp_kinds.Module.val,
          Namespace     = vim.__icons.lsp_kinds.Namespace.val,
          Null          = vim.__icons.lsp_kinds.Null.val,
          Number        = vim.__icons.lsp_kinds.Number.val,
          Object        = vim.__icons.lsp_kinds.Object.val,
          Operator      = vim.__icons.lsp_kinds.Operator.val,
          Package       = vim.__icons.lsp_kinds.Package.val,
          Property      = vim.__icons.lsp_kinds.Property.val,
          String        = vim.__icons.lsp_kinds.String.val,
          Struct        = vim.__icons.lsp_kinds.Struct.val,
          TypeParameter = vim.__icons.lsp_kinds.TypeParameter.val,
          Variable      = vim.__icons.lsp_kinds.Variable.val,
        },
      },
    },
    highlights = {
      { "TroubleNormal", bg = vim.__color.dark0_hard },
      { "TroubleNormalNC", bg = vim.__color.dark0_hard },
      { "TroubleCursorLine", link = "CursorLineDark" },
      { "TroublePreview", link = "Search" },
      { "TroubleIndent", fg = vim.__color.dark1 },
      { "TroubleFoldIcon", fg = vim.__color.dark4 },
      { "TroubleIndentFoldClosed", link = "TroubleFoldIcon" },
      { "TroubleIndentFoldOpen", link = "TroubleFoldIcon" },
      { "TroubleSignOther", fg = vim.__color.bright_green },
      { "TroubleSignHint", link = "DiagnosticHint" },
      { "TroubleSignError", link = "DiagnosticError" },
      { "TroubleSignWarning", link = "DiagnosticWarn" },
      { "TroubleSignInformation", link = "DiagnosticInfo" },
      { "TroubleCount", fg = vim.__color.bright_orange, bg = vim.__color.dark2 },
      { "TroubleTextHint", fg = vim.__color.light1 },
      { "TroubleTextInformation", fg = vim.__color.light1 },
      { "TroubleTextWarning", fg = vim.__color.light1 },
      { "TroubleTextError", fg = vim.__color.light1 },
      { "TroubleFilename", fg = vim.__color.light1 },
      { "TroublePos", fg = vim.__color.dark3 },
      { "TroubleDirectory", fg = vim.__color.light1 },
      { "TroubleInvalidPos", fg = vim.__color.light1, bg = vim.__color.bright_red },
      { "TroubleWinSeparator", bg = vim.__color.bright_red, fg = vim.__color.bright_red },
      { "TroubleComma", fg = vim.__color.bright_purple },
      { "TroubleRow", fg = vim.__color.bright_orange },
      { "TroubleCol", fg = vim.__color.bright_orange },
      { "TroubleBufPin", fg = vim.__color.bright_red, bold = true },
      { "TroubleTitle", fg = vim.__color.light2, bold = true, italic = true },

      { "TroubleIconDirectory", link = "DirectoryIcon" },
      { "TroubleIconArray", link = vim.__icons.lsp_kinds.Array.hl },
      { "TroubleIconBoolean", link = vim.__icons.lsp_kinds.Boolean.hl },
      { "TroubleIconClass", link = vim.__icons.lsp_kinds.Class.hl },
      { "TroubleIconConstant", link = vim.__icons.lsp_kinds.Constant.hl },
      { "TroubleIconConstructor", link = vim.__icons.lsp_kinds.Constructor.hl },
      { "TroubleIconEnum", link = vim.__icons.lsp_kinds.Enum.hl },
      { "TroubleIconEnumMember", link = vim.__icons.lsp_kinds.EnumMember.hl },
      { "TroubleIconEvent", link = vim.__icons.lsp_kinds.Event.hl },
      { "TroubleIconField", link = vim.__icons.lsp_kinds.Field.hl },
      { "TroubleIconFile", link = vim.__icons.lsp_kinds.File.hl },
      { "TroubleIconFunction", link = vim.__icons.lsp_kinds.Function.hl },
      { "TroubleIconInterface", link = vim.__icons.lsp_kinds.Interface.hl },
      { "TroubleIconKey", link = vim.__icons.lsp_kinds.Key.hl },
      { "TroubleIconMethod", link = vim.__icons.lsp_kinds.Method.hl },
      { "TroubleIconModule", link = vim.__icons.lsp_kinds.Module.hl },
      { "TroubleIconNamespace", link = vim.__icons.lsp_kinds.Namespace.hl },
      { "TroubleIconNull", link = vim.__icons.lsp_kinds.Null.hl },
      { "TroubleIconNumber", link = vim.__icons.lsp_kinds.Number.hl },
      { "TroubleIconObject", link = vim.__icons.lsp_kinds.Object.hl },
      { "TroubleIconOperator", link = vim.__icons.lsp_kinds.Operator.hl },
      { "TroubleIconPackage", link = vim.__icons.lsp_kinds.Package.hl },
      { "TroubleIconProperty", link = vim.__icons.lsp_kinds.Property.hl },
      { "TroubleIconString", link = vim.__icons.lsp_kinds.String.hl },
      { "TroubleIconStruct", link = vim.__icons.lsp_kinds.Struct.hl },
      { "TroubleIconTypeParameter", link = vim.__icons.lsp_kinds.TypeParameter.hl },
      { "TroubleIconVariable", link = vim.__icons.lsp_kinds.Variable.hl },
    }
  }
}

local khelper = {
  picker = function()
    require("snacks").picker()
  end,
  resume = function()
    require("snacks").picker.resume()
  end,
  files = function()
    require("snacks").picker.files()
  end,
  diagnostics_buffer = function()
    require("snacks").picker.diagnostics_buffer()
  end,
  diagnostics = function()
    require("snacks").picker.diagnostics()
  end,
  bookmarks = function()
    require("snacks").picker.bookmarks()
  end,
  lsp_symbols = function()
    require("snacks").picker.lsp_symbols()
  end,
  treesitter = function()
    require("snacks").picker.treesitter()
  end,
  lines = function()
    require("snacks").picker.lines()
  end,
  buffers = function()
    require("snacks").picker.buffers()
  end,
  live_grep = function()
    local search
    if vim.__helper.get_mode() == "v" then
      search = vim.__helper.get_selection()
      if search == "" then
        search = nil
      end
    end
    require("snacks").picker.grep({ search = search })
  end,
  grep = function()
    local mode = vim.__helper.get_mode()
    if mode == "n" then
      vim.ui.input({ prompt = "search for: " }, function(ip)
        if ip ~= nil and ip ~= "" then
          require("snacks").picker.grep({ search = ip, live = false })
        end
      end)
    else
      local search = vim.__helper.get_selection()
      if search == "" then
        search = nil
      end
      require("snacks").picker.grep({ search = search, live = false })
    end
  end,
}

return {
  {
    "folke/snacks.nvim",
    optional = true,
    highlights = {
      { "SnacksPicker", link = "NormalFloat" },
      { "SnacksPickerBorder", link = "FloatBorder" },
      { "SnacksPickerTitle", link = "FloatTitle" },
      { "SnacksPickerMatch", fg = vim.__color.bright_red, italic = true, bold = true },
      { "SnacksPickerDir", fg = vim.__color.light1 },
      { "SnacksPickerSpinner", link = "SnacksPickerTotals" },
      { "SnacksPickerDelim", fg = vim.__color.bright_purple },
      { "SnacksPickerRow", fg = vim.__color.bright_orange },
      { "SnacksPickerCol", fg = vim.__color.bright_orange },

      { "SnacksPickerPrompt", fg = vim.__color.bright_blue },
      { "SnacksPickerInputSearch", fg = vim.__color.bright_red, italic = true, bold = true },
      { "SnacksPickerInput", bg = vim.__color.dark0_hard },
      { "SnacksPickerInputBorder", bg = vim.__color.dark0_hard, fg = vim.__color.dark1 },

      { "SnacksPickerBoxCursorLine", bg = vim.__color.bright_yellow },
      { "SnacksPickerBoxBorder", bg = vim.__color.dark0_hard, fg = vim.__color.dark0_hard },

      { "SnacksPickerPreview", bg = vim.__color.dark0_hard, fg = vim.__color.light1 },
      { "SnacksPickerPreviewBorder", bg = vim.__color.dark0_hard, fg = vim.__color.dark0_soft },
      { "SnacksPickerPreviewSignColumn", fg = vim.__color.light1 },
      { "SnacksPickerPreviewCursorLine", link = "CursorLine" },

      { "SnacksPickerList", bg = vim.__color.dark0_hard },
      { "SnacksPickerListBorder", bg = vim.__color.dark0_hard },
      { "SnacksPickerListCursorLine", bg = vim.__color.dark0_soft },

      { "SnacksPickerBufPin", fg = vim.__color.bright_red, bold = true },
      { "SnacksPickerSelected", fg = vim.__color.bright_red },
      { "SnacksPickerUnselected", fg = vim.__color.dark2 },

      { "SnacksPickerBookmark", fg = vim.__color.bright_red },

      { "SnacksPickerIconArray", link = vim.__icons.lsp_kinds.Array.hl },
      { "SnacksPickerIconBoolean", link = vim.__icons.lsp_kinds.Boolean.hl },
      { "SnacksPickerIconClass", link = vim.__icons.lsp_kinds.Class.hl },
      { "SnacksPickerIconConstant", link = vim.__icons.lsp_kinds.Constant.hl },
      { "SnacksPickerIconConstructor", link = vim.__icons.lsp_kinds.Constructor.hl },
      { "SnacksPickerIconEnum", link = vim.__icons.lsp_kinds.Enum.hl },
      { "SnacksPickerIconEnumMember", link = vim.__icons.lsp_kinds.EnumMember.hl },
      { "SnacksPickerIconEvent", link = vim.__icons.lsp_kinds.Event.hl },
      { "SnacksPickerIconField", link = vim.__icons.lsp_kinds.Field.hl },
      { "SnacksPickerIconFile", link = vim.__icons.lsp_kinds.File.hl },
      { "SnacksPickerIconFunction", link = vim.__icons.lsp_kinds.Function.hl },
      { "SnacksPickerIconInterface", link = vim.__icons.lsp_kinds.Interface.hl },
      { "SnacksPickerIconKey", link = vim.__icons.lsp_kinds.Key.hl },
      { "SnacksPickerIconMethod", link = vim.__icons.lsp_kinds.Method.hl },
      { "SnacksPickerIconModule", link = vim.__icons.lsp_kinds.Module.hl },
      { "SnacksPickerIconNamespace", link = vim.__icons.lsp_kinds.Namespace.hl },
      { "SnacksPickerIconNull", link = vim.__icons.lsp_kinds.Null.hl },
      { "SnacksPickerIconNumber", link = vim.__icons.lsp_kinds.Number.hl },
      { "SnacksPickerIconObject", link = vim.__icons.lsp_kinds.Object.hl },
      { "SnacksPickerIconOperator", link = vim.__icons.lsp_kinds.Operator.hl },
      { "SnacksPickerIconPackage", link = vim.__icons.lsp_kinds.Package.hl },
      { "SnacksPickerIconProperty", link = vim.__icons.lsp_kinds.Property.hl },
      { "SnacksPickerIconString", link = vim.__icons.lsp_kinds.String.hl },
      { "SnacksPickerIconStruct", link = vim.__icons.lsp_kinds.Struct.hl },
      { "SnacksPickerIconTypeParameter", link = vim.__icons.lsp_kinds.TypeParameter.hl },
      { "SnacksPickerIconVariable", link = vim.__icons.lsp_kinds.Variable.hl },
    },
    keys = {
      { "<leader>f<leader>", khelper.picker, },
      { "<leader>fr", khelper.resume, },
      { "<leader>ff", khelper.files, },
      { "<leader>fd", khelper.diagnostics_buffer, },
      { "<leader>fD", khelper.diagnostics, },
      { "<leader>fm", khelper.bookmarks, },
      { "<leader>fs", khelper.lsp_symbols, },
      { "<leader>fS", khelper.treesitter, },
      { "<leader>f/", khelper.lines, },
      { "<leader>fb", khelper.buffers, },
      { "<leader>fg", khelper.live_grep, mode = { "n", "v" } },
      { "<leader>fG", khelper.grep, mode = { "n", "v" } },
    },
    opts = {
      picker = {
        on_show = function()
          -- vim.cmd.stopinsert()
          vim.__autocmd.on("ModeChanged", function()
            vim.__autocmd.exec("User", { pattern = "PickerOnShow" })
            vim.__stl.redraw()
          end, { once = true })
        end,
        on_close = function()
          vim.__autocmd.exec("User", { pattern = "PickerOnClose" })
          vim.__stl.redraw()
        end,
        actions = {
          nop = function(_) return true end,
          trouble_open = function(...)  return require("trouble.sources.snacks_picker").open(...) end
        },
        win = {
          input = {
            keys = {
              ["<C-a>"] = { "select_all", mode = "i" },
              ["<C-q>"] = { "qflist", mode = "i" },
              ["<C-CR>"] = { "trouble_open", mode = "i" },
              ["<F10>"] = { "toggle_maximize", mode = "i" },
              ["<C-r><C-l>"] = { "insert_line", mode = "i" },
              ["<C-r><C-p>"] = { "insert_file_full", mode = "i" },
              ["<C-r><C-S-W>"] = { "insert_cWORD", mode = "i" },
              ["<C-r><C-w>"] = { "insert_cword", mode = "i" },
              ["<A-q>"] = { "close", mode = "i" },
              ["<ESC>"] = { "nop", mode = "i" },
              ["<C-s>"] = { "cycle_win", mode = "i" },
              ["<C-o>v"] = { "edit_vsplit", mode = "i" },
              ["<C-o>s"] = { "edit_split", mode = "i" },
              ["<C-o><C-v>"] = { "edit_vsplit", mode = "i" },
              ["<C-o><C-s>"] = { "edit_split", mode = "i" },
              ["<C-,>"] = { "history_back", mode = "i" },
              ["<C-.>"] = { "history_forward", mode = "i" },
              ["<CR>"] = { "confirm", mode = "i" },
              ["<F9>"] = { "toggle_live", mode = "i" },
              ["<C-d>"] = { "list_scroll_down", mode = "i" },
              ["<C-u>"] = { "list_scroll_up", mode = "i" },
              ["<C-n>"] = { "list_down", mode = "i" },
              ["<C-p>"] = { "list_up", mode = "i" },
              ["<C-g>"] = { "toggle_preview", mode = "i" },
              ["<C-e>"] = { "preview_scroll_down", mode = "i" },
              ["<C-y>"] = { "preview_scroll_up", mode = "i" },
              ["<S-BS>"] = { "<C-S-W>", mode = "i", expr = true },
              ["<S-Tab>"] = { "select_and_prev", mode = "i" },
              ["<Tab>"] = { "select_and_next", mode = "i" },
            },
            b = {
              -- completion = true -- uncommet if need completion
            }
          },
          list = {
            keys = {
              ["<C-a>"] = "select_all",
              ["<C-q>"] = "qflist",
              ["<F9>"] = "toggle_live",
              ["<F10>"] = "toggle_maximize",
              ["<CR>"] = "confirm",
              ["<C-CR>"] = "trouble_open",
              ["<S-Tab>"] = { "select_and_prev", mode = { "n", "x" } },
              ["<Tab>"] = { "select_and_next", mode = { "n", "x" } },
              ["<C-s>"] = "cycle_win",
              ["<C-g>"] = "toggle_preview",
              ["<C-e>"] = "preview_scroll_down",
              ["<C-y>"] = "preview_scroll_up",
              ["<C-n>"] = "list_down",
              ["<C-p>"] = "list_up",
              ["<C-d>"] = "list_scroll_down",
              ["<C-u>"] = "list_scroll_up",
              ["<C-o>v"] = "edit_vsplit",
              ["<C-o>s"] = "edit_split",
              ["<C-o><C-v>"] = "edit_vsplit",
              ["<C-o><C-s>"] = "edit_split",
              ["G"] = "list_bottom",
              ["gg"] = "list_top",
              ["a"] = "focus_input",
              ["i"] = "focus_input",
              ["j"] = "list_down",
              ["k"] = "list_up",
              ["q"] = "close",
              ["gb"] = "list_scroll_bottom",
              ["gt"] = "list_scroll_top",
              ["gc"] = "list_scroll_center",
            }
          },
          preview = {
            keys = {
              ["<F10>"] = "toggle_maximize",
              ["q"] = "close",
              ["i"] = "focus_input",
              ["a"] = "focus_input",
              ["<C-s>"] = "cycle_win",
              ["<C-g>"] = "toggle_preview",
            },
            wo = {
              relativenumber = false,
              statuscolumn = "  %=%{v:virtnum < 1 ? v:lnum : ''}%=%s",
              winhighlight = "SignColumn:SnacksPickerPreviewSignColumn",
              winbar = ""
            },
            w = {
              snacks_preview_user = true
            },
          }
        },
        layout = {
          preview = false,
          preset = "default",
          layout = {
            zindex = 200
          }
        },
        layouts = {
          default = {
            layout = {
              {
                box = "vertical",
                border = vim.__icons.border.no_but_title_slim,
                title = "{title} {live} {flags}",
                { win = "input", height = 1, border = "bottom" },
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", border = "rounded" },
              },
              box = "horizontal",
              backdrop = false,
              width = 0.85,
              min_width = 50,
              height = 0.8,
            }
          },
        },
        formatters = {
          file = {
            truncate = "center", -- left, right, center
            min_width = 40,
            filename_only = false,
          },
        },
        previewers = {
          file = {
            max_size = 1024 * 1024 * 5,
          },
        },
        sources = {
          diagnostics = {
            show_empty = true,
            title = "Diagnostics Workspace",
          },
          diagnostics_buffer = {
            show_empty = true,
            title = "Diagnostics Document",
          },
          lines = {
            layout = {
              preview = false,
            },
          },
          files = {
            hidden = true,
            args = {
              "--no-ignore-vcs",
              "--full-path"
            }
          },
          grep = {
            hidden = true,
            args = {
              "--no-ignore-vcs"
            }
          },
          bookmarks = {
            title = "Bookmarks",
            show_empty = true,
            finder = function(opts, ctx)
              local bm_states, bm_persists, get_extmark_lnum = vim.__bookmark:utils()

              local items = {}

              local function cvrt_state_2_items(bufnr, state)
                local bufname = vim.__buf.name(bufnr)

                for bmid, v in pairs(state._) do
                  local extmark_id = v.ex_ids[1]

                  local lnum = get_extmark_lnum(bufnr, extmark_id)
                  local line = vim.__buf.getline(bufnr, lnum)
                  if line then line = vim.trim(line) end

                  local texts = {
                    bmid,
                    bufname,
                    line
                  }

                  table.insert(items, {
                    line = line,
                    text = table.concat(texts, " "),
                    file = bufname,
                    pos = { lnum, 0 },

                    bmid = bmid,
                    alias = v.alias,
                    bufnr = bufnr
                  })
                end
              end

              local function cvrt_persist_2_items(path, persist)
                for bmid, v in pairs(persist._) do
                  local lnum = v.lnum
                  local line = vim.__fs.getline(path, lnum)
                  if line then line = vim.trim(line) end

                  local texts = {
                    bmid,
                    path,
                    line
                  }

                  table.insert(items, {
                    line = line,
                    text = table.concat(texts, " "),
                    file = path,
                    pos = { lnum, 0 },

                    bmid = bmid,
                    alias = v.alias,
                  })
                end
              end

              for bufnr, state in pairs(bm_states) do
                cvrt_state_2_items(bufnr, state)
              end
              for path, persist in pairs(bm_persists) do
                cvrt_persist_2_items(path, persist)
              end

              local current_bufnr = vim.__buf.current()
              table.sort(items, function(lhs, rhs)
                if
                  lhs.bufnr == current_bufnr and rhs.bufnr ~= current_bufnr
                then
                  return true
                elseif
                  lhs.bufnr ~= current_bufnr and rhs.bufnr == current_bufnr
                then
                  return false
                else
                  if lhs.file ~= rhs.file then
                    return lhs.file < rhs.file
                  end
                  return lhs.pos[1] < rhs.pos[1]
                end
              end)

              return ctx.filter:filter(items)
            end,
            format = function(item, picker)
              local picker_util    = require("snacks.picker.util")
              local picker_util_hl = require("snacks.picker.util.highlight")
              local picker_format  = require("snacks.picker.format")

              local form = picker_format.filename(item, picker)
              form[#form] = nil

              if item.alias then
                table.insert(form, { string.format(" %s: %s", item.bmid, item.alias), "SnacksPickerBookmark" })
              else
                table.insert(form, { string.format(" %s", tostring(item.bmid)), "SnacksPickerBookmark" })
              end
              table.insert(form, { " ", "SnacksPickerDelim" })

              if item.line then
                picker_util_hl.format(item, item.line, form)
                table.insert(form, { " " })
              end

              return form
            end
          },
          buffers = {
            finder = function(opts, ctx)
              local barbar_state = require("barbar.state")

              barbar_state.get_updated_buffers()

              local current_buf = vim.api.nvim_get_current_buf()
              local alternate_buf = vim.fn.bufnr("#")

              local items = {}
              local max_bufnr, max_flag_width = -1, -1
              for idx, bufnr in ipairs(barbar_state.buffers) do
                local bufname = vim.__buf.name(bufnr)
                if bufname == "" then
                  bufname = "[No Name]" .. (vim.bo[bufnr].filetype ~= "" and " " .. vim.bo[bufnr].filetype or "")
                end

                local bufinfo = vim.__buf.info(bufnr)[1]
                local bufmark = vim.__buf.mark(bufnr, "\"")

                local is_current     = current_buf == bufnr
                local is_alternate   = bufnr == alternate_buf
                local is_pinned      = barbar_state.is_pinned(bufnr)
                local is_readonly    = vim.bo[bufnr].readonly
                local is_hidden      = bufinfo.hidden == 1
                local is_changed     = bufinfo.changed == 1
                local is_attach_wins = #(bufinfo.windows or {}) > 0
                local is_loaded      = vim.__buf.is_loaded(bufnr)

                local pos, line
                if is_loaded then
                  pos = { bufinfo.lnum, 0 }
                  line = vim.__buf.getline(bufnr, pos[1])
                else
                  pos = { bufmark[1], 0 }
                  line = vim.__fs.getline(bufname, pos[1])
                end
                if line then
                  line = vim.trim(line)
                end

                local flags = {}
                if is_current then
                  table.insert(flags, "%")
                elseif is_alternate then
                  table.insert(flags, "#")
                end
                if is_hidden then
                  table.insert(flags, "h")
                elseif is_attach_wins then
                  table.insert(flags, "a")
                end
                if is_readonly then
                  table.insert(flags, "=")
                end
                if is_changed then
                  table.insert(flags, "+")
                end
                if is_pinned then
                  table.insert(flags, "P")
                end

                local texts = {
                  bufnr,
                  bufname,
                  line
                }

                max_bufnr = math.max(bufnr, max_bufnr)
                max_flag_width = math.max(#flags, max_flag_width)

                table.insert(items, {
                  idx = idx,
                  line = line,
                  text = table.concat(texts, " "),
                  file = bufname,
                  pos = pos,

                  flags = table.concat(flags),
                  bufnr = bufnr,
                  info = bufinfo,
                  is_pinned = is_pinned,
                })
              end

              local max_bufnr_width = #tostring(max_bufnr)
              for _, item in ipairs(items) do
                if max_flag_width > 0 then
                  item.max_flag_width = max_flag_width
                end
                if max_bufnr_width > 0 then
                  item.max_bufnr_width = max_bufnr_width
                end
              end

              return ctx.filter:filter(items)
            end,
            format = function(item, picker)
              local picker_util = require("snacks.picker.util")
              local picker_format = require("snacks.picker.format")

              local form = {}
              table.insert(form, { picker_util.align(tostring(item.bufnr), item.max_bufnr_width), "SnacksPickerBufNr" })
              table.insert(form, { " " })
              table.insert(form, { picker_util.align(item.flags, item.max_flag_width, { align = "left" }), "SnacksPickerBufFlags" })
              table.insert(form, { " " })

              for _, f in ipairs(picker_format.filename(item, picker)) do
                table.insert(form, f)
              end

              if item.is_pinned then
                for _, v in ipairs(form) do
                  if v[2] == "SnacksPickerDir" or v[2] == "SnacksPickerFile" then
                    v[2] = "SnacksPickerBufPin"
                  end
                end
              end

              if item.line then
                require("snacks.picker.util.highlight").format(item, item.line, form)
                table.insert(form, { " " })
              end

              return form
            end
          }
        },
        toggles = {
          follow = { enabled = false },
          hidden = { enabled = false },
          ignored = { enabled = false },
          modified = { enabled = false },
          regex = { enabled = false },
        },
      },
    },
    hackers = {
      before = {
        -- 设置 lsp-icon
        function(opts)
          local default = require("snacks.picker.config.defaults").defaults

          local icons = vim.__icons
          local lsp_kinds = icons.lsp_kinds

          local diagnostics = default.icons.diagnostics
          for k, _ in pairs(diagnostics) do
            diagnostics[k] = icons[string.format("diagnostic_%s", k:lower())]
          end

          local kinds = default.icons.kinds
          for k, _ in pairs(kinds) do
            local icon = lsp_kinds[k]
            if icon then
              kinds[k] = icon.val
            end
          end
        end,
        -- 取消默认的按键设置
        function(opts)
          local default = require("snacks.picker.config.defaults").defaults
          for _, v in pairs(default.win) do
            v.keys = {}
          end
        end,
        -- 取消 prompt 中的输入字符时候存在高亮的效果
        function(opts)
          if not opts.picker.win.input.highlight_indicator then
            require("snacks.picker.core.input").highlights = function(...) end
          end
        end,
        -- 为组件添加 winhl 配置
        function(opts)
          local picker_highlight = require("snacks.picker.util.highlight")
          for k, v in pairs(opts.picker.win) do
            local wo = v.wo
            if wo and wo.winhighlight then
              local winhl = picker_highlight.winhl
              local prefix = "SnacksPicker" .. k:sub(1,1):upper().. k:sub(2)
              picker_highlight.winhl = function(...)
                local ret = winhl(...)

                if select(1, ...) == prefix then
                  ret = ret .. "," .. v.wo.winhighlight
                end

                return ret
              end
            end
          end
        end,
        -- 性能更好的 get_icon
        function(opts)
          require("snacks.util").icon = function(name, cat, _)
            if cat == "directory" then
              return vim.__icons.directory, "Directory"
            end
            if cat == "filetype" then
              return vim.__icons.get_icon_color_by_ft(name)
            elseif cat == "file" then
              return vim.__icons.get_icon_color(vim.__path.basename(name))
            elseif cat == "extension" then
              return vim.__icons.get_icon_color(nil, name)
            end
          end
        end,
      }
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
    optional = true,
    opts = {
      override_by_filetype = {
        snacks_picker_input = {
          icon = "󰺮",
          color = vim.__color.bright_orange,
          name = "SnacksPickerInput"
        },
        snacks_picker_list = {
          icon = "󰺮",
          color = vim.__color.bright_orange,
          name = "SnacksPickerList"
        },
        snacks_picker_preview = {
          icon = "󰺮",
          color = vim.__color.bright_orange,
          name = "SnacksPickerPreview"
        },
      }
    }
  },
}

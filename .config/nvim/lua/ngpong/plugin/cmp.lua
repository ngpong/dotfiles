return {
  {
    "saghen/blink.cmp",
    lazy = true,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "echasnovski/mini.snippets",
    },
    build = "cargo build --release",
    highlights = {
      { "BlinkCmpGhostText", fg = vim.__color.dark3, italic = true },

      { "BlinkCmpMenu", bg = vim.__color.dark1 },
      { "BlinkCmpMenuBorder", bg = vim.__color.dark1 },
      { "BlinkCmpMenuSelection", bg = vim.__color.dark2 },

      { "BlinkCmpDoc", bg = vim.__color.dark1, fg = vim.__color.light1 },
      { "BlinkCmpDocBorder", bg = vim.__color.dark1 },
      { "BlinkCmpDocSeparator", bg = vim.__color.dark1, fg = vim.__color.dark2 },

      { "BlinkCmpSignatureHelp", bg = vim.__color.dark1, fg = vim.__color.light1 },
      { "BlinkCmpSignatureHelpBorder", bg = vim.__color.dark1 },
      -- { "BlinkCmpSignatureHelpActiveParameter", fg = vim.__color.bright_blue, bold = true },

      { "BlinkCmpLabelDetail", fg = vim.__color.gray, italic = true }, -- link = "NonText"
      { "BlinkCmpLabel", fg = vim.__color.light1 },
      { "BlinkCmpLabelMatch", fg = vim.__color.bright_aqua, bold = true },

      { "BlinkCmpScrollBarThumb", bg = vim.__color.dark3 },
      { "BlinkCmpScrollBarGutter", bg = vim.__color.dark0_soft },
    },
    opts_extend = { "sources.default" },
    opts = {
      snippets = {
        preset = "mini_snippets"
      },
      sources = {
        default = { "lsp", "snippets", "buffer", "path" },
        providers = {
          path = {
            opts = {
              show_hidden_files_by_default = true,
              get_cwd = vim.__path.cwd,
            }
          },
          cmdline = {
            min_keyword_length = function(ctx)
              if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                return 3
              end
              return 0
            end
          }
        },
      },
      keymap = {
        preset = "none",
        ["<C-g>"] = { "show_documentation", "hide_documentation" },
        ["<C-S-G>"] = { "show_signature", "hide_signature" },
        ["<C-PAGEDOWN>"] = { "scroll_documentation_down" },
        ["<C-PAGEUP>"] = { "scroll_documentation_up" },
        ["<C-f>"] = { "snippet_forward", "fallback" },
        ["<C-b>"] = { "snippet_backward", "fallback" },
        ["<TAB>"] = { "select_and_accept", "fallback" },
        ["<C-a>"] = { "show" },
        ["<C-c>"] = {
          "hide",
          function()
            if not MiniSnippets.session.get() then
              return false
            end

            vim.schedule(function()
              while MiniSnippets.session.get() do
                MiniSnippets.session.stop()
              end
            end)
            return true
          end,
          "fallback"
        },
        ["<C-p>"] = { "select_prev" },
        ["<C-n>"] = { "select_next" },
      },
      fuzzy = {
        implementation = "rust",
        -- label | sort_text | kind | score | exact
        sorts = {
          "score",
          "sort_text",
        },
      },
      completion = {
        trigger = {
          prefetch_on_insert = true,
          show_in_snippet = true, -- 当在snippet seesion内触发
          show_on_keyword = true, -- 当输入任何字符后触发
          show_on_trigger_character = true, -- 当输入 trigger character 后触发
          show_on_accept_on_trigger_character = true,
          show_on_insert_on_trigger_character = false, -- 当在 trigger character 处进入插入模式时检测
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = false
          }
        },
        accept = {
          dot_repeat = false,
          auto_brackets = {
            enabled = false
          }
        },
        menu = {
          min_width = 25,
          -- max_height = 10,
          border = "none",
          scrolloff = 0,
          -- direction_priority = { "s" },
          cmdline_position = function()
            local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
            return { vim.o.lines - height, 0 }
          end,
          winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          draw = {
            align_to = "label", -- none
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
            components = {
              label = {
                ellipsis = true,
                width = { fill = true, max = 50 },
              },
            }
          }
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          update_delay_ms = 50,
          treesitter_highlighting = true,
          window = {
            min_width = 10,
            max_width = 80,
            max_height = 20,
            border = vim.__icons.border.no,
            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
          }
        },
        ghost_text = {
          enabled = false
        },
      },
      signature = {
        enabled = true,
        trigger = {
          show_on_keyword = false, -- 当输入任何字符后检测
          show_on_insert = false, -- 进入插入模式时检测
          show_on_trigger_character = true, -- 当输入 trigger character 后检测
          show_on_insert_on_trigger_character = true, -- 当在 trigger character 处进入插入模式时检测
        },
        window = {
          min_width = 1,
          max_width = 200,
          max_height = 20,
          winblend = 20,
          border = vim.__icons.border.no,
          winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
          direction_priority = { "n" },
          treesitter_highlighting = true,
          show_documentation = false,
        },
      },
      cmdline = {
        enabled = true,
        keymap = {
          preset = "none",
          ["<TAB>"] = { "accept", "fallback" },
          ["<C-a>"] = { "show" },
          ["<C-c>"] = { "hide" },
          ["<C-p>"] = { "select_prev" },
          ["<C-n>"] = { "select_next" },
        },
        sources = function()
          local type = vim.fn.getcmdcompltype()
          if type == "command" then
            return  { "cmdline" }
          end
          if type == "file" or type == "dir" then
            return { "path" }
          end
          return {}
        end,
        completion = {
          list = {
            selection = {
              preselect = true,
              auto_insert = false,
            },
          },
          menu = { auto_show = true },
          ghost_text = { enabled = false }
        }
      },
    }
  },
  {
    "saghen/blink.cmp",
    opts = {
      appearance = {
        nerd_font_variant = "mono", -- "mono" for "Nerd Font Mono" or "normal" for "Nerd Font"
        kind_icons = {
          Text = vim.__icons.lsp_kinds.Text.val,
          Method = vim.__icons.lsp_kinds.Method.val,
          Function = vim.__icons.lsp_kinds.Function.val,
          Constructor = vim.__icons.lsp_kinds.Constructor.val,
          Field = vim.__icons.lsp_kinds.Field.val,
          Variable = vim.__icons.lsp_kinds.Variable.val,
          Property = vim.__icons.lsp_kinds.Property.val,
          Class = vim.__icons.lsp_kinds.Class.val,
          Interface = vim.__icons.lsp_kinds.Interface.val,
          Struct = vim.__icons.lsp_kinds.Struct.val,
          Module = vim.__icons.lsp_kinds.Module.val,
          Unit = vim.__icons.lsp_kinds.Unit.val,
          Value = vim.__icons.lsp_kinds.Value.val,
          Enum = vim.__icons.lsp_kinds.Enum.val,
          EnumMember = vim.__icons.lsp_kinds.EnumMember.val,
          Keyword = vim.__icons.lsp_kinds.Keyword.val,
          Constant = vim.__icons.lsp_kinds.Constant.val,
          Snippet = vim.__icons.lsp_kinds.Snippet.val,
          Color = vim.__icons.lsp_kinds.Color.val,
          File = vim.__icons.lsp_kinds.File.val,
          Reference = vim.__icons.lsp_kinds.Reference.val,
          Folder = vim.__icons.lsp_kinds.Folder.val,
          Event = vim.__icons.lsp_kinds.Event.val,
          Operator = vim.__icons.lsp_kinds.Operator.val,
          TypeParameter = vim.__icons.lsp_kinds.TypeParameter.val,
        },
      }
    },
  },
  {
    "echasnovski/mini.snippets",
    lazy = true,
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    highlights = {
      { "MiniSnippetsFinal", fg = vim.__color.bright_aqua },
      { "MiniSnippetsCurrent", bold = true, bg = vim.__color.dark3 },
      { "MiniSnippetsVisited", bg = vim.__color.dark1 },
      { "MiniSnippetsUnvisited", bg = vim.__color.dark1 },
      { "MiniSnippetsCurrentReplace", bold = true, bg = vim.__color.dark3 },
    },
    opts = {
      mappings = {
        expand = "",
        jump_next = "",
        jump_prev = "",
        stop = "",
      },
      variables = {},
      empty_tabstop_final = "•", -- ∎
      empty_tabstop = "", -- •
      wrap_jump = false,
    },
    config = function(_, opts)
      local gen_loader = require("mini.snippets").gen_loader
      require("mini.snippets").setup({
        snippets = {
          -- global-snippets
          gen_loader.from_file(vim.__path.join(vim.__path.standard("config"), "snippets/global.json")),
          -- friendly-snippets
          gen_loader.from_lang(),
          gen_loader.from_lang({
            lang_patterns = {
              c = { "extra_langs/c.json" },
              cpp = { "extra_langs/cpp.json" },
            }
          }),
        },
        mappings = opts.mappings,
        expand = {
          insert = function(snippet)
            return MiniSnippets.default_insert(snippet, {
              lookup = opts.variables,
              empty_tabstop = opts.empty_tabstop,
              empty_tabstop_final = opts.empty_tabstop_final,
            })
          end
        }
      })

      if MiniSnippets ~= nil then
        local group = vim.__autocmd.augroup("mini.snippets")
        -- stop session immediately after jumping to final tabstop
        group:on("User", function(state)
          if state.data.tabstop_to == "0" then MiniSnippets.session.stop() end
        end, { pattern = "MiniSnippetsSessionJump" })
        -- stop all sessions on Normal mode exit
        group:on("User", function(_)
          group:on("ModeChanged", function(_)
            while MiniSnippets.session.get() do
              MiniSnippets.session.stop()
            end
          end, { pattern = "*:n", once = true })
        end, { pattern = "MiniSnippetsSessionStart" })

        if not opts.wrap_jump then
          local jump = MiniSnippets.session.jump
          MiniSnippets.session.jump = function(direction)
            local session = MiniSnippets.session.get()

            local current = session.cur_tabstop
            local tabstops = vim.__util.copy(session.tabstops)

            if direction == "next" then
              if current ~= "0" then
                return jump("next")
              end
            elseif direction == "prev" then
              tabstops["0"] = nil

              local smallest_tabstop = next(tabstops)
              for key, _ in pairs(tabstops) do
                if tonumber(key) < tonumber(smallest_tabstop) then
                  smallest_tabstop = key
                end
              end

              if current ~= smallest_tabstop then
                return jump("prev")
              end
            else
              return jump(direction)
            end
          end
        end
      end
    end
  },
  {
    "ellisonleao/gruvbox.nvim",
    optional = true,
    opts = {
      overrides = {
        BlinkCmpKindText = { fg = vim.__color.bright_orange },
        BlinkCmpKindMethod = { fg = vim.__color.bright_blue },
        BlinkCmpKindFunction = { fg = vim.__color.bright_blue },
        BlinkCmpKindConstructor = { fg = vim.__color.bright_yellow },
        BlinkCmpKindField = { fg = vim.__color.bright_blue },
        BlinkCmpKindVariable = { fg = vim.__color.bright_orange },
        BlinkCmpKindClass = { fg = vim.__color.bright_yellow },
        BlinkCmpKindStruct = { fg = vim.__color.bright_yellow },
        BlinkCmpKindObject = { fg = vim.__color.bright_yellow },
        BlinkCmpKindInterface = { fg = vim.__color.bright_yellow },
        BlinkCmpKindModule = { fg = vim.__color.bright_blue },
        BlinkCmpKindNamespace = { fg = vim.__color.bright_blue },
        BlinkCmpKindProperty = { fg = vim.__color.bright_blue },
        BlinkCmpKindUnit = { fg = vim.__color.bright_blue },
        BlinkCmpKindValue = { fg = vim.__color.bright_orange },
        BlinkCmpKindNumber = { fg = vim.__color.bright_orange },
        BlinkCmpKindArray = { fg = vim.__color.bright_orange },
        BlinkCmpKindEnum = { fg = vim.__color.bright_yellow },
        BlinkCmpKindEnumMember = { fg = vim.__color.bright_aqua },
        BlinkCmpKindKeyword = { fg = vim.__color.bright_purple },
        BlinkCmpKindKey = { fg = vim.__color.bright_purple },
        BlinkCmpKindSnippet = { fg = vim.__color.bright_green },
        BlinkCmpKindColor = { fg = vim.__color.bright_purple },
        BlinkCmpKindFile = { fg = vim.__color.bright_blue },
        BlinkCmpKindReference = { fg = vim.__color.bright_purple },
        BlinkCmpKindFolder = { fg = vim.__color.bright_blue },
        BlinkCmpKindCopilot = { fg = vim.__color.bright_blue },
        BlinkCmpKindString = { fg = vim.__color.bright_green },
        BlinkCmpKindConstant = { fg = vim.__color.bright_orange },
        BlinkCmpKindEvent = { fg = vim.__color.bright_purple },
        BlinkCmpKindOperator = { fg = vim.__color.bright_yellow },
        BlinkCmpKindType = { fg = vim.__color.bright_yellow },
        BlinkCmpKindTypeParameter = { fg = vim.__color.bright_yellow },
        BlinkCmpKindPackage = { fg = vim.__color.bright_aqua },
        BlinkCmpKindStaticMethod = { fg = vim.__color.bright_yellow },
        BlinkCmpKindNull = { fg = vim.__color.gray },
        BlinkCmpKindBoolean = { fg = vim.__color.bright_purple },
      }
    },
  }
}
return {
  {
    "saghen/blink.cmp",
    enabled = true,
    lazy = true,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "echasnovski/mini.snippets",
    },
    build = "cargo build --release",
    events = {
      {
        vim.__event.types.FILE_TYPE,
        function(state)
          -- vim.__logger.info(state)
          if not vim.__filter.contain_fts(state.match) then
            vim.b[state.buf].completion = true
          end
        end
      }
    },
    highlights = {
      { "BlinkCmpGhostText", fg = vim.__color.dark3, italic = true },

      { "BlinkCmpDoc", bg = vim.__color.dark1, fg = vim.__color.light1 },
      { "BlinkCmpDocBorder", bg = vim.__color.dark0_soft, fg = vim.__color.dark1 },
      { "BlinkCmpDocSeparator", bg = vim.__color.dark1, fg = vim.__color.light4 },

      { "BlinkCmpSignatureHelp", bg = vim.__color.dark2, fg = vim.__color.light1 },
      { "BlinkCmpSignatureHelpBorder", bg = vim.__color.dark0_soft, fg = vim.__color.dark2 },

      { "BlinkCmpLabelDetail", fg = vim.__color.dark4, italic = true, bold = true }, -- link = "NonText"
      { "BlinkCmpLabelItemDetail", fg = vim.__color.bright_yellow }, -- link = "NonText"
      { "BlinkCmpSource", fg = vim.__color.light1 }, -- link = "NonText"

      -- { "BlinkCmpMenu", bg = vim.__color.dark2, fg = vim.__color.light1 },
      -- { "BlinkCmpMenuBorder", bg = vim.__color.dark0_soft, fg = vim.__color.dark2 },
    },
    opts_extend = { "sources.default" },
    opts = {
      -- disabled in comment context: https://cmp.saghen.dev/recipes.html#dynamically-picking-providers-by-treesitter-node-filetype
      enabled = function()
        return vim.b.completion
      end,
      snippets = {
        preset = "mini_snippets"
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          DressingInput = { "path" },
        },
        providers = {
          path = {
            opts = {
              trailing_slash = true,
              label_trailing_slash = true,
              show_hidden_files_by_default = true,
            }
          },
        },
        min_keyword_length = function(ctx)
          if ctx.mode == "cmdline" then return 2 end
          return 0
        end
      },
      keymap = {
        preset = "none",
        ["<C-y>"] = { "show_documentation", "hide_documentation" },
        ["<C-S-Y>"] = { "show_signature", "hide_signature" },
        ["<C-u>"] = { "scroll_documentation_up" },
        ["<C-d>"] = { "scroll_documentation_down" },
        ["<C-S-S>"] = { "snippet_backward" },
        ["<C-s>"] = { "snippet_forward" },
        ["<TAB>"] = { "select_and_accept", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
      },
      completion = {
        keyword = {
          range = "prefix", -- "foo_|_bar" will match "foo_" for "prefix" and "foo__bar" for "full"
        },
        trigger = {
          prefetch_on_insert = true,
          show_in_snippet = true, -- 当在snippet seesion内触发
          show_on_keyword = true, -- 当输入任何字符后触发
          show_on_trigger_character = true, -- 当输入 trigger character 后触发
          show_on_insert_on_trigger_character = true, -- 当在 trigger character 处进入插入模式时检测
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = false
          }
        },
        menu = {
          border = "padded",
          winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          -- direction_priority = { "s" },
          draw = {
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
            -- columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
            components = {
              label = {
                ellipsis = true,
                width = { fill = true, max = 60 },
              },
              -- label = {
              --   text = function(ctx)
              --       return require("colorful-menu").blink_components_text(ctx)
              --   end,
              --   highlight = function(ctx)
              --       return require("colorful-menu").blink_components_highlight(ctx)
              --   end,
              -- },
              label_item_detail = {
                text = function(ctx) if ctx.source_name == "Snippets" then return "" else return ctx.item.detail or "" end end,
                width = { fill = true, max = 60 },
                highlight = "BlinkCmpLabelItemDetail",
              }
            }
          }
        },
        ghost_text = { enabled = false },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          update_delay_ms = 50,
          treesitter_highlighting = true,
          window = {
            min_width = 10,
            max_width = 80,
            max_height = 20,
            -- border = vim.__icons.border.no,
            winblend = 0,
            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
            scrollbar = true,
            direction_priority = {
              menu_north = { "e", "w", "n", "s" },
              menu_south = { "e", "w", "s", "n" },
            },
          }
        },
        accept = {
          auto_brackets = {
            enabled = true,
            semantic_token_resolution = {
              enabled = true,
              blocked_filetypes = { "cpp", "java" },
            },
          }
        }
      },
      signature = {
        enabled = true,
        trigger = {
          blocked_trigger_characters = {},
          blocked_retrigger_characters = {},
          show_on_keyword = false, -- 当输入任何字符后检测
          show_on_insert = true, -- 进入插入模式时检测
          show_on_trigger_character = true, -- 当输入 trigger character 后检测
          show_on_insert_on_trigger_character = false, -- 当在 trigger character 处进入插入模式时检测
        },
        window = {
          min_width = 1,
          max_width = 100,
          max_height = 10,
          -- border = vim.__icons.border,
          winblend = 0,
          winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
          direction_priority = { "n" },
          treesitter_highlighting = false,
          show_documentation = false,
        },
      },
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
    }
  },
  {
    "echasnovski/mini.snippets",
    lazy = true,
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    highlights = {
      { "MiniSnippetsFinal", fg = vim.__color.dark4 },
      { "MiniSnippetsCurrent", bold = true, bg = vim.__color.dark3 },
      { "MiniSnippetsVisited", bg = vim.__color.dark2 },
      { "MiniSnippetsUnvisited", bg = vim.__color.dark2 },
      { "MiniSnippetsCurrentReplace", bold = true, bg = vim.__color.dark3 },
    },
    opts = {
      mappings = {
        expand = "",
        jump_next = "",
        jump_prev = "",
        stop = "<C-c>",
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
          gen_loader.from_file("~/.config/nvim/snippets/global.json"),
          gen_loader.from_lang(),
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
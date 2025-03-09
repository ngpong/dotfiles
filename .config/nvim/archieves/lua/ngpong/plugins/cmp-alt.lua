local kmodes = vim.__key.e_mode
local etypes = vim.__event.types

return {
  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-cmdline",
      "FelipeLema/cmp-async-path",
      "hrsh7th/cmp-buffer",
      "lukas-reineke/cmp-under-comparator",
      "L3MON4D3/LuaSnip"
    },
    highlights = function()
      local hls = {}
      for key, kind in pairs(vim.__icons.lsp_kinds) do
        table.insert(hls, { "CmpItemKind" .. key, link = kind.hl_link })
      end
      return hls
    end,
    opts = function ()
      local Luasnip        = require("luasnip")
      local LuasnipSession = require("luasnip.session")

      local Cmp        = require("cmp")
      local CmpTypes   = require("cmp.types")
      local CmpContext = require("cmp.config.context")
      local CmpCompare = require("cmp.config.compare")
      local CmpConfig  = require("cmp.config")
      local CmpSource  = setmetatable({}, {
        __index = function(_, k)
          if k == "buffer" then
            return {
              name = "buffer",
              option = {
                get_bufnrs = function()
                  local bufnr = vim.__buf.current()
                  local size  = vim.__buf.size(bufnr)

                  if size >= 0 then
                    if size > vim.__filter.max_size[1] then
                      return {}
                    else
                      return { bufnr }
                    end
                  else
                    return {}
                  end
                end,
                keyword_length = 3,
                indexing_batch_size = 512,
                indexing_interval = 100,
              },
            }
          elseif k == "path" then
            return {
              name = "async_path",
            }
          elseif k == "cmdline" then
            return {
              name = "cmdline",
              option = {
                ignore_cmds = { "wq", "w", "!" },
              },
            }
          elseif k == "lsp_signature_help" then
            return {
              name = "nvim_lsp_signature_help"
            }
          else
            return {
              name = k
            }
          end
        end,
      })

      -- 完成菜单相关的设置
      -- menu      Use a popup menu to show the possible completions. The menu is only shown when there is more than one match and sufficient colors are available.  ins-completion-menu
      -- menuone   Use the popup menu also when there is only one match. Useful when there is additional information about the match, e.g., what file it comes from.
      -- longest   Only insert the longest common text of the matches. If the menu is displayed you can use CTRL-L to add more characters. Whether case is ignored depends on the kind of completion.  For buffer text the "ignorecase" option is used.
      -- preview   Show extra information about the currently selected completion in the preview window.  Only works in combination with "menu" or "menuone".
      -- noinsert  Do not insert any text for a match until the user selects a match from the menu. Only works in combination with "menu" or "menuone". No effect if "longest" is present.
      -- noselect  Do not select a match in the menu, force the user to select one from the menu. Only works in combination with "menu" or "menuone".
      vim.opt.completeopt = "" -- 部分插件的集成与 nvim-cmp 并不好，比如 dressing.nvim。这些插件还是使用的 omifunc 来完成补全
      -- vim.opt.completeopt = vim.opt.completeopt + "menu"
      -- vim.opt.completeopt = vim.opt.completeopt + "menuone"
      -- vim.opt.completeopt = vim.opt.completeopt + "noinsert"
      -- vim.opt.completeopt = vim.opt.completeopt + "preview"
      -- vim.opt.completeopt = vim.opt.completeopt + "noselect"

      -- 代码补全体验增强
      -- REF: https://neovim.io/doc/user/options.html#"wildmenu"
      vim.go.wildmenu = false

      -- 设置补全窗口的最大高度为 10 项
      vim.go.pumheight = 10

      return {
        global = {
          enabled = function()
            local disabled = false
            disabled = disabled or (CmpContext.in_treesitter_capture("comment") and vim.__helper.get_mode() == "i")
            -- disabled = disabled or (Luasnip.in_snippet())
            disabled = disabled or (vim.fn.reg_recording() ~= "")
            disabled = disabled or (vim.fn.reg_executing() ~= "")
            return not disabled
          end,
          snippet = {
            expand = function(args)
              Luasnip.lsp_expand(args.body)
            end,
          },
          completion = {
            completeopt = "menu,menuone",
            autocomplete = {
              CmpTypes.cmp.TriggerEvent.TextChanged,
            },
            keyword_length = 1,
          },
          confirmation = {
            default_behavior = CmpTypes.cmp.ConfirmBehavior.Insert,
            get_commit_characters = function(commit_characters)
              return commit_characters
            end,
          },
          experimental = {
            ghost_text = false,
          },
          preselect = CmpTypes.cmp.PreselectMode.Item,
          performance = {
            -- debounce = 20,
            -- throttle = 10,
            debounce = 50, -- 控制弹出窗口的时间
            throttle = 30, -- 控制关闭窗口的时间
            fetching_timeout = 500,
            confirm_resolve_timeout = 80,
            async_budget = 1,
            max_view_entries = 30, -- respect clangd config
          },
          sorting = {
            priority_weight = 2,
            comparators = {
              -- https://www.reddit.com/r/neovim/comments/14k7pbc/what_is_the_nvimcmp_comparatorsorting_you_are/

              CmpCompare.offset, -- 似乎是 lsp 标准的排序行为，默认带上吧
              CmpCompare.exact,  -- 似乎是 lsp 标准的排序行为，默认带上吧
              CmpCompare.score,  -- 似乎是 lsp 标准的排序行为，默认带上吧
              require("clangd_extensions.cmp_scores"), -- clangd 的额外排序功能；我习惯性会将长度较小的排在前面，而该排序源会打乱这个功能

              CmpCompare.locality,         -- 距离光标更近的词会被排在前面
              -- CmpCompare.recently_used, -- 最近使用的词会被排在前面

              CmpCompare.kind,     -- 根据 lsp 的 kind 分组，枚举值越小则被排在前面，参见：lsp.CompletionItemKind 枚举
              CmpCompare.length,   -- 长度更小的词会被排在前面
              CmpCompare.order, -- id更小的词会被排在前面

              require("cmp-under-comparator").under, -- 将下划线相关的词都排在一块，参见：https://github.com/lukas-reineke/cmp-under-comparator
            },
          },
          sources = Cmp.config.sources({
            CmpSource.nvim_lsp,
            CmpSource.path,
            CmpSource.luasnip,
            CmpSource.buffer,
          }, {
            CmpSource.buffer,
            CmpSource.lsp_signature_help,
          }),
          window = {
            completion = Cmp.config.window.bordered({ winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None" }),
            documentation = Cmp.config.window.bordered({ winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None" }),
          },
          view = {
            entries = {
              name = "custom",
              selection_order = "top_down",
            },
            docs = {
              auto_open = false,
            },
          },
          formatting = {
            expandable_indicator = true,
            fields = { "abbr", "kind", "menu" },
            format = function(entry, item)
              -- setup menu
              item.menu = vim.__icons.lsp_menus[entry.source.name]

              -- setup kind
              item.kind = vim.__icons.lsp_kinds[item.kind].val

              -- setup content(fixed width)
              -- https://github.com/hrsh7th/nvim-cmp/discussions/609
              local content = item.abbr
              local length = #content
              if length > 35 then
                item.abbr = vim.fn.strcharpart(content, 0, 35) .. vim.__icons.ellipsis
              else
                item.abbr = content .. (" "):rep(35 - length)
              end

              return item
            end,
          },
          mapping = {
            ["<TAB>"] = Cmp.mapping(function(fallback)
              if Cmp.visible() then
                if Luasnip.expandable() then
                  local node = LuasnipSession.current_nodes[vim.__buf.current()]
                  if node then Luasnip.unlink_current() end
                end

                Cmp.confirm({ select = false, behavior = Cmp.ConfirmBehavior.insert })
              else
                fallback()
              end
            end, { kmodes.I, kmodes.S }),
            ["<C-g>"] = Cmp.mapping(function(fallback)
              if Cmp.visible() then
                if Cmp.visible_docs() then
                  CmpConfig.get().view.docs.auto_open = false
                  Cmp.close_docs()
                else
                  CmpConfig.get().view.docs.auto_open = true
                  Cmp.open_docs()
                end
              else
                fallback()
              end
            end, { kmodes.I }),
            ["<C-e>"] = Cmp.mapping(function(fallback)
              if Luasnip.locally_jumpable(-1) then
                Luasnip.jump(-1)
              else
                fallback()
              end
            end, { kmodes.I, kmodes.S }),
            ["<C-y>"] = Cmp.mapping(function(fallback)
              if Luasnip.locally_jumpable(1) then
                Luasnip.jump(1)
              else
                fallback()
              end
            end, { kmodes.I, kmodes.S }),
            ["<C-n>"] = Cmp.mapping(function(fallback)
              if Cmp.visible() then
                if #Cmp.get_entries() > 1 then
                  Cmp.select_next_item({ behavior = Cmp.SelectBehavior.Select })
                else
                  Cmp.close()
                end
              else
                fallback()
              end
            end, { kmodes.I }),
            ["<C-p>"] = Cmp.mapping(function(fallback)
              if Cmp.visible() then
                if #Cmp.get_entries() > 1 then
                  Cmp.select_prev_item({ behavior = Cmp.SelectBehavior.Select })
                else
                  Cmp.close()
                end
              else
                fallback()
              end
            end, { kmodes.I }),
            ["<C-x>"] = Cmp.mapping(function()
              if Cmp.visible() then
                Cmp.close()
              end
            end, { kmodes.I }),
          }
        },
        filetype = {
          {
            vim.__filter.filetypes[1],
            {
              enabled = false
            }
          },
          {
            { "markdown", "help" },
            {
              sources = Cmp.config.sources({
                CmpSource.path,
                CmpSource.buffer,
              }),
            }
          }
        },
        buffer = {
          sources = Cmp.config.sources({
            CmpSource.path,
          }),
        },
        cmdline = {
          completion = {
            keyword_length = 2,
          },
          sources = Cmp.config.sources({
            CmpSource.path,
            CmpSource.cmdline,
          }),
          mapping = {
            ["<TAB>"] = Cmp.mapping(function(fallback)
              if Cmp.visible() then
                Cmp.confirm({ select = false, behavior = Cmp.ConfirmBehavior.insert })
              else
                fallback()
              end
            end, { kmodes.S }),
            ["<C-p>"] = Cmp.mapping(function(_)
              if Cmp.visible() then
                if #Cmp.get_entries() > 1 then
                  Cmp.select_prev_item({ behavior = Cmp.SelectBehavior.Select })
                else
                  Cmp.close()
                end
              end
            end, { kmodes.S }),
            ["<C-n>"] = Cmp.mapping(function(_)
              if Cmp.visible() then
                if #Cmp.get_entries() > 1 then
                  Cmp.select_next_item({ behavior = Cmp.SelectBehavior.Select })
                else
                  Cmp.close()
                end
              end
            end, { kmodes.S }),
            ["<C-x>"] = Cmp.mapping(function()
              if Cmp.visible() then
                Cmp.close()
              end
            end, { kmodes.S }),
          }
        }
      }
    end,
    config = function(_, opts)
      local Cmp = require("cmp")

      Cmp.setup(opts.global)

      Cmp.setup.filetype(table.unpack(opts.filetype[1]))
      Cmp.setup.filetype(table.unpack(opts.filetype[2]))

      Cmp.setup.cmdline(":", opts.cmdline)

      vim.__event.rg(etypes.OPEN_DRESSING_INPUT, function(state)
        if state.completion then return Cmp.setup.buffer(opts.buffer) end
      end)
    end
  },
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      history = false, -- (deprecated)
      keep_roots = false,
      link_roots = false,
      link_children = false,
      enable_autosnippets = false,
      -- region_check_events = { "CursorMoved", "CursorHold", "InsertEnter" }
    },
    config = function(_, opts)
      local Luasnip              = require("luasnip")
      local LuasnipExtrasPartial = require("luasnip.extras").partial
      local LuasnipExtrasPostfix = require("luasnip.extras.postfix").postfix

      Luasnip.config.set_config(opts)

      vim.__autocmd.augroup("luasnip"):on("ModeChanged", function(_)
        if ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
            and Luasnip.session.current_nodes[vim.__buf.current()]
            and not Luasnip.session.jump_active
        then
          Luasnip.unlink_current()
        end
      end)

      -- custom snippets
      require("luasnip.loaders.from_vscode").lazy_load {
        exclude = { "lua" }, -- luals 不支持禁用内置 snippets，为了使完成更加存粹，禁用掉这里的
      }

      -- snippets write by lua
      Luasnip.add_snippets("all", {
        Luasnip.snippet("$YEAR", {
          LuasnipExtrasPartial(os.date, "%Y")
        }),

        Luasnip.snippet({ trig = "trigger_test_test", name = "hello,world" }, {
          Luasnip.text_node({"After expanding, the cursor is here ->"}), Luasnip.insert_node(1),
          Luasnip.text_node({"", "After jumping forward once, cursor is here ->"}), Luasnip.insert_node(2),
          Luasnip.text_node({"", "After jumping once more, the snippet is exited there ->"}), Luasnip.insert_node(0),
        }),

        LuasnipExtrasPostfix(".br", {
          Luasnip.function_node(function(_, parent)
            return "[" .. (parent.snippet.env.POSTFIX_MATCH or "") .. "]"
          end, {}),
        }),

        LuasnipExtrasPostfix(".log", {
          Luasnip.function_node(function(_, parent)
            return "log << " .. (parent.snippet.env.POSTFIX_MATCH or "")
          end, {}),
        }),
      })
      Luasnip.add_snippets("cpp", {
        Luasnip.parser.parse_snippet(
          { trig = "bmk", name = "Benchmark Template.", desc = "Google benchmark template for a tiny cpp program" },
          "#include <benchmark/benchmark.h>\n\nvoid foo(benchmark::State& state) {\n\tfor (auto _: state) {}\n}\nBENCHMARK(foo);\n\nBENCHMARK_MAIN();"
        )
      })
    end
  },
}
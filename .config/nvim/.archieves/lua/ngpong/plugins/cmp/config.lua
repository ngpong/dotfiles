local M = {}

local Cmp        = vim.__lazy.require("cmp")
local CmpTypes   = vim.__lazy.require("cmp.types")
local CmpContext = vim.__lazy.require("cmp.config.context")

local etypes = vim.__event.types

local cmp_compare = setmetatable({}, {
  __index = function(_, k)
    local compare = require("cmp.config.compare")

    if k == "under" then
      local under_cmp = require("cmp-under-comparator")
      return under_cmp.under
    end

    if k == "clangd_extensions" then
      local _, module = pcall(require, "clangd_extensions.cmp_scores")
      return module
    end

    if compare[k] ~= nil then
      return compare[k]
    else
      return nil
    end
  end,
})

local cmp_source = setmetatable({}, {
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
    end

    if k == "path" then
      return {
        name = "async_path",
      }
    end

    if k == "luasnip" then
      return {
        name = "luasnip",
      }
    end

    if k == "cmdline" then
      return {
        name = "cmdline",
        option = {
          ignore_cmds = { "wq", "w", "!" },
        },
      }
    end

    if k == "nvim_lsp" then
      return {
        name = "nvim_lsp",
      }
    end

    if k == "lsp_signature_help" then
      return {
        name = "nvim_lsp_signature_help"
      }
    end
  end,
})

local setup_global = function()
  local cfg = {
    enabled = function()
      local disabled = false
      disabled = disabled or (require("cmp.config.context").in_treesitter_capture("comment") and vim.__helper.get_mode() == "i")
      -- disabled = disabled or (vim.__snip.is_in_snippet())
      disabled = disabled or (vim.fn.reg_recording() ~= "")
      disabled = disabled or (vim.fn.reg_executing() ~= "")
      return not disabled
    end,
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
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
  }

  local performance_cfg = {
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
  }

  local sort_cfg = {
    sorting = {
      priority_weight = 2,
      comparators = {
        -- https://www.reddit.com/r/neovim/comments/14k7pbc/what_is_the_nvimcmp_comparatorsorting_you_are/

        cmp_compare.offset, -- 似乎是 lsp 标准的排序行为，默认带上吧
        cmp_compare.exact,  -- 似乎是 lsp 标准的排序行为，默认带上吧
        cmp_compare.score,  -- 似乎是 lsp 标准的排序行为，默认带上吧
        cmp_compare.clangd_extensions, -- clangd 的额外排序功能；我习惯性会将长度较小的排在前面，而该排序源会打乱这个功能

        cmp_compare.locality,         -- 距离光标更近的词会被排在前面
        -- cmp_compare.recently_used, -- 最近使用的词会被排在前面

        cmp_compare.kind,     -- 根据 lsp 的 kind 分组，枚举值越小则被排在前面，参见：lsp.CompletionItemKind 枚举
        cmp_compare.length,   -- 长度更小的词会被排在前面
        cmp_compare.order, -- id更小的词会被排在前面

        cmp_compare.under, -- 将下划线相关的词都排在一块，参见：https://github.com/lukas-reineke/cmp-under-comparator
      },
    },
  }

  local source_cfg = {
    sources = Cmp.config.sources({
      cmp_source.nvim_lsp,
      cmp_source.path,
      cmp_source.luasnip,
      cmp_source.buffer,
    }, {
      -- cmp_source.buffer,
      -- cmp_source.lsp_signature_help',
    }),
  }

  local appearance_cfg = {
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
  }

  vim.__tbl.r_extend(cfg, performance_cfg,
                         sort_cfg,
                         source_cfg,
                         appearance_cfg)

  vim.__event.emit(etypes.SETUP_CMP, { cfg = cfg, source = "global" })

  Cmp.setup(cfg)
end

local setup_ft = function()
  Cmp.setup.filetype(vim.__filter.filetypes[1], {
    enabled = false,
  })

  Cmp.setup.filetype({ "markdown", "help" }, {
    sources = Cmp.config.sources({
      cmp_source.path,
      cmp_source.buffer,
    }),
  })

  vim.__event.rg(etypes.OPEN_DRESSING_INPUT, function(state)
    if not state.completion then
      return
    end

    -- https://github.com/stevearc/dressing.nvim/issues/55
    Cmp.setup.buffer({
      sources = Cmp.config.sources({
        cmp_source.path,
      }),
    })
  end)
end

local setup_cmdline = function()
  -- NOTE: 在命令行完成时输入 "/" 会有问题，产生的原因是因为每次进入 NVIM 的时
  -- 候都会清理之前搜索的记录，所以当解析命令的时候就会出现报错(即便使用pcall调
  -- 用也会报错)，这是上游一个待修复的错误(https://github.com/neovim/neovim/issues/24220)
  local cfg = {
    completion = {
      keyword_length = 2,
    },
    sources = Cmp.config.sources({
      cmp_source.path,
      cmp_source.cmdline,
    }),
  }

  vim.__event.emit(etypes.SETUP_CMP, { cfg = cfg, source = "cmdline" })

  Cmp.setup.cmdline(":", cfg)
end

M.setup = function()
  -- setup global cfg
  setup_global()

  -- setup cfg with specify filetype
  setup_ft()

  -- setup cmdline cfg
  setup_cmdline()
end

return M

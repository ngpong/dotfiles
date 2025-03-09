local Lualine = vim.__lazy.require("lualine")
local WBIcons = vim.__lazy.require("nvim-web-devicons")

vim.__stl = vim.__class.def()

local function module() return {
  space = {
    function()
      return vim.__icons.space
    end,
    padding = {
      left = 0,
      right = 0,
    },
  },
  git_branch = {
    "branch",
    component_name = "git_branch",
    icon = { vim.__icons.git_1, color = { fg = vim.__color.bright_orange } },
    padding = {
      left = 1,
      right = 0,
    },
    color = { bg = vim.__color.dark3, fg = vim.__color.light1 },
    separator = { left = vim.__icons.left_half_1, right = vim.__icons.right_half_1 },
  },
  git_diff = {
    "diff",
    component_name = "git_diff",
    symbols = {
      added = vim.__icons.git_add .. vim.__icons.space,
      modified = vim.__icons.git_change .. vim.__icons.space,
      removed = vim.__icons.git_delete .. vim.__icons.space,
    },
    colored = true,
    padding = {
      left = 0,
      right = 1,
    },
    source = function()
      local gitsigns = vim.b.gitsigns_status_dict
      if gitsigns then
        return {
          added = gitsigns.added,
          modified = gitsigns.changed,
          removed = gitsigns.removed,
        }
      end
    end,
  },
  lsp_client = {
    "my_lspclient",
    component_name = "lspclient",
    padding = {
      left = 1,
      right = 0,
    },
    separator = { left = vim.__icons.left_half_1, right = vim.__icons.right_half_1 },
    color = { bg = vim.__color.dark2, fg = vim.__color.light1 },
    cond = function()
      return vim.lsp.buf_is_attached(vim.__buf.current())
    end
  },
  lsp_diagnostics = {
    "diagnostics",
    component_name = "lsp_diagnostics",
    padding = {
      left = 0,
      right = 1,
    },
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn", "info", "hint" },
    symbols = {
      error = vim.__icons.diagnostic_err .. vim.__icons.space,
      warn = vim.__icons.diagnostic_warn .. vim.__icons.space,
      info = vim.__icons.diagnostic_info .. vim.__icons.space,
      hint = vim.__icons.diagnostic_hint .. vim.__icons.space,
    },
    color = { bg = vim.__color.dark1 },
    colored = true,
    update_in_insert = false,
    always_visible = false,
  },
  filetype = {
    "filetype",
    component_name = "filetype",
    padding = {
      left = 0,
      right = 1,
    },
    colored = true,
    color = { fg = vim.__color.light4, gui = "italic" },
  },
  os = {
    function()
      return vim.__util.get_os()
    end,
    component_name = "os",
    padding = {
      left = 0,
      right = 1,
    },
    color = { fg = vim.__color.light4, gui = "italic" },
    icon = setmetatable({}, {
      __index = function(_, k)
        local os = vim.__util.get_os()

        if k == 1 then
          return WBIcons.get_icons_by_operating_system()[os].icon
        elseif k == "color" then
          return { fg = WBIcons.get_icons_by_operating_system()[os].color }
        end
      end
    }),
  },
  encoding = {
    function()
      return vim.__icons.files_2 .. vim.__icons.space .. vim.opt.fileencoding:get()
    end,
    component_name = "encoding",
    padding = {
      left = 0,
      right = 1,
    },
    color = { fg = vim.__color.light4, gui = "italic" },
  },
  multicursors = {
    first = {
      "my_multicursors",
      component_name = "multicursors",
      padding = {
        left = 0,
        right = 0,
      },
      separator = { left = vim.__icons.left_half_1, right = vim.__icons.right_half_1 },
      color = { bg = vim.__color.dark2 },
    },
    second = {
      function()
        return vim.__icons.space
      end,
      padding = {
        left = 0,
        right = 0,
      },
      cond = function()
        return vim.fn.getreg("/") ~= ""
      end
    },
  },
  searchcount = {
    "my_searchcount",
    component_name = "searchcount",
    padding = {
      left = 0,
      right = 0,
    },
    separator = { left = vim.__icons.left_half_1, right = vim.__icons.right_half_1 },
    color = { bg = vim.__color.dark2 },
  },
  datetime = {
    function()
      return os.date("%A %H:%M")
    end,
    icon = { vim.__icons.alarm, color = { fg = vim.__color.bright_aqua } },
    component_name = "datetime",
    padding = {
      left = 0,
      right = 0,
    },
    separator = { left = vim.__icons.left_half_1, right = vim.__icons.right_half_1 },
    color = { fg = vim.__color.light1, bg = vim.__color.dark2, gui = "italic" },
  },
  progress = {
    "my_progress",
    component_name = "progress",
    padding = {
      left = 0,
      right = 0,
    },
    separator = { left = vim.__icons.left_half_1 },
  },
  location = {
    "my_location",
    component_name = "location",
    padding = {
      left = 0,
      right = 1,
    },
    separator = { left = vim.__icons.left_half_1 },
  },
  mode = {
    "my_mode",
    component_name = "mode",
    padding = {
      left = 1,
      right = 1,
    },
    separator = { left = vim.__icons.left_half_1, right = vim.__icons.right_half_1 },
  },
  text = {
    "my_text",
    component_name = "text",
    padding = {
      left = 1,
      right = 0,
    },
    separator = { left = vim.__icons.left_half_1, right = vim.__icons.right_half_1 },
  },
} end

return {
  "nvim-lualine/lualine.nvim",
  enabled = false,
  lazy = true,
  event = "VeryLazy",
  init = function ()
    -- 提示信息相关的设置
    vim.opt.shortmess = nil
    vim.opt.shortmess = vim.opt.shortmess + "S" -- S	do not show search count message when searching, e.g.	"[1/5]"
    vim.opt.shortmess = vim.opt.shortmess + "o" -- o	overwrite message for writing a file with subsequent message for reading a file (useful for ":wn" or when 'autowrite' on)
    vim.opt.shortmess = vim.opt.shortmess + "O" -- O	message for reading a file overwrites any previous message; also for quickfix message (e.g., ":cn")
    vim.opt.shortmess = vim.opt.shortmess + "s" -- s	don't give "search hit BOTTOM, continuing at TOP" or "search hit TOP, continuing at BOTTOM" messages; when using the search count do not show "W" after the count message (see S below)
    vim.opt.shortmess = vim.opt.shortmess + "c" -- c	don't give ins-completion-menu messages; for example, "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found", "Back at original", etc.
    vim.opt.shortmess = vim.opt.shortmess + "F" -- F	don't give the file info when editing a file, like :silent was used for the command

    -- 不显示当前的输入模式(左下角)
    vim.go.showmode = false

    -- 不显示当前光标所在行号还有列号(右下角)
    vim.go.ruler = false

    -- 关闭状态行(最后一行)
    vim.go.laststatus = 0
    -- 不显示当前输入的命令(右下角)
    -- 暂时禁用它，不然在移动(从下往上一直按p移动)的时候会有一些鼠标乱飘的bug
    vim.go.showcmd = true

    -- 控制命令行的高度(最后一行)
    vim.go.cmdheight = 1
  end,
  opts = function()
    vim.api.nvim_set_hl(0, "StatusLine", { bg = vim.__color.dark1 })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = vim.__color.dark1 })
    vim.api.nvim_set_hl(0, "StatusLineTermNC", { bg = vim.__color.dark1 })
    vim.api.nvim_set_hl(0, "LuaLineDiffChange", { fg = vim.__color.bright_yellow })

    local m = module()

    return {
      options = {
        theme = "gruvbox",
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {}, -- only ignores the ft for statusline.
          winbar = {}, -- only ignores the ft for winbar.
        },
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 5000,
          tabline = 5000,
          winbar = 5000,
        },
      },
      sections = {
        lualine_a = {
          m.mode,
          m.git_branch,
          m.lsp_client,
        },
        lualine_b = {
          m.space,
        },
        lualine_c = {
          m.git_diff,
          m.lsp_diagnostics,
        },
        lualine_x = {
          m.multicursors.first,
          m.multicursors.second,
          m.searchcount,
          m.space,
          m.filetype,
          m.os,
          m.encoding,
          -- m.datetime,
        },
        lualine_y = {
        },
        lualine_z = {
          m.location,
          m.progress,
        },
      },
      extensions = {
        ref_plugins = {
          sections = {
            lualine_a = {
              m.mode,
              m.text,
            },
            lualine_x = {
              m.searchcount,
              m.space,
              -- m.datetime,
            },
            lualine_y = {
            },
            lualine_z = {
              m.location,
              m.progress,
            },
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
          },
          filetypes = { "neo-tree", "trouble", "ClangdTypeHierarchy", "lazy", "mason" },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    }
  end,
  config = function(_, opts)
    Lualine.setup(opts)

    -- HACK: 调整原插件的刷新事件；添加一些bounce的逻辑

    -- 0x1: 一般情况下，每次 refresh 整体消耗会在 400 ~ 500 ns 左右，但是刷新次数非常频繁
    local org_refresh = Lualine.refresh
    local normal_refresh_f = function(...)
      org_refresh(...)
    end
    local bounce_refresh_f = vim.__bouncer.throttle_leading(20, vim.__async.schedule_wrap(function(...)
      org_refresh(...)
    end))

    local function fix_refresh(args, bouncer)
      local default = {
        kind = "window",
        scope = "window",
        place = { "statusline" },
      }

      args = vim.tbl_deep_extend("force", default, args or {})

      if not bouncer then
        normal_refresh_f(args)
      else
        bounce_refresh_f(args)
      end
    end
    Lualine.refresh = fix_refresh
    function vim.__stl:refresh(...) Lualine.refresh(...) end

    -- 0x2: 删除插件原生的刷新事件
    vim.__autocmd.del_augroup("lualine_stl_refresh", "name")
    vim.__autocmd.del_augroup("lualine_tal_refresh", "name")
    vim.__autocmd.del_augroup("lualine_wb_refresh", "name")

    -- 0x3: 重新设置 autocmd
    local group = vim.__autocmd.augroup("lualine")

    -- 0x4: 使用节流的refresh
    local __buf_entering = false
    group:on({ "BufWritePost", "SessionLoadPost", "FileChangedShellPost", "VimResized", "CmdlineLeave", "CursorMoved" }, function(state)
      vim.__stl:refresh({ trigger = "autocmd" }, true)
    end)
    group:on("LspAttach", function(state)
      vim.__stl:refresh({ trigger = "autocmd" }, true)
    end, { once = true })
    group:on("WinEnter", function(state)
      if __buf_entering then __buf_entering = false return end
      vim.__stl:refresh({ trigger = "autocmd" }, true)
    end)

    -- 0x5: 使用默认的refresh
    group:on("BufEnter", function(state) -- 某些事件在满足bounce与trigger="autocmd"任意一项配置的情况下都会出现statusline刷新闪烁的问题
      __buf_entering = true
      vim.__stl:refresh()
    end)
    group:on("ModeChanged", function(state)
      vim.__stl:refresh()
    end)
  end
}
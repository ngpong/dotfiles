local M = {}

local Lualine = vim.__lazy.require("lualine")
local WBIcons = vim.__lazy.require("nvim-web-devicons")

local etypes = vim.__event.types

local module = {
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
}

local extension = {
  ref_plugins = {
    sections = {
      lualine_a = {
        module.mode,
        module.text,
      },
      lualine_x = {
        module.searchcount,
        module.space,
        -- module.datetime,
      },
      lualine_y = {
      },
      lualine_z = {
        module.location,
        module.progress,
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
}

M.setup = function()
  local cfg = {
    options = {
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
  }

  local theme_cfg = {
    options = {
      theme = "gruvbox",
    },
  }

  local extensions_cfg = {
    extensions = {
      extension.ref_plugins,
    },
  }

  local inactive_section_cfg = {
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  }

  local active_section_cfg = {
    sections = {
      lualine_a = {
        module.mode,
        module.git_branch,
        module.lsp_client,
      },
      lualine_b = {
        module.space,
      },
      lualine_c = {
        module.git_diff,
        module.lsp_diagnostics,
      },
      lualine_x = {
        module.multicursors.first,
        module.multicursors.second,
        module.searchcount,
        module.space,
        module.filetype,
        module.os,
        module.encoding,
        -- module.datetime,
      },
      lualine_y = {
      },
      lualine_z = {
        module.location,
        module.progress,
      },
    },
  }

  -- stylua: ignore
  vim.__tbl.r_extend(cfg, theme_cfg,
                         active_section_cfg,
                         inactive_section_cfg,
                         extensions_cfg)

  vim.__event.emit(etypes.SETUP_LUALINE, cfg)

  Lualine.setup(cfg)
end

return M

local M = {}

-- stylua: ignore start
local Events  = require('ngpong.common.events')
local Icons   = require('ngpong.utils.icon')
local Lazy    = require('ngpong.utils.lazy')
local Lualine = Lazy.require('lualine')

local this      = Plgs.lualine
local mc        = Plgs.multicursors
local neotree   = Plgs.neotree
local telescope = Plgs.telescope
local trouble   = Plgs.trouble
local colors    = Plgs.colorscheme.colors

local e_name = Events.e_name
-- stylua: ignore end

local module = {
  space = {
    function()
      return Icons.space
    end,
    padding = {
      left = 0,
      right = 0,
    },
  },
  git_branch = {
    'branch',
    component_name = 'git_branch',
    icon = { Icons.git, color = { fg = colors.bright_orange } },
    padding = {
      left = 1,
      right = 0,
    },
    color = { bg = colors.dark3, fg = colors.light1 },
    separator = { left = Icons.left_half_1, right = Icons.right_half_1 },
  },
  git_diff = {
    'diff',
    component_name = 'git_diff',
    symbols = {
      added = Icons.git_add .. Icons.space,
      modified = Icons.git_change .. Icons.space,
      removed = Icons.git_delete .. Icons.space,
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
    function()
      local clis = vim.lsp.get_clients({ bufnr = Helper.get_cur_bufnr() })
      if next(clis) then
        return clis[1].name
      else
        return ''
      end
    end,
    component_name = 'lsp_client',
    icon = { Icons.activets, color = { fg = colors.bright_green } },
    padding = {
      left = 1,
      right = 0,
    },
    color = { bg = colors.dark2, fg = colors.light1 },
    separator = { left = Icons.left_half_1, right = Icons.right_half_1 },
  },
  lsp_diagnostics = {
    'diagnostics',
    component_name = 'lsp_diagnostics',
    padding = {
      left = 0,
      right = 1,
    },
    sources = { 'nvim_diagnostic' },
    sections = { 'error', 'warn', 'info', 'hint' },
    symbols = {
      error = Icons.diagnostic_err .. Icons.space,
      warn = Icons.diagnostic_warn .. Icons.space,
      info = Icons.diagnostic_info .. Icons.space,
      hint = Icons.diagnostic_hint .. Icons.space,
    },
    color = { bg = colors.dark1 },
    colored = true,
    update_in_insert = false,
    always_visible = false,
  },
  filetype = {
    'filetype',
    component_name = 'filetype',
    padding = {
      left = 0,
      right = 1,
    },
    colored = false,
    color = { fg = colors.dark4, gui = 'italic' },
  },
  fileformat = {
    function()
      local format = vim.bo.fileformat

      if format == 'unix' then
        return Icons.unix .. Icons.space .. format
      elseif format == 'dos' then
        return Icons.windows .. Icons.space .. format
      elseif format == 'mac' then
        return Icons.mac .. Icons.space .. format
      else
        return ''
      end
    end,
    component_name = 'fileformat',
    padding = {
      left = 0,
      right = 1,
    },
    color = { fg = colors.dark4, gui = 'italic' },
  },
  encoding = {
    function()
      return Icons.files_2 .. Icons.space .. vim.opt.fileencoding:get()
    end,
    component_name = 'encoding',
    padding = {
      left = 0,
      right = 1,
    },
    color = { fg = colors.dark4, gui = 'italic' },
  },
  mc_searchcount = {
    'my_multicursors',
    component_name = 'mc_searchcount',
    padding = {
      left = 0,
      right = 0,
    },
    separator = { left = Icons.left_half_1, right = Icons.right_half_1 },
    color = { bg = colors.dark2 },
  },
  searchcount = {
    'my_searchcount',
    component_name = 'searchcount',
    padding = {
      left = 0,
      right = 0,
    },
    separator = { left = Icons.left_half_1, right = Icons.right_half_1 },
    color = { bg = colors.dark2 },
  },
  datetime = {
    function()
      return os.date('%A %H:%M')
    end,
    icon = { Icons.alarm, color = { fg = colors.bright_aqua } },
    component_name = 'datetime',
    padding = {
      left = 0,
      right = 0,
    },
    separator = { left = Icons.left_half_1, right = Icons.right_half_1 },
    color = { fg = colors.light1, bg = colors.dark2, gui = 'italic' },
  },
  progress = {
    'my_progress',
    component_name = 'progress',
    padding = {
      left = 0,
      right = 0,
    },
    separator = { left = Icons.left_half_1 },
  },
  location = {
    'my_location',
    component_name = 'location',
    padding = {
      left = 0,
      right = 1,
    },
    separator = { left = Icons.left_half_1 },
  },
  mode = {
    'my_mode',
    component_name = 'mode',
    padding = {
      left = 1,
      right = 1,
    },
    separator = { left = Icons.left_half_1, right = Icons.right_half_1 },
  },
  text = {
    'my_text',
    component_name = 'text',
    padding = {
      left = 1,
      right = 0,
    },
    separator = { left = Icons.left_half_1, right = Icons.right_half_1 },
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
        module.datetime,
      },
      lualine_y = {
        module.space,
      },
      lualine_z = {
        module.location,
        module.progress,
      },
    },
    filetypes = { 'TelescopePrompt', 'neo-tree', 'trouble', 'ClangdTypeHierarchy', 'lazy', 'mason' },
  },
}

M.setup = function()
  local cfg = {
    options = {
      section_separators = { left = '', right = '' },
      component_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = {}, -- only ignores the ft for statusline.
        winbar = {}, -- only ignores the ft for winbar.
      },
      always_divide_middle = true,
      globalstatus = true,
      refresh = {
        statusline = 2000,
        tabline = 2000,
        winbar = 2000,
      },
    },
  }

  local theme_cfg = {
    options = {
      theme = 'gruvbox',
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
        module.mc_searchcount,
        module.space,
        module.searchcount,
        module.space,
        module.filetype,
        module.fileformat,
        module.encoding,
        module.datetime,
      },
      lualine_y = {
        module.space,
      },
      lualine_z = {
        module.location,
        module.progress,
      },
    },
  }

  -- stylua: ignore
  Tools.tbl_r_extend(cfg, theme_cfg,
                          active_section_cfg,
                          inactive_section_cfg,
                          extensions_cfg)

  Events.emit(e_name.SETUP_LUALINE, cfg)

  Lualine.setup(cfg)
end

return M

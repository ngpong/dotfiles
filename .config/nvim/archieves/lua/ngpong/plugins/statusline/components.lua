local function hl_text(hl, text)
  return "%#" .. hl .. "#" .. text .. "%*"
end

local group = vim.__autocmd.augroup("statusline")

vim.api.nvim_set_hl(0, "LualineLspIcon", { fg = vim.__color.gray })
vim.api.nvim_set_hl(0, "LualineGitbranchIcon", { fg = vim.__color.bright_purple })

-- git_diff updater
local git_diff_update = false
group:on("User", function()
  git_diff_update = true
end, { pattern = "GitSignsUpdate" })
group:on("BufEnter", function()
  git_diff_update = true
end)

-- git_branch updater
local git_branch_update = false
group:on("User", function()
  git_branch_update = true
end, { pattern = "GitSignsChanged" })
group:on("BufEnter", function()
  git_branch_update = true
end)

return {
  fill = {
    static = {
      component_name = "fill",
    },
    provider = function()
      return "%="
    end
  },
  mode = {
    static = {
      component_name = "mode",
      names = {
        ["n"]     = "N",
        ["niI"]   = "N",
        ["niR"]   = "N",
        ["niV"]   = "N",
        ["nt"]    = "N",
        ["ntT"]   = "N",
        ["no"]    = "N",
        ["nov"]   = "N",
        ["noV"]   = "N",
        ["no\22"] = "N",
        ["v"]     = "V",
        ["vs"]    = "V",
        ["V"]     = "V",
        ["Vs"]    = "V",
        ["\22"]   = "VV",
        ["\22s"]  = "VV",
        ["s"]     = "S",
        ["S"]     = "S",
        ["\19"]   = "S",
        ["i"]     = "I",
        ["ic"]    = "I",
        ["ix"]    = "I",
        ["R"]     = "R",
        ["Rc"]    = "R",
        ["Rx"]    = "R",
        ["Rv"]    = "R",
        ["Rvc"]   = "R",
        ["Rvx"]   = "R",
        ["c"]     = "C",
        ["cv"]    = "E",
        ["ce"]    = "E",
        ["r"]     = "R",
        ["rm"]    = "?",
        ["r?"]    = "?",
        ["!"]     = "!",
        ["t"]     = "T",
      },
      colors = {
        ["DEFAULT"] = "purple",
        ["N"]       = "blue",
        ["V"]       = "orange",
        ["I"]       = "red",
        ["C"]       = "green",
        ["T"]       = "cyan",
      },
    },
    init = function(self)
      self.mode_name = self.names[vim.fn.mode(1)]
      self.mode_hl   = self.colors[self.mode_name] or self.colors["DEFAULT"]
    end,
    update = "ModeChanged",
    {
      provider = function(self)
        return " 🐂 " .. self.mode_name .. "  "
      end,
      hl = function(self)
        return { bg = self.mode_hl, fg = vim.__color.dark0 }
      end
    },
  },
  location = {
    static = {
      component_name = "location",
    },
    { provider = "%#GruvboxYellow#%* %l/%L:%c  %#GruvboxGray#%* %P" },
  },
  encoding = {
    static = {
      component_name = "encoding",
    },
    update = "BufEnter",
    {
      provider = function()
        local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
        return vim.__icons.files_2 .. " " .. enc:lower()
      end,
    },
    { provider = "  " },
  },
  filetype = {
    static = {
      override = {
        NvimTree = "explorer",
        lazy = "plugins",
      },
      component_name = "filetype",
    },
    update = "BufEnter",
    {
      init = function(self)
        self.icon, self.icon_color = vim.__icons.get_icon_color_by_ft(vim.bo.filetype)
      end,
      provider = function(self)
        return self.icon .. " "
      end,
      hl = function(self)
        return self.icon_color
      end,
    },
    {
      provider = function(self)
        local ft = vim.bo.filetype
        return string.lower(self.override[ft] or ft)
      end,
    },
    { provider = "  " },
  },
  os = {
    static = {
      component_name = "os",
    },
    init = function(self)
      self.os_name = vim.__util.get_os()
    end,
    update = "VimEnter",
    {
      init = function(self)
        self.iinfo = require("nvim-web-devicons").get_icons_by_operating_system()[self.os_name]
      end,
      provider = function(self)
        return self.iinfo.icon
      end,
      hl = function(self)
        return { fg = self.iinfo.color }
      end
    },
    {
      provider = function(self)
        return " " .. self.os_name
      end
    },
    { provider = "  " },
  },
  search = {
    static = {
      component_name = "search",
    },
    condition = function()
      return vim.v.hlsearch > 0 and vim.fn.getreg("/") ~= ""
    end,
    {
      provider = function()
        local sinfo = vim.fn.searchcount({ maxcount = 0 })
        local search_stat = sinfo.incomplete > 0 and '?/?' or sinfo.total > 0 and ('%s/%s'):format(sinfo.current, sinfo.total) or nil

        if search_stat then
          return "%#GruvboxYellow#%* " .. search_stat
        end
      end,
    },
    { provider = "  " },
  },
  lsp = {
    static = {
      icon_txt = hl_text("LualineLspIcon", vim.__icons.activelsp),
      component_name = "lsp",
    },
    update = { "LspAttach", "LspDetach", "WinEnter" },
    condition = function()
      vim.lsp.buf_is_attached(0)
    end,
    { provider = "  " },
    {
      provider = function(self)
        local clis = vim.lsp.get_clients({ bufnr = vim.__buf.current() })
        if next(clis) then
          return self.icon_txt .. " " .. clis[1].name:gsub("_", "")
        end
      end,
    }
  },
  diagnostics = {
    static = {
      component_name = "diagnostics",
    },
    update = { "DiagnosticChanged", "BufEnter" },
    condition = function()
      return #vim.diagnostic.count(0) > 0
    end,
    { provider = "  " },
    {
      provider = function()
        local ret = {}
        local size = 0

        local diagnostics = vim.diagnostic.get(0)

        local info_count = diagnostics[3] or 0
        if info_count > 0 then
          ret[size + 1] = hl_text("DiagnosticInfo", vim.__icons.diagnostic_info .. " " .. info_count)
          size = size + 1
        end

        local hint_count = diagnostics[4] or 0
        if hint_count > 0 then
          ret[size + 1] = hl_text("DiagnosticHint", vim.__icons.diagnostic_hint .. " " .. hint_count)
          size = size + 1
        end

        local warn_count = diagnostics[2] or 0
        if warn_count > 0 then
          ret[size + 1] = hl_text("DiagnosticWarn", vim.__icons.diagnostic_warn .. " " .. warn_count)
          size = size + 1
        end

        local error_count = diagnostics[1] or 0
        if error_count > 0 then
          ret[size + 1] = hl_text("DiagnosticError", vim.__icons.diagnostic_err .. " " .. error_count)
          size = size + 1
        end

        return size > 0 and table.concat(ret, " ")
      end
    },
  },
  git_branch = {
    static = {
      component_name = "git_branch",
      icon_txt = hl_text("LualineGitbranchIcon", vim.__icons.git_2),
    },
    condition = function()
      return vim.b.gitsigns_head
    end,
    update = function()
      if git_branch_update then
        git_branch_update = false
        return true
      else
        return false
      end
    end,
    { provider = "  " },
    {
      provider = function(self)
        return self.icon_txt .. " " .. vim.b.gitsigns_head
      end
    }
  },
  git_diff = {
    static = {
      component_name = "git_diff",
    },
    condition = function()
      return vim.b.gitsigns_status_dict
    end,
    update = function()
      if git_diff_update then
        git_diff_update = false
        return true
      else
        return false
      end
    end,
    { provider = "  " },
    {
      provider = function(_)
        local ret = {}
        local size = 0

        local status_dict = vim.b.gitsigns_status_dict

        local added_count = status_dict.added or 0
        if added_count > 0 then
          ret[size + 1] = hl_text("GitSignsAdd", vim.__icons.git_add .. " " .. added_count)
          size = size + 1
        end

        local changed_count = status_dict.changed or 0
        if changed_count > 0 then
          ret[size + 1] = hl_text("GitSignsChange", vim.__icons.git_add .. " " .. changed_count)
          size = size + 1
        end

        local removed_count = status_dict.removed or 0
        if removed_count > 0 then
          ret[size + 1] = hl_text("GitSignsDelete", vim.__icons.git_add .. " " .. removed_count)
          size = size + 1
        end

        return size > 0 and table.concat(ret, " ")
      end
    },
  },
}
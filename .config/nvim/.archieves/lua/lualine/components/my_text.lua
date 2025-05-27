local LualineRequire   = require("lualine_require")
local LualineComponent = LualineRequire.require("lualine.component")

local t_api = vim._plugins.trouble.api

local M = LualineComponent:extend()

local elements = {
  {
    val = vim.__icons.mid_dot,
    name = "e1",
    fg_hl = vim.__color.bright_aqua,
    bg_hl = vim.__color.dark2,
  },
  {
    val = vim.__icons.mid_dot,
    name = "e2",
    fg_hl = vim.__color.bright_red,
    bg_hl = vim.__color.dark2,
  },
  {
    val = function(bufnr)
      local filetype = vim.__buf.filetype(bufnr)

      if filetype == "mason" then
        return "Mason package manager"
      elseif filetype == "lazy" then
        return "Lazy plugins manager"
      elseif filetype == "ClangdTypeHierarchy" then
        return "Clangd type hierarchy"
      elseif filetype == "trouble" then
        return t_api.get_cur_view_name()
      elseif filetype == "NvimTree" then
        return "File explorer"
      end

      return ""
    end,
    name = "e3",
    fg_hl = vim.__color.light1,
    bg_hl = vim.__color.dark2,
    gui = "italic,bold",
  },
}

local apply_hl = function(self)
  for _, element in pairs(elements) do
    element.hl_token = self:create_hl({ fg = element.fg_hl, bg = element.bg_hl, gui = element.gui }, element.name)
  end
end

M.init = function(self, options)
  M.super.init(self, options)

  apply_hl(self)
end

M.update_status = function(self, _)
  local results = {}

  local bufnr = vim.__buf.current()

  local icon_element
  if (vim.__plugin.loaded("trouble.nvim") and t_api.is_previewing()) then
    icon_element = elements[2]
  else
    icon_element = elements[1]
  end

  local text_element
  text_element = elements[3]

  results[#results+1] = self:format_hl(icon_element.hl_token) .. icon_element.val
  results[#results+1] = self:format_hl(text_element.hl_token) .. text_element.val(bufnr)

  return table.concat(results, " ")
end

return M

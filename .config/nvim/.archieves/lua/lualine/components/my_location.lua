local LualineRequire   = require("lualine_require")
local LualineComponent = LualineRequire.require("lualine.component")

local M = LualineComponent:extend()

local elements = {
  {
    val = vim.__icons.location,
    name = "e1",
    bg_hl = vim.__color.bright_green,
  },
  {
    val = function()
      local line = vim.fn.line(".")
      local col = vim.fn.virtcol(".")
      return string.format(" %3d:%-3d", line, col)
    end,
    name = "e2",
    fg_hl = vim.__color.bright_green,
    bg_hl = vim.__color.dark2,
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
  for _, element in ipairs(elements) do
    local val
    if type(element.val) == "function" then
      val = element.val()
    else
      val = element.val
    end

    local text = self:format_hl(element.hl_token) .. val

    results[#results + 1] = text
  end

  if #results > 0 then
    return table.concat(results, " ")
  else
    return ""
  end
end

return M

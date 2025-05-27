local LualineRequire   = require("lualine_require")
local LualineComponent = LualineRequire.require("lualine.component")
local LualineUtilsMode = LualineRequire.require("lualine.utils.mode")

local M = LualineComponent:extend()

local elements = {
  {
    val = vim.__icons.rabbit,
    name = "e1",
    fg_hl = "#ffffff",
  },
  {
    val = vim.__icons.cat,
    name = "e2",
    fg_hl = vim.__color.dark0,
  },
  {
    val = vim.__icons.cat,
    name = "e3",
    fg_hl = "#f2d896",
  },
  -- {
  --   val = function()
  --     return LualineUtilsMode.get_mode():sub(1, 1)
  --   end,
  --   name = "e4",
  --   fg_hl = vim.__color.dark0,
  --   gui = "italic,bold",
  -- },
}

local apply_hl = function(self)
  for _, element in pairs(elements) do
    element.hl_token = self:create_hl({ fg = element.fg_hl, gui = element.gui }, element.name)
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

    results[#results+1] = text
  end

  if #results > 0 then
    return table.concat(results, " ")
  else
    return ""
  end
end

return M

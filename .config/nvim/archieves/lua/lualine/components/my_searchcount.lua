local LualineRequire   = require("lualine_require")
local LualineComponent = LualineRequire.require("lualine.component")

local M = LualineComponent:extend()

local elements = {
  {
    val = vim.__icons.search,
    name = "e1",
    fg_hl = vim.__color.bright_yellow,
  },
  {
    val = function(result)
      return string.format("%d/%d", result.current, result.total)
    end,
    name = "e2",
    fg_hl = vim.__color.light1,
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
  local pattern = vim.fn.getreg("/")
  if pattern == "" then
    return ""
  end

  local ok, result = pcall(vim.fn.searchcount, { recompute = true, pattern = pattern, maxcount = 999 })
  if not ok or next(result) == nil then
    return ""
  end

  local results = {}
  for _, element in ipairs(elements) do
    local val
    if type(element.val) == "function" then
      val = element.val(result)
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

local LualineRequire   = require("lualine_require")
local LualineComponent = LualineRequire.require("lualine.component")

local M = LualineComponent:extend()

local elements = {
  {
    val = vim.__icons.search .. vim.__icons.space,
    name = "e1",
    fg_hl = vim.__color.bright_blue,
  },
  {
    val = function(count)
      return string.format("%d", count.selected)
    end,
    name = "e2",
    fg_hl = {
      Normal = vim.__color.bright_blue,
      Insert = vim.__color.bright_red,
    },
    gui = "underline"
  },
  {
    val = function(count)
      return string.format(" %d/%d", count.current, count.total)
    end,
    name = "e3",
    fg_hl = vim.__color.light1,
  },
}

local apply_hl = function(self)
  for _, element in pairs(elements) do
    if type(element.fg_hl) == "table" then
      element.hl_token = {}
      element.multi_hl_token = true
      for key, fg_hl in pairs(element.fg_hl) do
        element.hl_token[key] = self:create_hl({ fg = fg_hl, bg = element.bg_hl, gui = element.gui }, element.name .. "_" .. key)
      end
    else
      element.hl_token = self:create_hl({ fg = element.fg_hl, bg = element.bg_hl, gui = element.gui }, element.name)
    end
  end
end

M.init = function(self, options)
  M.super.init(self, options)

  apply_hl(self)
end

M.update_status = function(self, _)
  local pattern = vim.b.MultiCursorPattern
  if pattern == "" or not pattern then
    return ""
  end

  pattern = string.gsub(pattern, "%.", "\\.")

  local ok, count = pcall(vim.fn.searchcount, { recompute = true, pattern = pattern, maxcount = 999 })
  if not ok or next(count) == nil then
    return ""
  end

  count.selected = #require("multicursors.utils").get_all_selections() + 1

  local results = {}
  for _, element in ipairs(elements) do
    local val
    if type(element.val) == "function" then
      val = element.val(count)
    else
      val = element.val
    end

    local hl_token
    if element.multi_hl_token then
      hl_token = element.hl_token[vim._plugins.multicursors.api.get_mode()]
    else
      hl_token = element.hl_token
    end

    local text = self:format_hl(hl_token) .. val

    results[#results+1] = text
  end

  if #results > 0 then
    return table.concat(results, "")
  else
    return ""
  end
end

return M

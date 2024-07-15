local Icons            = require('ngpong.utils.icon')
local LualineRequire   = require('lualine_require')
local LualineComponent = LualineRequire.require('lualine.component')

local colors       = Plgs.colorscheme.colors
local multicursors = Plgs.multicursors

local M = LualineComponent:extend()

local elements = {
  {
    val = Icons.search .. Icons.space,
    name = 'e1',
    fg_hl = colors.bright_blue,
  },
  {
    val = function(count)
      return string.format('%d', count.selected)
    end,
    name = 'e2',
    fg_hl = {
      Normal = colors.bright_blue,
      Insert = colors.bright_red,
    },
    gui = 'underline'
  },
  {
    val = function(count)
      return string.format(' %d/%d', count.current, count.total)
    end,
    name = 'e3',
    fg_hl = colors.light1,
  },
}

local apply_hl = function(self)
  for _, element in pairs(elements) do
    if type(element.fg_hl) == 'table' then
      element.hl_token = {}
      element.multi_hl_token = true
      for key, fg_hl in pairs(element.fg_hl) do
        element.hl_token[key] = self:create_hl({ fg = fg_hl, bg = element.bg_hl, gui = element.gui }, element.name .. '_' .. key)
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
  if pattern == '' or not pattern then
    return ''
  end

  local ok, count = pcall(vim.fn.searchcount, { recompute = true, pattern = pattern })
  if not ok or next(count) == nil then
    return ''
  end

  count.selected = #require('multicursors.utils').get_all_selections() + 1

  local results = {}
  for _, element in ipairs(elements) do
    local val
    if type(element.val) == 'function' then
      val = element.val(count)
    else
      val = element.val
    end

    local hl_token
    if element.multi_hl_token then
      hl_token = element.hl_token[multicursors.api.get_cur_mode()]
    else
      hl_token = element.hl_token
    end

    local text = self:format_hl(hl_token) .. val

    table.insert(results, text)
  end

  if #results > 0 then
    return table.concat(results, '')
  else
    return ''
  end
end

return M

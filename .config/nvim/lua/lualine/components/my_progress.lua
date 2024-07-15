local Icons = require('ngpong.utils.icon')
local LualineRequire = require('lualine_require')
local LualineComponent = LualineRequire.require('lualine.component')

local colors = Plgs.colorscheme.colors

local M = LualineComponent:extend()

local elements = {
  {
    val = Icons.progress,
    name = 'e1',
    bg_hl = colors.bright_yellow,
  },
  {
    val = function()
      local cur = vim.fn.line('.')
      local total = vim.fn.line('$')
      if cur == 1 then
        return string.format('%2s%s%-2s', 'T', 'o', 'p')
      elseif cur == total then
        return string.format('%2s%s%-2s', 'B', 'o', 't')
      else
        return string.format('%3d%-3s', math.floor(cur / total * 100), '%%')
      end
    end,
    name = 'e2',
    fg_hl = colors.bright_yellow,
    bg_hl = colors.dark2,
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
    if type(element.val) == 'function' then
      val = element.val()
    else
      val = element.val
    end

    local text = self:format_hl(element.hl_token) .. val

    table.insert(results, text)
  end

  if #results > 0 then
    return table.concat(results, ' ')
  else
    return ''
  end
end

return M

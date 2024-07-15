local Icons            = require('ngpong.utils.icon')
local LualineRequire   = require('lualine_require')
local LualineComponent = LualineRequire.require('lualine.component')

local colors    = Plgs.colorscheme.colors
local neotree   = Plgs.neotree
local trouble   = Plgs.trouble
local telescope = Plgs.telescope

local M = LualineComponent:extend()

local elements = {
  {
    val = Icons.circular_mid,
    name = 'e1',
    fg_hl = colors.bright_aqua,
    bg_hl = colors.dark2,
  },
  {
    val = Icons.circular_mid,
    name = 'e2',
    fg_hl = colors.bright_yellow,
    bg_hl = colors.dark2,
  },
  {
    val = function(bufnr)
      local filetype = Helper.get_filetype(bufnr)

      if filetype == 'mason' then
        return 'Mason package manager'
      elseif filetype == 'lazy' then
        return 'Lazy plugins manager'
      elseif filetype == 'ClangdTypeHierarchy' then
        return 'Clangd type hierarchy'
      elseif filetype == 'trouble' then
        return trouble.api.get_cur_view_name()
      elseif filetype == 'neo-tree' then
        return 'Neotree'
      elseif filetype == 'TelescopePrompt' then
        return telescope.api.get_current_picker(bufnr).prompt_title
      end

      return ''
    end,
    name = 'e3',
    fg_hl = colors.light1,
    bg_hl = colors.dark2,
    gui = 'italic,bold',
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

  local bufnr = Helper.get_cur_bufnr()

  local icon_element
  if neotree.api.is_previewing() or
     telescope.api.is_previewing(Helper.get_cur_bufnr()) or
     trouble.api.is_previewing() then
    icon_element = elements[2]
  else
    icon_element = elements[1]
  end

  local text_element
  text_element = elements[3]

  table.insert(results, self:format_hl(icon_element.hl_token) .. icon_element.val)
  table.insert(results, self:format_hl(text_element.hl_token) .. text_element.val(bufnr))

  return table.concat(results, ' ')
end

return M

local M = {}

local lazy    = require('ngpong.utils.lazy')
local trouble = lazy.require('trouble')

local trouble_actions = lazy.access('trouble', 'action')

M.actions = setmetatable({}, {
  __index = function(t, k)
    if k == 'nop' then
      return function() end
    else
      return TOOLS.wrap_f(trouble_actions, k)
    end
  end
})

M.toggle = function(mod, source)
  mod = mod or ''
  source = source or ''

  local success, _ = pcall(vim.cmd, 'TroubleToggle ' .. mod)
  if success and M.is_open() then
    VAR.set('TroubleSource', source)
  end
end

M.open = function(mod, source)
  mod = mod or ''
  source = source or ''

  local success, _ = pcall(vim.cmd, 'Trouble ' .. mod)
  if success then
    VAR.set('TroubleSource', source)
  end
end

M.close = function(mod)
  mod = mod or ''

  pcall(vim.cmd, 'TroubleClose ' .. mod)
end

M.is_open = function()
  return trouble.is_open()
end

return M
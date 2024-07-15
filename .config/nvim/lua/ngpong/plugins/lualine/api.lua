local M = {}

local Lazy    = require('ngpong.utils.lazy')
local Lualine = Lazy.require('lualine')

M.refresh = function(args, f_refresh)
  local default = {
    kind = 'window',
    place = { 'statusline' },
  }

  f_refresh = f_refresh or Lualine.refresh
  args = vim.tbl_deep_extend('force', default, args or {})

  f_refresh(args)
end

return M

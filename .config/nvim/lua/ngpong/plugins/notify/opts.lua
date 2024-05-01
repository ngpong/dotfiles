local M = {}

local lazy = require('ngpong.utils.lazy')

M.setup = function()
  vim.opt.termguicolors = true

  vim.notify = lazy.require('notify')
end

return M

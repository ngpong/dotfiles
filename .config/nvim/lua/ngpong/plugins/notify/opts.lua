local M = {}

M.setup = function()
  vim.opt.termguicolors = true

  vim.notify = require('ngpong.utils.lazy').require('notify')
end

return M

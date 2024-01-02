local M = {}

M.setup = function()
  vim.opt.termguicolors = true

  vim.notify = require('notify')
end

return M
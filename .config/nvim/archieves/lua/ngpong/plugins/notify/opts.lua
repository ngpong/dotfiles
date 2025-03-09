local M = {}

M.setup = function()
  vim.opt.termguicolors = true

  vim.notify = vim.__lazy.require("notify")
end

return M

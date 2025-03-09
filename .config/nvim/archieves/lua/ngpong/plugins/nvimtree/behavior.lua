local M = {}

local etypes = vim.__event.types

M.setup = function()
  vim.__event.rg(etypes.OPEN_NVIMTREE, vim.__async.schedule_wrap(function(_)
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
    vim.wo.statuscolumn = ""
    vim.wo.foldcolumn = "0"
  end))
end

return M

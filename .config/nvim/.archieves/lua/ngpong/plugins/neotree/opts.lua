local M = {}

local etypes = vim.__event.types

M.setup = function()
  vim.g.neo_tree_remove_legacy_commands = 1

  vim.__event.rg(etypes.OPEN_NEOTREE, function(_)
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
    vim.wo.statuscolumn = ""
    vim.wo.foldcolumn = "0"
  end)
end

return M

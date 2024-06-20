local M = {}

local Events = require('ngpong.common.events')

local e_name = Events.e_name

M.setup = function()
  vim.g.neo_tree_remove_legacy_commands = 1

  Events.rg(e_name.OPEN_NEOTREE, function(_)
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = 'no'
    vim.wo.statuscolumn = ''
    vim.wo.foldcolumn = '0'
  end)
end

return M

local M = {}

local NvimTreeAPI = vim.__lazy.require("nvim-tree.api")

M.toggle = function(opts)
  NvimTreeAPI.tree.toggle(opts)
end

return M
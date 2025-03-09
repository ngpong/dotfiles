local M = {}

local View = vim.__lazy.require("trouble.view")

M.setup = function()
  local real_jump = View.jump
  View.jump = function(...)
    local args = { ... }

    vim.__g.cursor_persist = false
    real_jump(vim.__tbl.unpack(args))

    vim.schedule(function() vim.__g.cursor_persist = true end)
  end
end

return M

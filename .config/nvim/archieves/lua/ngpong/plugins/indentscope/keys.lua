local M = {}

local kmodes = vim.__key.e_mode

local set_native_keymaps = function()
  vim.__key.rg({ kmodes.N, kmodes.VS }, "e1[", function()
    vim.cmd("lua MiniIndentscope.operator(\"top\", true)")
  end, { silent = true, desc = "prev @indent" })

  vim.__key.rg({ kmodes.N, kmodes.VS }, "e1]", function()
    vim.cmd("lua MiniIndentscope.operator(\"bottom\", true)")
  end, { silent = true, desc = "next @indent" })
end

M.setup = function()
  set_native_keymaps()
end

return M

local M = {}

local del_native_keymaps = function()
end

local set_native_keymaps = function()
  vim.__key.rg(vim.__key.e_mode.N, "<leader>P", "<CMD>Mason<CR>", { desc = "open mason package manager." })
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()
end

return M

local M = {}

local t_api = vim._plugins.trouble.api

local kmodes = vim.__key.e_mode

local del_native_keymaps = function()
  vim.__key.unrg(kmodes.N, "n")
end

local set_native_keymaps = function()
  vim.__key.rg(kmodes.N, "n[", vim.__util.wrap_f(vim.__lazy.access("todo-comments", "jump_prev")), { desc = "jump to prev." })
  vim.__key.rg(kmodes.N, "n]", vim.__util.wrap_f(vim.__lazy.access("todo-comments", "jump_next")), { desc = "jump to next." })
  vim.__key.rg(kmodes.N, "nn", vim.__util.wrap_f(t_api.toggle, "todo"), { silent = true, desc = "toggle document todo list." })
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()
end

return M

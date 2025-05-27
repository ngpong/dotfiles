local M = {}

local t_api = vim._plugins.trouble.api

local kmodes = vim.__key.e_mode
local etypes = vim.__event.types

local set_native_keymaps = function()
  local wrap = vim.__util.wrap_f

  vim.__key.rg(kmodes.N, "<leader>l", wrap(t_api.toggle, "loclist"), { silent = true, desc = "toggle location list." })
  vim.__key.rg(kmodes.N, "<leader>q", wrap(t_api.toggle, "quickfix"), { silent = true, desc = "toggle quickfix list." })
end

local del_buffer_keymaps = function(state)
  vim.__key.rg({ kmodes.N, kmodes.VS }, "a", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg({ kmodes.N, kmodes.VS }, "x", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg({ kmodes.N, kmodes.VS }, "X", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg({ kmodes.N, kmodes.VS }, "c", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg({ kmodes.N, kmodes.VS }, "C", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg({ kmodes.N, kmodes.VS }, "u", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "z", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "Z", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "b", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "b,", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "b.", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "b>", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "b<", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "bp", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "bs", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "bc", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "bo", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "B", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "BC", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "B<", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "B>", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "m", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "mm", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "m,", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "m.", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "md", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "md<leader>", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "md<CR>", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "me", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "ms", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "ms<leader>", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "rh", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "rv", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "rc", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "ts", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "dp", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "d[", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "d]", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "e[", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "e]", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg({ kmodes.N, kmodes.VS }, "<leader>/", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg({ kmodes.N, kmodes.VS }, "<leader>h", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg({ kmodes.N, kmodes.VS }, "<leader>c", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg({ kmodes.N, kmodes.VS }, "<leader>u", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg({ kmodes.N, kmodes.VS }, "<leader>U", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "<leader>f", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "e1", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "e2", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "e3", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "e4", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "e5", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "e1.", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "e1,", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "e2.", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "e2,", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "e3.", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "e3,", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "e4.", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "e4,", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "e5.", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "e5,", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "n[", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "n]", function() end, { buffer = state.buf, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "<leftmouse>", function() end, { buffer = state.buf, desc = "which_key_ignore" })
end

local set_buffer_keymaps = function(state)
  vim.__key.rg(kmodes.N, "<ESC>", t_api.close_current, { buffer = state.buf, desc = "TROUBLE: close trouble list." })
  vim.__key.rg(kmodes.N, "<S-CR>", t_api.jump_close, { buffer = state.buf, desc = "TROUBLE: open selected entry into buffer and close trouble." })
  vim.__key.rg(kmodes.N, "<CR>", t_api.jump, { buffer = state.buf, desc = "TROUBLE: open selected entry into buffer." })
  vim.__key.rg(kmodes.N, "<C-p>", t_api.toggle_preview, { buffer = state.buf, desc = "TROUBLE: toggle preview with selected entry." })
  vim.__key.rg(kmodes.N, "z", t_api.fold_toggle, { buffer = state.buf, desc = "TROUBLE: toggle folds." })
  vim.__key.rg(kmodes.N, "<C-z>", t_api.fold_close_all, { buffer = state.buf, desc = "TROUBLE: close all folds." })
  vim.__key.rg(kmodes.N, "Z", t_api.fold_open_all, { buffer = state.buf, desc = "TROUBLE: open all folds." })
  vim.__key.rg(kmodes.N, "R", t_api.refresh, { buffer = state.buf, desc = "TROUBLE: refresh trouble list." })

  if t_api.has_switch(state.view.opts.mode) then
    vim.__key.rg(kmodes.N, "<", vim.__util.wrap_f(t_api.switch, state.view.opts.mode), { buffer = state.buf, desc = "TROUBLE: switch prev sources." })
    vim.__key.rg(kmodes.N, ">", vim.__util.wrap_f(t_api.switch, state.view.opts.mode), { buffer = state.buf, desc = "TROUBLE: switch next sources." })
  end
end

M.setup = function()
  set_native_keymaps()

  vim.__event.rg(etypes.CREATE_TROUBLE_LIST, vim.__async.schedule_wrap(function(state)
    del_buffer_keymaps(state)
    set_buffer_keymaps(state)
  end))
end

return M

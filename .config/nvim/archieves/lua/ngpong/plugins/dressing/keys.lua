local M = {}

local kmodes = vim.__key.e_mode
local etypes = vim.__event.types

local set_buffer_keymaps = function(state)
  if state.completion then
    vim.__key.del(kmodes.I, "<Tab>", { buffer = state.bufnr })
  end
end

M.setup = function()
  vim.__event.rg(etypes.OPEN_DRESSING_INPUT, function(state)
    set_buffer_keymaps(state)
  end)
end

return M

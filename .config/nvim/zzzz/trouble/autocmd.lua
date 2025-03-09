local M = {}

local etypes = vim.__event.types

local setup_autocmds = function()
  vim.__event.rg(etypes.CREATE_TROUBLE_LIST, function(state)
    vim.__autocmd.augroup("trouble"):on("WinLeave", function(_)
      state.view.opts.auto_preview = false
    end, { buffer = state.buf })
  end)
end

M.setup = function()
  setup_autocmds()
end

return M

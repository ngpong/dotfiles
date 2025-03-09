local M = {}

M.setup = function()
  require("lspconfig.ui.windows").default_options.border = "rounded"
end

return M
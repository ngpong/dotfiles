local M = {}

function M.info(msg)
  vim.api.nvim_echo({ { msg, "None" } }, true, {})
end

function M.warn(msg)
  vim.api.nvim_echo({ { msg, "WarningMsg" } }, true, {})
end

function M.err(msg)
  vim.api.nvim_echo({ { msg, "ErrorMsg" } }, true, {})
end

return M

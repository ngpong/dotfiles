local M = {}

M.refresh = function(args, f_refresh)
  local default = {
    kind = "window",
    scope = "window",
    place = { "statusline" },
  }

  args = vim.tbl_deep_extend("force", default, args or {})

  f_refresh(args)
end

return M

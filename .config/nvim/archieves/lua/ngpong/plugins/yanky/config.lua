local M = {}

M.setup = function()
  require("YankAssassin").setup {
    auto_normal = true,
    auto_visual = false,
  }
end

return M
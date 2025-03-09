local M = {}

M.setup = function()
  require("hop").setup({
    teasing = false,
    virtual_cursor = false,
    dim_unmatched = false,
    create_hl_autocmd = false,
    uppercase_labels = false,
    hl_mode = "combine",
    yank_register = "*",
  })
end

return M

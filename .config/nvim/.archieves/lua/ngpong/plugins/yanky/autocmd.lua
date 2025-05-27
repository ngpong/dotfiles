local M = {}

local setup_autocmds = function()
  vim.__autocmd.augroup("yanky"):on("TextYankPost", function(_)
    if vim.b.visual_multi then
      return
    end

    if vim.__helper.get_mode() == "no" then
      vim.highlight.on_yank{ higroup = "Visual", timeout = 75 }
    end
  end)
end

M.setup = function()
  setup_autocmds()
end

return M
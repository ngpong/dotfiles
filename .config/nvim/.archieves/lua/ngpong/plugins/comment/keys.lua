local M = {}

local CommentAPI = vim.__lazy.require("Comment.api")
local CommentCfg = vim.__lazy.require("Comment.config")

local kmodes = vim.__key.e_mode

local set_native_keymaps = function()
  vim.__key.rg(kmodes.N, "<leader>/", function()
    CommentAPI.locked("toggle.linewise.current")()
  end, { silent = true, desc = "toggle line-comment." })

  vim.__key.rg(kmodes.N, "<leader>?", function()
    CommentAPI.locked("toggle.blockwise.current")()
  end, { silent = true, desc = "toggle block-comment." })

  vim.__key.rg(kmodes.VS, "<leader>/", function()
    vim.__key.feed("<ESC>", "nx")
    CommentAPI.locked("toggle.linewise")(vim.fn.visualmode())
  end, { silent = true, desc = "toggle line-comment." })

  vim.__key.rg(kmodes.VS, "<leader>?", function()
    vim.__key.feed("<ESC>", "nx")
    CommentAPI.locked("toggle.blockwise")(vim.fn.visualmode())
  end, { silent = true, desc = "toggle block-comment." })
end

M.setup = function()
  set_native_keymaps()
end

return M

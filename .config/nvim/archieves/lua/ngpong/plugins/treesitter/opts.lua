local M = {}

M.setup = function()
  -- https://www.reddit.com/r/neovim/comments/1144spy/will_treesitter_ever_be_stable_on_big_files/
  -- vim.treesitter.query.set("javascript", "injections", "")
  -- vim.treesitter.query.set("typescript", "injections", "")
  -- vim.treesitter.query.set("lua", "injections", "")
  -- vim.treesitter.query.set("comment", "injections", "")
  -- vim.treesitter.set_query("cpp", "injections", "")
end

return M
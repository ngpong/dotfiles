local M = {}

M.setup = function()
  -- https://www.reddit.com/r/neovim/comments/1144spy/will_treesitter_ever_be_stable_on_big_files/
  -- pcall(vim.treesitter.query.set, 'javascript', 'injections', '')
  -- pcall(vim.treesitter.query.set, 'typescript', 'injections', '')
  -- pcall(vim.treesitter.query.set, 'lua', 'injections', '')
  -- pcall(vim.treesitter.query.set, 'lua', 'cpp', '')
  -- pcall(vim.treesitter.query.set, 'comment', 'injections', '')
end

return M
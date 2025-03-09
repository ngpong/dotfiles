local M = {}

local group = vim.__autocmd.augroup("treesitter")

local unset_autocmds = function()
  group:del()
end

local setup_autocmds = function()
  group:on({"BufEnter","BufAdd","BufNew","BufNewFile","BufWinEnter"}, function()
    -- TODO: fold method
    -- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#packernvim
    vim.wo.foldmethod  = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldtext = "v:lua.vim.treesitter.foldtext()"
    vim.wo.foldenable = false
  end)
end

M.setup = function()
  unset_autocmds()
  setup_autocmds()
end

return M

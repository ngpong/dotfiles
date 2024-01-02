local M = {}

local autocmd = require('ngpong.common.autocmd')

local unset_autocmds = function()
  autocmd.del_augroup('treesitter')
end

local setup_autocmds = function()
  local group_id = autocmd.new_augroup('treesitter')

  vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
    group = group_id,
    callback = function()
      -- TODO: fold method
      -- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#packernvim
      vim.wo.foldmethod  = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo.foldtext = 'v:lua.vim.treesitter.foldtext()'
      vim.wo.foldenable = false
    end
  })
end

M.setup = function()
  unset_autocmds()
  setup_autocmds()
end

return M
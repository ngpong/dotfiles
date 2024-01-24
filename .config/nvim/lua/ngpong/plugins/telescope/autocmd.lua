local M = {}

local autocmd = require('ngpong.common.autocmd')
local async   = require('plenary.async')

local this = PLGS.telescope

local unset_autocmds = function()
  autocmd.del_augroup('telescope')
end

local setup_autocmds = function()
  local group_id = autocmd.new_augroup('telescope')

  vim.api.nvim_create_autocmd('WinEnter', {
    group = group_id,
    callback = function(args)
      local bufnr = args.buf
      async.run(function()
        async.util.scheduler()
        if this.api.is_prompt_buf(bufnr) then
          HELPER.feedkeys('g$')
        end
      end)
    end,
  })

  vim.api.nvim_create_autocmd('ExitPre', {
    group = group_id,
    callback = function(args)
      for _, tabpage in pairs(HELPER.get_list_tabpage()) do
        for _, winid in pairs(HELPER.get_list_winids(tabpage)) do
          local bufnr = HELPER.get_bufnr(winid)

          if this.api.is_prompt_buf(bufnr) then
            this.api.actions.close(bufnr)
            vim.cmd('qall')
            return
          end
        end
      end
    end,
  })

  -- preview 显示行号
  -- https://github.com/nvim-telescope/telescope.nvim/issues/1186
  vim.cmd 'autocmd User TelescopePreviewerLoaded setlocal number'
end

M.setup = function()
  unset_autocmds()
  setup_autocmds()
end

return M

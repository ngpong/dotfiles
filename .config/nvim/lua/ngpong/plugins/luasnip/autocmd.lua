local M = {}

local autocmd = require('ngpong.common.autocmd')
local luasnip = require('luasnip')

local unset_autocmds = function()
  autocmd.del_augroup('luasnip')
end

local setup_autocmds = function()
  local group_id = autocmd.new_augroup('luasnip')

  vim.api.nvim_create_autocmd('ModeChanged', {
    group = group_id,
    pattern = '*',
    callback = function(_)
      if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
          and luasnip.session.current_nodes[HELPER.get_cur_bufnr()]
          and not luasnip.session.jump_active
      then
        luasnip.unlink_current()
      end
    end
  })
end

M.setup = function()
  unset_autocmds()
  setup_autocmds()
end

return M

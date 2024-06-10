local M = {}

local Autocmd = require('ngpong.common.autocmd')
local Lazy    = require('ngpong.utils.lazy')
local Luasnip = Lazy.require('luasnip')

local unset_autocmds = function()
  Autocmd.del_augroup('luasnip')
end

local setup_autocmds = function()
  Autocmd.new_augroup('luasnip').on('ModeChanged', function(_)
    if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
        and Luasnip.session.current_nodes[Helper.get_cur_bufnr()]
        and not Luasnip.session.jump_active
    then
      Luasnip.unlink_current()
    end
  end)
end

M.setup = function()
  unset_autocmds()
  setup_autocmds()
end

return M

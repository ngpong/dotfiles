local M = {}

local autocmd     = require('ngpong.common.autocmd')
local bouncer     = require('ngpong.utils.debounce')
local navic_lib   = require('nvim-navic.lib')
local barbecue_ui = require('barbecue.ui')

local unset_autocmds = function()
  autocmd.del_augroup('barbecue')
end

local setup_autocmds = function()
  local group_id = autocmd.new_augroup('barbecue')

  vim.api.nvim_create_autocmd({
    'WinResized',
    'BufWinEnter',
    'InsertLeave',
    'CursorHold',
  }, {
    group = group_id,
    callback = function(args)
      if not vim.b[args.buf].barbecu_enable then
        return
      end

      barbecue_ui.update()
    end,
  })

  vim.api.nvim_create_autocmd({
    'CursorMoved'
  }, {
    group = group_id,
    callback = bouncer.throttle_trailing(350, true, function(args)
      vim.schedule(function()
        if not HELPER.is_buf_valid(args.buf) then
          return
        end

        if not vim.b[args.buf].barbecu_enable then
          return
        end

        navic_lib.update_context(args.buf)
        barbecue_ui.update()
      end)
    end),
  })
end

M.setup = function()
  unset_autocmds()
  setup_autocmds()
end

return M
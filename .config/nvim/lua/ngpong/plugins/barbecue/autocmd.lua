local M = {}

local autocmd     = require('ngpong.common.autocmd')
local bouncer     = require('ngpong.utils.debounce')
local events      = require('ngpong.common.events')
local lazy        = require('ngpong.utils.lazy')
local navic_lib   = lazy.require('nvim-navic.lib')
local barbecue_ui = lazy.require('barbecue.ui')

local e_events = events.e_name

local setup_autocmds = function()
  -- 0x1: 保证任何文件都有 wintab 显示
  events.rg(e_events.VIM_ENTER, function()
    vim.api.nvim_create_autocmd({
      'BufWinEnter',
      'WinResized',
    }, {
      group = autocmd.new_augroup('barbecue'),
      callback = function(args)
        vim.schedule(function()
          if not PLGS.is_loaded('barbecue.nvim') then
            return
          end
          
          if not HELPER.is_buf_valid(args.buf) then
            return
          end

          barbecue_ui.update()
        end)
      end,
    })
  end)

  -- 0x2: 保证仅附加了navic的文件能够更新tabline的状态(因为只有它们会存在符号)
  local _proc_insert_leave = false
  events.rg(e_events.ATTACH_NAVIC, function(state)
    vim.api.nvim_create_autocmd({
      'CursorMoved',
      'InsertLeave',
    }, {
      group = autocmd.new_augroup('barbecue_' .. state.bufnr),
      buffer = state.bufnr,
      callback = bouncer.throttle_trailing(350, true, function(args)
        vim.schedule(function() 
          if args.event == 'CursorMoved' and  _proc_insert_leave then
            _proc_insert_leave = false
            return
          end

          if args.event == 'InsertLeave' then
            _proc_insert_leave = true
          end

          if not HELPER.is_buf_valid(state.bufnr) then
            return
          end

          if not PLGS.is_loaded('barbecue.nvim') then
            return
          end

          navic_lib.update_context(state.bufnr)
          barbecue_ui.update()
        end)
      end),
    })
  end)
end

M.setup = function()
  setup_autocmds()
end

return M
local M = {}

local Autocmd     = require('ngpong.common.autocmd')
local Bouncer     = require('ngpong.utils.debounce')
local Events      = require('ngpong.common.events')
local lazy        = require('ngpong.utils.lazy')
local NavicLib    = lazy.require('nvim-navic.lib')
local BarbecueuUI = lazy.require('barbecue.ui')

local e_name = Events.e_name

local setup_autocmds = function()
  -- 0x1: 保证任何文件都有 wintab 显示
  Events.rg(e_name.VIM_ENTER, function()
    Autocmd.new_augroup('barbecue').on({ 'BufWinEnter', 'WinResized', }, function(args)
      vim.schedule(function()
        if not Plgs.is_loaded('barbecue.nvim') then
          return
        end

        if not Helper.is_buf_valid(args.buf) then
          return
        end

        BarbecueuUI.update()
      end)
    end)
  end)

  -- 0x2: 保证仅附加了navic的文件能够更新tabline的状态(因为只有它们会存在符号)
  local _proc_insert_leave = false
  Events.rg(e_name.ATTACH_NAVIC, function(state)
    Autocmd.new_augroup('barbecue_' .. state.bufnr).on({ 'CursorMoved', 'InsertLeave', }, Bouncer.throttle_trailing(350, true, function(args)
      vim.schedule(function()
        if args.event == 'CursorMoved' and  _proc_insert_leave then
          _proc_insert_leave = false
          return
        end

        if args.event == 'InsertLeave' then
          _proc_insert_leave = true
        end

        if not Helper.is_buf_valid(state.bufnr) then
          return
        end

        if not Plgs.is_loaded('barbecue.nvim') then
          return
        end

        NavicLib.update_context(state.bufnr)
        BarbecueuUI.update()
      end)
    end), state.bufnr)
  end)
end

M.setup = function()
  setup_autocmds()
end

return M

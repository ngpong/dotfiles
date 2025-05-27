local M = {}
local C = {}

local NavicLib    = vim.__lazy.require("nvim-navic.lib")
local BarbecueuUI = vim.__lazy.require("barbecue.ui")

local etypes = vim.__event.types

local setup_autocmds = function()
  -- 0x1: 保证任何文件都有最基础的 wintab 显示；该 wintab 主要负责显示文件名
  local b1 = vim.__bouncer.throttle_leading(10, vim.__async.schedule_wrap(function(state)
    if not vim.__plugin.loaded("barbecue.nvim") then
      return
    end

    if not vim.__buf.is_valid(state.buf) then
      return
    end

    BarbecueuUI.update()
  end))
  vim.__event.rg(etypes.VIM_ENTER, function()
    vim.__autocmd.augroup("barbecue"):on({ "BufWinEnter", "WinResized", }, function(...)
      b1(...)
    end)
  end)

  -- 0x2: 保证仅附加了navic的文件能够更新tabline的状态(因为只有它们会存在符号)
  local b2 = vim.__bouncer.throttle_trailing(350, true, vim.__async.schedule_wrap(function(state)
    if state.event == "CursorMoved" and C.__proc_insert_leave then
      C.__proc_insert_leave = false
      return
    end

    if state.event == "InsertLeave" then
      C.__proc_insert_leave = true
    end

    if not vim.__buf.is_valid(state.buf) then
      return
    end

    if not vim.__plugin.loaded("barbecue.nvim") then
      return
    end

    NavicLib.update_context(state.buf)
    BarbecueuUI.update()
  end))
  vim.__event.rg(etypes.ATTACH_NAVIC, function(state)
    vim.__autocmd.augroup("barbecue_" .. state.bufnr):on({ "CursorMoved", "InsertLeave", }, function(...)
      b2(...)
    end, { buffer = state.bufnr })
  end)
  vim.__event.rg(etypes.DETACH_NAVIC, function(state)
    vim.__autocmd.del_augroup("barbecue_" .. state.bufnr)
  end)
end

M.setup = function()
  setup_autocmds()
end

return M

local M = {}

local lazy      = require('ngpong.utils.lazy')
local async     = lazy.require('plenary.async')
local navic_lib = lazy.require('nvim-navic.lib')

M.setup = function()
  local __executing = false

  local __f = function()
    if not PLGS.is_loaded('barbecue.nvim') then
      return
    end

    local mode = HELPER.get_cur_mode()
    if mode.mode == 'i' or mode.blocking then
      return
    end

    local bufnr = HELPER.get_cur_bufnr()
    if not HELPER.is_buf_valid(bufnr) then
      return
    end
    if not vim.b[bufnr].barbecu_enable then
      return
    end

    local clis = vim.lsp.get_clients({ bufnr = bufnr })
    if not next(clis) then
      return
    end

    -- 防止一些慢速LS存在消息积压的情况
    if __executing then
      return
    end

    __executing = true
    navic_lib.request_symbol(bufnr, async.void(function(_bufnr, _symbols)
      async.util.scheduler()

      if not HELPER.is_buf_valid(_bufnr) then
        return
      end

      navic_lib.update_data(_bufnr, _symbols)

      __executing = false
    end), clis[1])
  end

  -- nvim-navic获取符号的时机是 { 'InsertLeave', 'BufEnter', 'CursorHold', 'AttachNavic' }，可能会有一些临界的情况漏掉，故这里是进行一个补充
  async.run(function()
    while true do
      __f()
      async.util.sleep(1500)
    end
  end)
end

return M

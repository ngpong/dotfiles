local M = {}
local C = {}

local NavicLib = vim.__lazy.require("nvim-navic.lib")

M.setup = function()
  local __f = function()
    if not vim.__plugin.loaded("barbecue.nvim") then
      return
    end

    local mode = vim.__helper.get_mode()
    if mode.mode == "i" or mode.blocking then
      return
    end

    local bufnr = vim.__buf.current()
    if not vim.__buf.is_valid(bufnr) then
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
    if C.__executing then
      return
    else
      C.__executing = true
    end

    NavicLib.request_symbol(bufnr, vim.__async.schedule_wrap(function(_bufnr, _symbols)
      if not vim.__buf.is_valid(_bufnr) then
        return
      end

      NavicLib.update_data(_bufnr, _symbols)

      C.__executing = false
    end), clis[1])
  end

  -- nvim-navic获取符号的时机是 { "InsertLeave", "BufEnter", "CursorHold", "AttachNavic" }，可能会有一些临界的情况漏掉，故这里是进行一个补充
  vim.__async.run(function()
    while true do
      __f()
      vim.__async.sleep(1500)
    end
  end)
end

return M

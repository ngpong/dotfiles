local M = {}
local C = {}

local Lualine = vim.__lazy.require("lualine")

local l_api = vim.__stl

local __hack_refresh = function()
  local f_refresh = Lualine.refresh

  C.__org_refresh = function(...)
    f_refresh(...)
  end
  C.__bouncer_refresh = vim._Bouncer.throttle_leading(20, vim.__async.schedule_wrap(function(...)
    f_refresh(...)
  end))

  local org = l_api.refresh
  l_api.refresh = function(args, bouncer)
    if not bouncer then
      org(args, C.__org_refresh)
    else
      org(args, C.__bouncer_refresh)
    end
  end

  Lualine.refresh = l_api.refresh
end

M.setup = function()
  -- HACK: 调整原插件的刷新事件；添加一些bounce的逻辑

  -- 0x1: 一般情况下，每次 refresh 整体消耗会在 400 ~ 500 ns 左右，但是刷新次数非常频繁
  __hack_refresh()

  -- 0x2: 删除插件原生的刷新事件
  vim.__autocmd.del_augroup("lualine_stl_refresh", "name")
  vim.__autocmd.del_augroup("lualine_tal_refresh", "name")
  vim.__autocmd.del_augroup("lualine_wb_refresh", "name")

  local group = vim.__autocmd.augroup("lualine")

  -- 0x3: 重新设置 autocmd

  -- 0x4: 使用节流的refresh
  group:on({ "BufWritePost", "SessionLoadPost", "FileChangedShellPost", "VimResized", "CmdlineLeave", "CursorMoved" }, function(state)
    l_api.refresh({ trigger = "autocmd" }, true)
  end)
  group:on("LspAttach", function(state)
    l_api.refresh({ trigger = "autocmd" }, true)
  end, { once = true })
  group:on("WinEnter", function(state)
    if C.buf_entering then C.buf_entering = nil return end
    l_api.refresh({ trigger = "autocmd" }, true)
  end)

  -- 0x5: 使用默认的refresh
  group:on("BufEnter", function(state) -- 某些事件在满足bounce与trigger="autocmd"任意一项配置的情况下都会出现statusline刷新闪烁的问题
    C.buf_entering = true
    l_api.refresh()
  end)
  group:on("ModeChanged", function(state)
    l_api.refresh()
  end)
end

return M

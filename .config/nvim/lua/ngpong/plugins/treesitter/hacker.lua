local M = {}

local lazy       = require('ngpong.utils.lazy')
local async      = lazy.require('plenary.async')
local treesitter = lazy.require('nvim-treesitter.configs')

M.setup = function()
  -- NOTE: 可能会有BUG
  -- 延迟加载，以解决打开 buffer 的时候会出现一些卡顿的问题
  -- 直接在 neovim 命令行打开文件时没效果

  -- 渐进的异步
  local base = 100
  local cur  = base
  local max  = 200
  local inc  = 10

  local real_detach_module = treesitter.detach_module
  treesitter.detach_module = async.void(function(mod_name, bufnr)
    async.util.sleep(base)

    cur = cur + inc
    if cur > max then
      cur = base
    end

    if not HELPER.is_buf_valid(bufnr) or HELPER.is_unnamed_buf(bufnr) then
      return
    end

    real_detach_module(mod_name, bufnr)
  end)

  local real_attach_module = treesitter.attach_module
  treesitter.attach_module = async.void(function(mod_name, bufnr, lang)
    async.util.sleep(base)

    cur = cur + inc
    if cur > max then
      cur = base
    end

    if not HELPER.is_buf_valid(bufnr) or HELPER.is_unnamed_buf(bufnr) then
      return
    end

    real_attach_module(mod_name, bufnr, lang)
  end)
end

return M


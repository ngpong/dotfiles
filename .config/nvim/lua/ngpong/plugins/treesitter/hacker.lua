local M = {}

local libP       = require('ngpong.common.libp')
local Lazy       = require('ngpong.utils.lazy')
local Treesitter = Lazy.require('nvim-treesitter.configs')

M.setup = function()
  -- NOTE: 可能会有BUG
  -- 延迟加载，以解决打开 buffer 的时候会出现一些卡顿的问题
  -- 直接在 neovim 命令行打开文件时没效果

  -- 渐进的异步
  local base = 100
  local cur  = base
  local max  = 200
  local inc  = 10

  local real_detach_module = Treesitter.detach_module
  Treesitter.detach_module = libP.async.void(function(mod_name, bufnr)
    libP.async.util.sleep(cur)

    cur = cur + inc
    if cur > max then
      cur = base
    end

    if not Helper.is_buf_valid(bufnr) or Helper.is_unnamed_buf(bufnr) then
      return
    end

    real_detach_module(mod_name, bufnr)
  end)

  local real_attach_module = Treesitter.attach_module
  Treesitter.attach_module = libP.async.void(function(mod_name, bufnr, lang)
    libP.async.util.sleep(cur)

    cur = cur + inc
    if cur > max then
      cur = base
    end

    if not Helper.is_buf_valid(bufnr) or Helper.is_unnamed_buf(bufnr) then
      return
    end

    real_attach_module(mod_name, bufnr, lang)
  end)
end

return M


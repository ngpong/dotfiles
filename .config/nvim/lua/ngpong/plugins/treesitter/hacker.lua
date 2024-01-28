local M = {}

local lazy       = require('ngpong.utils.lazy')
local async      = lazy.require('plenary.async')
local treesitter = lazy.require('nvim-treesitter.configs')

M.setup = function()
  -- NOTE: 可能会有BUG
  -- 延迟加载，以解决打开 buffer 的时候会出现一些卡顿的问题
  local detach_module = treesitter.detach_module
  treesitter.detach_module = async.void(function(mod_name, bufnr)
    async.util.sleep(50)

    if not HELPER.is_buf_valid(bufnr) then
      return
    end

    detach_module(mod_name, bufnr)
  end)
  local attach_module = treesitter.attach_module
  treesitter.attach_module = async.void(function(mod_name, bufnr, lang)
    async.util.sleep(50)

    if not HELPER.is_buf_valid(bufnr) then
      return
    end

    attach_module(mod_name, bufnr, lang)
  end)
  -- local reattach_module = treesitter.reattach_module
  -- treesitter.reattach_module = async.void(function(...)
  --   async.util.sleep(50)
  --   reattach_module(...)
  -- end)
end

return M


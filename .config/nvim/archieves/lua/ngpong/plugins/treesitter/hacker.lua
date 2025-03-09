local M = {}

local Treesitter = vim.__lazy.require("nvim-treesitter.configs")

M.setup = function()
  -- HACK: 延迟加载，以解决打开 buffer 的时候会出现一些卡顿的问题；直接在 neovim 命令行打开文件时没效果

  -- 渐进的异步
  local base = 100
  local cur  = base
  local max  = 200
  local inc  = 10

  local real_detach_module = Treesitter.detach_module
  Treesitter.detach_module = vim.__async.void(function(mod_name, bufnr)
    if mod_name == "highlight" then
      vim.__async.sleep(cur)

      cur = cur + inc
      if cur > max then
        cur = base
      end

      if not vim.__buf.is_valid(bufnr) or vim.__buf.is_unnamed(bufnr) then
        return
      end
    end

    real_detach_module(mod_name, bufnr)
  end)

  local real_attach_module = Treesitter.attach_module
  Treesitter.attach_module = vim.__async.void(function(mod_name, bufnr, lang)
    if mod_name == "highlight" then
      vim.__async.sleep(cur)

      cur = cur + inc
      if cur > max then
        cur = base
      end

      if not vim.__buf.is_valid(bufnr) or vim.__buf.is_unnamed(bufnr) then
        return
      end
    end

    real_attach_module(mod_name, bufnr, lang)
  end)
end

return M

local M = {}

local b_api = vim._plugins.bufferline.api
local t_api = vim._plugins.trouble.api

local kmodes = vim.__key.e_mode

local del_native_keymaps = function(_)
end

local set_native_keymaps = function(_)
  vim.__key.rg(kmodes.N, "b]", b_api.cycle_next, { desc = "cycle next buffer." })
  vim.__key.rg(kmodes.N, "b[", b_api.cycle_prev, { desc = "cycle prev buffer." })
  vim.__key.rg(kmodes.N, "bb", vim.__util.wrap_f(t_api.toggle, "buffers"), { desc = "toggle buffers list." })
  vim.__key.rg(kmodes.N, "b.", b_api.move_next, { desc = "move current buffer prev in sequence." })
  vim.__key.rg(kmodes.N, "b,", b_api.move_prev, { desc = "move current buffer next in sequence." })
  vim.__key.rg(kmodes.N, "bs", b_api.select, { desc = "select target buffer." })
  vim.__key.rg(kmodes.N, "bt", b_api.pin, { desc = "tack current buffer." })
  vim.__key.rg(kmodes.N, "bc", vim.__util.wrap_f(vim.__bufdel, nil, false, function(bufnr)
    return not b_api.is_pinned(bufnr)
  end), { desc = "wipeout current buffer." })
  vim.__key.rg(kmodes.N, "bo", function ()
    vim.__ui.input({ prompt = "This operation will delete all buffers except current, yes(y) or no(n,...)?", relative = "editor" }, function(res)
      if res ~= "y" then
        return
      end

      for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
        vim.__buf.del(bufnr, false, function(bufnr)
          local is_current  = vim.__buf.current() == bufnr
          local is_pinned   = b_api.is_pinned(bufnr)
          local is_floating = vim.__win.is_float()

          return not is_current and not is_pinned and not is_floating
        end)
      end
    end)
  end, { desc = "wipeout all buffers except current." })
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()
end

return M

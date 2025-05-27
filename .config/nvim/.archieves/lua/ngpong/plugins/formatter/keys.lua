local M = {}

local Conform = vim.__lazy.require("conform")

local kmodes = vim.__key.e_mode

local set_native_keymaps = function()
  vim.__key.rg({ kmodes.N, kmodes.VS }, "<leader>h", function()
    local opts = {
      bufnr = 0,
      async = false,
      timeout_ms = 500,
      lsp_fallback = false,
      quiet = false,
      callback = nil, -- function
    }

    if vim.__helper.get_mode() == "n" then
      vim.__ui.input({ prompt = "This operation will format the entire file, yes(y) or no(n,...)?", relative = "editor" }, function(res)
        if res ~= "y" then
          return
        end

        Conform.format(opts)
      end)
    else
      Conform.format(opts)
    end
  end, { silent = true, desc = "format entire file." })
end

M.setup = function()
  set_native_keymaps()
end

return M

local M = {}

local Keymap  = require('ngpong.common.keybinder')
local Lazy    = require('ngpong.utils.lazy')
local Conform = Lazy.require('conform')

local e_mode = Keymap.e_mode

local dressing = Plgs.dressing

local set_native_keymaps = function()
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<leader>h', function()
    local opts = {
      bufnr = 0,
      async = false,
      timeout_ms = 500,
      lsp_fallback = false,
      quiet = false,
      callback = nil, -- function
    }

    if Helper.get_cur_mode().mode == 'n' then
      dressing.config.scope_set({ input = { relative = 'editor' } }, function()
        vim.ui.input({ prompt = 'This operation will format the entire file, yes(y) or no(n,...)?', default = '' }, function(res)
          if res ~= 'y' then
            return
          end

          Conform.format(opts)
        end)
      end)
    else
      Conform.format(opts)
    end
  end, { silent = true, remap = false, desc = 'format entire file.' })
end

M.setup = function()
  set_native_keymaps()
end

return M

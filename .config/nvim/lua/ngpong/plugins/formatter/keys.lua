local M = {}

local helper = require('ngpong.common.helper')
local keymap = require('ngpong.common.keybinder')
local lazy = require('ngpong.utils.lazy')
local conform = lazy.require('conform')

local e_mode = keymap.e_mode

local dressing = PLGS.dressing

local set_native_keymaps = function()
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<leader>h', function()
    local opts = {
      bufnr = 0,
      async = false,
      timeout_ms = 500,
      lsp_fallback = false,
      quiet = false,
      callback = nil, -- function
    }

    if helper.get_cur_mode().mode == 'n' then
      dressing.config.scope_set({ input = { relative = 'editor' } }, function()
        vim.ui.input({ prompt = 'This operation will format the entire file, yes(y) or no(n,...)?', default = '' }, function(res)
          if res ~= 'y' then
            return
          end

          conform.format(opts)
        end)
      end)
    else
      conform.format(opts)
    end
  end, { silent = true, remap = false, desc = 'format entire file.' })
end

M.setup = function()
  set_native_keymaps()
end

return M

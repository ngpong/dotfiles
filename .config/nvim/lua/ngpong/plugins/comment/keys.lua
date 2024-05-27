local M = {}

local keymap      = require('ngpong.common.keybinder')
local lazy        = require('ngpong.utils.lazy')
local comment_api = lazy.require('Comment.api')
local comment_cfg = lazy.require('Comment.config')

local e_mode = keymap.e_mode

local set_native_keymaps = function()
  keymap.register(e_mode.NORMAL, '<leader>j', function()
    comment_api.locked('toggle.linewise.current')
  end, { silent = true, remap = false, desc = 'toggle line-comment.' })
  keymap.register(e_mode.NORMAL, '<leader>J', function()
    comment_api.locked('toggle.blockwise.current')
  end, { silent = true, remap = false, desc = 'toggle block-comment.' })
  keymap.register(e_mode.VISUAL, '<leader>j', function()
    HELPER.feedkeys('<ESC>', 'nx')
    comment_api.locked('toggle.linewise')(vim.fn.visualmode())
  end, { silent = true, remap = false, desc = 'toggle line-comment.' })
  keymap.register(e_mode.VISUAL, '<leader>J', function()
    HELPER.feedkeys('<ESC>', 'nx')
    comment_api.locked('toggle.blockwise')(vim.fn.visualmode())
  end, { silent = true, remap = false, desc = 'toggle block-comment.' })
end

M.setup = function()
  set_native_keymaps()
end

return M

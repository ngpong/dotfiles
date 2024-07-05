local M = {}

local Keymap     = require('ngpong.common.keybinder')
local Lazy       = require('ngpong.utils.lazy')
local CommentAPI = Lazy.require('Comment.api')
local CommentCfg = Lazy.require('Comment.config')

local e_mode = Keymap.e_mode

local set_native_keymaps = function()
  Keymap.register(e_mode.NORMAL, '<leader>/', function()
    CommentAPI.locked('toggle.linewise.current')()
  end, { silent = true, remap = false, desc = 'toggle line-comment.' })

  Keymap.register(e_mode.NORMAL, '<leader>?', function()
    CommentAPI.locked('toggle.blockwise.current')()
  end, { silent = true, remap = false, desc = 'toggle block-comment.' })

  Keymap.register(e_mode.VISUAL, '<leader>/', function()
    Helper.feedkeys('<ESC>', 'nx')
    CommentAPI.locked('toggle.linewise')(vim.fn.visualmode())
  end, { silent = true, remap = false, desc = 'toggle line-comment.' })

  Keymap.register(e_mode.VISUAL, '<leader>?', function()
    Helper.feedkeys('<ESC>', 'nx')
    CommentAPI.locked('toggle.blockwise')(vim.fn.visualmode())
  end, { silent = true, remap = false, desc = 'toggle block-comment.' })
end

M.setup = function()
  set_native_keymaps()
end

return M

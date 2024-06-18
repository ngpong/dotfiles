local M = {}

local Events = require('ngpong.common.events')
local Keymap = require('ngpong.common.keybinder')
local UI     = require('ngpong.common.ui')

local e_mode = Keymap.e_mode
local e_name = Events.e_name

local del_native_keymaps = function(_)
  -- https://neovim.io/doc/user/repeat.html#complex-repeat
  Keymap.unregister(e_mode.NORMAL, 'q')
  Keymap.unregister(e_mode.NORMAL, 'Q')

  -- https://neovim.io/doc/user/motion.html#left-right-motions
  Keymap.unregister(e_mode.NORMAL, '$')
  Keymap.unregister(e_mode.NORMAL, '0')
  Keymap.unregister(e_mode.NORMAL, '^')
  Keymap.unregister(e_mode.NORMAL, 'h')
  Keymap.unregister(e_mode.NORMAL, 'l')
  Keymap.unregister(e_mode.NORMAL, '<C-H>')
  Keymap.unregister(e_mode.NORMAL, '<SPACE>')
  Keymap.unregister(e_mode.NORMAL, 't')
  Keymap.unregister(e_mode.NORMAL, 'T')
  Keymap.unregister(e_mode.NORMAL, ';')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<A-LEFT>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<A-RIGHT>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<RIGHT>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<LEFT>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<C-S-RIGHT>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<C-S-LEFT>')

  -- https://neovim.io/doc/user/motion.html#up-down-motions
  Keymap.unregister(e_mode.NORMAL, 'j')
  Keymap.unregister(e_mode.NORMAL, 'k')
  Keymap.unregister(e_mode.NORMAL, '<C-P>')
  Keymap.unregister(e_mode.NORMAL, '+')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, '<C-m>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT, e_mode.VISUAL }, '<C-J>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT, e_mode.VISUAL }, '<C-UP>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT, e_mode.VISUAL }, '<A-UP>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT, e_mode.VISUAL }, '<C-DOWN>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT, e_mode.VISUAL }, '<A-DOWN>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT, e_mode.VISUAL }, '<UP>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT, e_mode.VISUAL }, '<DOWN>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT, e_mode.VISUAL }, '<C-S-UP>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT, e_mode.VISUAL }, '<C-S-DOWN>')

  -- https://neovim.io/doc/user/motion.html#word-motions
  Keymap.unregister(e_mode.NORMAL, 'w')
  Keymap.unregister(e_mode.NORMAL, 'W')
  Keymap.unregister(e_mode.NORMAL, 'E')
  Keymap.unregister(e_mode.NORMAL, 'b')
  Keymap.unregister(e_mode.NORMAL, 'B')
  Keymap.unregister(e_mode.NORMAL, 'e')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<S-RIGHT>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<S-LEFT>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<C-RIGHT>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<C-LEFT>')

  -- https://neovim.io/doc/user/insert.html#inserting
  Keymap.unregister({ e_mode.VISUAL, e_mode.NORMAL }, 'I')
  Keymap.unregister({ e_mode.VISUAL, e_mode.NORMAL }, 'A')
  Keymap.unregister({ e_mode.VISUAL, e_mode.NORMAL }, 'O')
  Keymap.unregister({ e_mode.VISUAL, e_mode.NORMAL }, 'o')
  Keymap.unregister(e_mode.NORMAL, 'a')
  Keymap.unregister({ e_mode.VISUAL, e_mode.NORMAL }, 'i')

  -- https://neovim.io/doc/user/scroll.html#scroll-down
  Keymap.unregister(e_mode.NORMAL, '<C-e>')
  Keymap.unregister(e_mode.NORMAL, '<C-d>')
  Keymap.unregister(e_mode.NORMAL, '<C-f>')

  -- https://neovim.io/doc/user/scroll.html#scroll-up
  Keymap.unregister(e_mode.NORMAL, '<C-y>')
  Keymap.unregister(e_mode.NORMAL, '<C-u>')
  --Keymap.unregister(e_mode.NORMAL, '<C-b>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<S-UP>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<S-DOWN>')

  -- https://neovim.io/doc/user/change.html#deleting
  Keymap.unregister(e_mode.VISUAL, '<C-H>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'x')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'X')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'd')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'D')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'J')

  -- https://neovim.io/doc/user/change.html#delete-insert
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'c')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'C')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 's')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'S')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'R')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'r')

  -- https://neovim.io/doc/user/motion.html#object-select
  Keymap.unregister(e_mode.NORMAL, '(')
  Keymap.unregister(e_mode.NORMAL, ')')
  Keymap.unregister(e_mode.NORMAL, '{')
  Keymap.unregister(e_mode.NORMAL, '}')
  Keymap.unregister(e_mode.NORMAL, ']]')
  Keymap.unregister(e_mode.NORMAL, '[[')
  Keymap.unregister(e_mode.NORMAL, '[]')
  Keymap.unregister(e_mode.NORMAL, '][')
  Keymap.unregister(e_mode.VISUAL, 'ip')
  Keymap.unregister(e_mode.VISUAL, 'i\'')
  Keymap.unregister(e_mode.VISUAL, 'a\'')
  Keymap.unregister(e_mode.VISUAL, 'ap')

  -- https://neovim.io/doc/user/cmdline.html#cmdline-editing
  Keymap.unregister(e_mode.COMMAND, '<C-K>')
  Keymap.unregister(e_mode.COMMAND, '<C-J>')
  Keymap.unregister(e_mode.COMMAND, '<C-H>')
  Keymap.unregister(e_mode.NORMAL, ':')

  -- https://neovim.io/doc/user/cmdline.html#cmdline-completion
  Keymap.unregister(e_mode.COMMAND, '<C-L>')

  -- https://neovim.io/doc/user/motion.html#mark-motions
  Keymap.unregister(e_mode.NORMAL, '\'')
  Keymap.unregister(e_mode.NORMAL, 'm')
  Keymap.unregister(e_mode.NORMAL, '`')

  -- https://neovim.io/doc/user/insert.html#ins-completion
  Keymap.unregister(e_mode.INSERT, '<C-X>')
  Keymap.unregister(e_mode.INSERT, '<C-P>')

  -- https://neovim.io/doc/user/windows.html
  Keymap.unregister(e_mode.NORMAL, '<C-w>')

  -- https://neovim.io/doc/user/tagsrch.html#tag-stack
  Keymap.unregister(e_mode.NORMAL, '<C-t>')

  -- https://neovim.io/doc/user/various.html#various-cmds
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'K')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, '<C-L>')

  -- https://neovim.io/doc/user/motion.html#jump-motions
  Keymap.unregister(e_mode.NORMAL, '<C-o>')
  Keymap.unregister(e_mode.NORMAL, '<C-i>')

  -- https://neovim.io/doc/user/insert.html#ins-special-special
  Keymap.unregister(e_mode.INSERT, '<C-G>')
  Keymap.unregister(e_mode.INSERT, '<C-O>')

  -- https://neovim.io/doc/user/motion.html#various-motions
  Keymap.unregister(e_mode.NORMAL, 'H')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'L')
  Keymap.unregister(e_mode.NORMAL, 'M')

  -- https://neovim.io/doc/user/insert.html#ins-special-keys
  Keymap.unregister(e_mode.INSERT, '<C-J>')
  Keymap.unregister(e_mode.INSERT, '<C-K>')
  Keymap.unregister(e_mode.INSERT, '<C-H>')
  Keymap.unregister(e_mode.INSERT, '<C-r>')
  Keymap.unregister(e_mode.INSERT, '<C-d>')
  Keymap.unregister(e_mode.INSERT, '<C-t>')
  Keymap.unregister(e_mode.INSERT, '<C-f>')
  Keymap.unregister(e_mode.INSERT, '<C-y>')
  Keymap.unregister(e_mode.INSERT, '<C-u>')
  Keymap.unregister(e_mode.INSERT, '<C-b>')
  Keymap.unregister(e_mode.INSERT, '<C-w>')
  Keymap.unregister(e_mode.INSERT, '<C-i>')
  Keymap.unregister(e_mode.INSERT, '<C-S-i>')
  Keymap.unregister(e_mode.INSERT, '<C-[>')
  Keymap.unregister(e_mode.INSERT, '<C-{>')
  Keymap.unregister(e_mode.INSERT, '<A-[>')
  Keymap.unregister(e_mode.INSERT, '<A-]>')

  -- https://neovim.io/doc/user/vimindex.html#%5B
  Keymap.unregister(e_mode.NORMAL, '[')
  Keymap.unregister(e_mode.NORMAL, ']')

  -- https://neovim.io/doc/user/vimindex.html#g
  Keymap.unregister(e_mode.NORMAL, 'g')
  Keymap.unregister(e_mode.NORMAL, 'g,')
  Keymap.unregister(e_mode.NORMAL, 'g.')
  Keymap.unregister(e_mode.NORMAL, 'G')

  -- https://neovim.io/doc/user/visual.html#Select
  Keymap.unregister(e_mode.VISUAL, '<C-O>')

  -- https://neovim.io/doc/user/visual.html#visual-change
  Keymap.unregister(e_mode.VISUAL, 'O')
  Keymap.unregister(e_mode.VISUAL, 'o')

  -- https://neovim.io/doc/user/map.html#%3Amap-alt-keys
  Keymap.unregister(e_mode.INSERT, '<A-;>')
  Keymap.unregister(e_mode.INSERT, '<A-o>')
  Keymap.unregister(e_mode.INSERT, '<A-l>')
  Keymap.unregister(e_mode.INSERT, '<A-k>')
  Keymap.unregister(e_mode.INSERT, '<A-i>')
  Keymap.unregister(e_mode.INSERT, '<A-u>')
  Keymap.unregister(e_mode.INSERT, '<A-j>')
  Keymap.unregister(e_mode.INSERT, '<A-p>')
  Keymap.unregister(e_mode.INSERT, '<A-\'>')
  Keymap.unregister(e_mode.INSERT, '<A-Enter>')
  Keymap.unregister(e_mode.INSERT, '<A-backspace>')
  Keymap.unregister(e_mode.INSERT, '<A-O>')
  Keymap.unregister(e_mode.INSERT, '<A-L>')

  -- https://neovim.io/doc/user/change.html#copy-move
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'p')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'P')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'y')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'Y')

  -- https://neovim.io/doc/user/tagsrch.html#tag-commands
  Keymap.unregister(e_mode.NORMAL, '<C-]>')

  -- https://neovim.io/doc/user/change.html#complex-change
  Keymap.unregister(e_mode.NORMAL, '=')
  Keymap.unregister(e_mode.NORMAL, '&')

  -- https://neovim.io/doc/user/pattern.html#search-commands
  Keymap.unregister(e_mode.NORMAL, '?')
  Keymap.unregister(e_mode.NORMAL, 'n')
  Keymap.unregister(e_mode.NORMAL, 'N')

  -- https://neovim.io/doc/user/change.html#shift-left-right
  Keymap.unregister(e_mode.NORMAL, '<')
  Keymap.unregister(e_mode.NORMAL, '>')

  -- https://neovim.io/doc/user/pi_netrw.html#netrw-gx
  Keymap.unregister(e_mode.NORMAL, 'gx')

  -- https://neovim.io/doc/user/undo.html
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'u')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'U')
  Keymap.unregister(e_mode.NORMAL, '<C-r>')

  -- https://neovim.io/doc/user/starting.html#suspend
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, '<C-z>')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, '<C-S-z>')

  -- https://neovim.io/doc/user/change.html#formatting
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'gq')

  -- https://neovim.io/doc/user/lsp.html
  Keymap.unregister(e_mode.NORMAL, '<C-W>d')
  Keymap.unregister(e_mode.NORMAL, '<C-W><C-D>')
  Keymap.unregister(e_mode.NORMAL, '[d')
  Keymap.unregister(e_mode.NORMAL, ']d')
  Keymap.unregister(e_mode.NORMAL, '[D')
  Keymap.unregister(e_mode.NORMAL, ']D')

  -- 还不知道
  Keymap.unregister(e_mode.INSERT, '<C-l>')
  Keymap.unregister(e_mode.INSERT, '<C-;>')
  Keymap.unregister(e_mode.NORMAL, '<C-\'>')
  Keymap.unregister(e_mode.NORMAL, '<C-S-[>')
  Keymap.unregister({ e_mode.INSERT, e_mode.NORMAL }, '<C-S-p>')
  Keymap.unregister(e_mode.INSERT, '<C-A-p>')
  Keymap.unregister(e_mode.INSERT, '<C-A-l>')
  Keymap.unregister(e_mode.INSERT, '<A-">')
  Keymap.unregister(e_mode.INSERT, '<A-:>')
  Keymap.unregister(e_mode.INSERT, '<A-P>')
  Keymap.unregister(e_mode.INSERT, '<A-{>')
  Keymap.unregister(e_mode.INSERT, '<A-}>')
  Keymap.unregister(e_mode.NORMAL, '<C-S-e>')
  Keymap.unregister(e_mode.NORMAL, '<C-S-d>')
  Keymap.unregister(e_mode.NORMAL, ',')
  Keymap.unregister(e_mode.NORMAL, '.')
  Keymap.unregister(e_mode.NORMAL, '<S-CR>')
  Keymap.unregister(e_mode.NORMAL, '<C-CR>')
  Keymap.unregister(e_mode.NORMAL, 'gra')
  Keymap.unregister(e_mode.NORMAL, 'grr')
  Keymap.unregister(e_mode.NORMAL, 'grn')
  Keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL_X }, 'gcc')
  Keymap.unregister(e_mode.NORMAL, 'gc')
end

local set_native_keymaps = function()
  Keymap.register(e_mode.NORMAL, '<ESC>', Helper.close_floating_wins, { remap = false, mixture = 'native', desc = 'which_key_ignore' })
  Keymap.register(e_mode.INSERT, '<ESC>', '<ESC>', { remap = false, desc = 'which_key_ignore' })

  -- 重新映射 enter 功能
  Keymap.register(e_mode.NORMAL, '<CR>', '<C-m>', { remap = false, desc = 'which_key_ignore' })

  -- 进入 insert 模式
  Keymap.register(e_mode.NORMAL, 'a', 'a', { remap = false, desc = 'COMMON: enter(tail) inster mode.' })
  Keymap.register(e_mode.NORMAL, 'A', 'i', { remap = false, desc = 'COMMON: enter(head) inster mode.' })

  -- 进入 block visual 模式
  Keymap.register(e_mode.NORMAL, '<C-v>', '<C-v>', { remap = false, desc = 'COMMON: enter blockwise-visual mode.' })

  -- Left-Right-Up-Down montions
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'l', 'h', { remap = false, desc = 'MONTION: left.' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '\'', 'l', { remap = false, desc = 'MONTION: right.' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'p', function()
    if vim.v.count > 0 then
      return 'm\'' .. vim.v.count .. 'k'
    else
      return 'k'
    end
  end, { expr = true, remap = false, desc = 'MONTION: top.' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, ';', function()
    if vim.v.count > 0 then
      return 'm\'' .. vim.v.count .. 'j'
    else
      return 'j'
    end
  end, { expr = true, remap = false, desc = 'MONTION: down.' })
  Keymap.register(e_mode.INSERT, '<A-l>', '<LEFT>', { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.INSERT, '<A-\'>', '<RIGHT>', { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.INSERT, '<A-p>', '<UP>', { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.INSERT, '<A-;>', '<DOWN>', { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, '<S-p>', '<C-y>', { remap = false, desc = 'MONTION: keep cursor and scroll window upwards.' })
  Keymap.register(e_mode.NORMAL, ':', '<C-e>', { remap = false, desc = 'MONTION: keep cursor and scroll window downwards.' })
  Keymap.register(e_mode.VISUAL, '<S-p>', '<C-y>', { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.VISUAL, ':', '<C-e>', { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'L\"', 'zz', { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, '\"L', 'zz', { remap = false, desc = 'which_key_ignore' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<C-p>', '<C-u>', { remap = false, desc = 'MONTION: updown.' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<C-;>', '<C-d>', { remap = false, desc = 'MONTION: backward.' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<C-S-p>', '<C-b>', { remap = false, desc = 'MONTION: pageup' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<C-:>', '<C-f>', { remap = false, desc = 'MONTION: pagedown' })
  Keymap.register(e_mode.INSERT, '<C-p>', '<C-o><C-u>', { remap = false, desc = 'MONTION: updown.' })
  Keymap.register(e_mode.INSERT, '<C-;>', '<C-o><C-d>', { remap = false, desc = 'MONTION: backward.' })

  -- jump to
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'eh', function()
    Helper.presskeys('gg')
    Helper.add_jumplist()
  end, { remap = false, desc = 'file head.' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'et', function()
    Helper.presskeys('G')
    Helper.add_jumplist()
  end, { remap = false, desc = 'file tail.' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'eg', function()
    Helper.presskeys('N50%')
    Helper.add_jumplist()
  end, { remap = false, desc = 'file center.' })
  Keymap.register(e_mode.NORMAL, 'e,', '<C-O>', { remap = false, desc = 'older entry.' })
  Keymap.register(e_mode.NORMAL, 'e.', '<C-I>', { remap = false, desc = 'next entry.' })

  -- windows
  Keymap.register(e_mode.NORMAL, 'rv', '<CMD>vsp<CR>', { desc = 'split window vertically.' })
  Keymap.register(e_mode.NORMAL, 'rh', '<CMD>sp<CR>', { desc = 'split window horizontally.' })
  Keymap.register(e_mode.NORMAL, 'rc', '<CMD>wincmd c<CR>', { remap = false, desc = 'close current window.' })
  Keymap.register(e_mode.NORMAL, 'rsv', function()
    M.split_resize_mode = 'v'
  end, { desc = 'set vertically split resize mode.' })
  Keymap.register(e_mode.NORMAL, 'rsh', function()
    M.split_resize_mode = 'h'
  end, { desc = 'set horizontally split resize mode.' })
  Keymap.register(e_mode.NORMAL, 'r=', function()
    local mode = M.split_resize_mode or 'v'
    if mode == 'v' then
      vim.cmd('vertical resize +5')
    elseif mode == 'h' then
      vim.cmd('horizontal resize +5')
    end
  end, { desc = 'window (vertical/horizontal) resize +5.' })
  Keymap.register(e_mode.NORMAL, 'r-', function()
    local mode = M.split_resize_mode or 'v'
    if mode == 'v' then
      vim.cmd('vertical resize -5')
    elseif mode == 'h' then
      vim.cmd('horizontal resize -5')
    end
  end, { desc = 'window (vertical/horizontal) resize -5.' })
  Keymap.register(e_mode.NORMAL, 'rp', '<CMD>wincmd k<CR>', { remap = false, desc = 'move cursor to top window.' })
  Keymap.register(e_mode.NORMAL, 'r;', '<CMD>wincmd j<CR>', { remap = false, desc = 'move cursor to down window.' })
  Keymap.register(e_mode.NORMAL, 'rl', '<CMD>wincmd h<CR>', { remap = false, desc = 'move cursor to left window.' })
  Keymap.register(e_mode.NORMAL, 'r\'', '<CMD>wincmd l<CR>', { remap = false, desc = 'move cursor to right window.' })

  -- windows(tabline)
  Keymap.register(e_mode.NORMAL, 'ts', '<CMD>tab split<CR>', { desc = 'create a new tabpage.' })
  Keymap.register(e_mode.NORMAL, 'tc', '<CMD>tabclose<CR>', { desc = 'close current tabpage.' })
  Keymap.register(e_mode.NORMAL, 't.', '<CMD>tabnext<CR>', { desc = 'switch to next tabpage.' })
  Keymap.register(e_mode.NORMAL, 't,', '<CMD>tabprev<CR>', { desc = 'switch to prev tabpage.' })
  Keymap.register(e_mode.NORMAL, 'to', '<CMD>tabonly<CR>', { desc = 'close all tabpage except current.' })

  -- cmdline
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '|', ':', { remap = false, silent = false, desc = 'COMMON: enter command mode.' })
  Keymap.register(e_mode.COMMAND, '<A-p>', Tools.wrap_f(Helper.feedkeys, '<UP>'), { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.COMMAND, '<A-;>', Tools.wrap_f(Helper.feedkeys, '<DOWN>'), { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.COMMAND, '<A-l>', Tools.wrap_f(Helper.feedkeys, '<LEFT>'), { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.COMMAND, '<A-\'>', Tools.wrap_f(Helper.feedkeys, '<RIGHT>'), { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.COMMAND, '<A-q>', Tools.wrap_f(Helper.feedkeys, '<C-LEFT>'), { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.COMMAND, '<A-w>', Tools.wrap_f(Helper.feedkeys, '<C-RIGHT>'), { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.COMMAND, '<A-[>', Tools.wrap_f(Helper.feedkeys, '<HOME>'), { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.COMMAND, '<A-]>', Tools.wrap_f(Helper.feedkeys, '<END>'), { remap = false, desc = 'which_key_ignore' })

  -- search command
  Keymap.register(e_mode.NORMAL, '<C-.>', function()
    if vim.fn.getreg('/') == '' then
      return
    end

    local success, _ = pcall(vim.cmd, 'keepjumps normal! n')
    if not success then
      Helper.notify_warn('Pattern [' .. vim.fn.getreg('/') .. '] not found any matched result.', 'System: pattern')
      Helper.clear_commandline()
    end
  end, { remap = false, desc = 'SEARCH: jump to next match pattern.' })
  Keymap.register(e_mode.NORMAL, '<C-,>', function()
    if vim.fn.getreg('/') == '' then
      return
    end

    local success, _ = pcall(vim.cmd, 'keepjumps normal! N')
    if not success then
      Helper.notify_warn('Pattern [' .. vim.fn.getreg('/') .. '] not found any matched result.', 'System: pattern')
      Helper.clear_commandline()
    end
  end, { remap = false, desc = 'SEARCH: jump to prev match pattern.' })
  Keymap.register(e_mode.NORMAL, '?', function()
    Helper.clear_searchpattern()
    Helper.clear_commandline()
  end, { remap = false, desc = 'SEARCH: quit search pattern mode.' })

  -- 文本撤销/反撤销
  Keymap.register(e_mode.NORMAL, 'z', 'u', { remap = false, desc = 'TEXT: undo text.' })
  Keymap.register(e_mode.NORMAL, 'Z', '<C-r>', { remap = false, desc = 'TEXT: redo text.' })

  -- 文本复制与粘贴
  Keymap.register(e_mode.NORMAL, 'y', 'yl', { remap = false, desc = 'TEXT: copy text.' })
  Keymap.register(e_mode.VISUAL, 'y', 'y', { remap = false, desc = 'TEXT: copy text.' })
  Keymap.register(e_mode.NORMAL, 'u', 'p', { remap = false, desc = 'TEXT: paste(tail) text before.' })
  Keymap.register(e_mode.NORMAL, 'U', 'P', { remap = false, desc = 'TEXT: paste(head) text.' })
  Keymap.register(e_mode.VISUAL, 'u', 'P', { remap = false, desc = 'which_key_ignore' })

  -- 文本剪切
  Keymap.register(e_mode.VISUAL, 'c', 'c', { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'c', 'xi', { remap = false, desc = 'TEXT: cut character and enter insert mode.' })

  -- 文本删除
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'x', '"_x', { remap = false, desc = 'TEXT: delete character.' })
  Keymap.register(e_mode.NORMAL, 'X', 'dl', { remap = false, desc = 'TEXT: delete character and copy into clipboard.' })
  Keymap.register(e_mode.VISUAL, 'X', 'd', { remap = false, desc = 'which_key_ignore' })

  -- 重新映射一些键在insert模式下的行为
  Keymap.register(e_mode.INSERT, '<A-Enter>', '<CR>', { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.INSERT, '<A-backspace>', '<BS>', { remap = false, desc = 'which_key_ignore' })
  Keymap.register(e_mode.INSERT, '<TAB>', '<C-I>', { remap = false, desc = 'which_key_ignore' })

  -- 获取文件信息
  Keymap.register(e_mode.NORMAL, '<leader>f', UI.popup_fileinfo, { remap = false, desc = 'popup current file state.' })

  -- 大小写转换
  Keymap.register(e_mode.NORMAL, '<leader>u', Tools.wrap_f(Helper.feedkeys, 'guiw'), { remap = false, desc = 'convert word under cursor to lowercase.' })
  Keymap.register(e_mode.NORMAL, '<leader>U', Tools.wrap_f(Helper.feedkeys, 'gUiw'), { remap = false, desc = 'convert word under cursor to uppercase.' })
  Keymap.register(e_mode.VISUAL, '<leader>u', 'u', { remap = false, desc = 'convert selected text to lowercase.' })
  Keymap.register(e_mode.VISUAL, '<leader>U', 'U', { remap = false, desc = 'convert selected text to uppercase.' })
end

local del_buffer_keymaps = function(bufnr)
  bufnr = bufnr or true

  Keymap.unregister(e_mode.VISUAL, 'a', { buffer = bufnr })
end

local set_buffer_keymaps = function(bufnr)
  bufnr = bufnr or true

  -- 改善 <HOME> 的功能
  Keymap.register(e_mode.INSERT, '<A-[>', function()
    local byteidx = vim.fn.col('.')
    local sub = string.sub(vim.fn.getline('.'), 1, (byteidx == 1 and 1 or byteidx - 1))

    local row, _ = Helper.get_cursor()

    local pos = string.find(sub, '%S')
    if not pos then
      Helper.set_cursor(row, 0)
    else
      Helper.set_cursor(row, pos - 1)
    end
  end, { remap = false, buffer = bufnr, nowait = true, desc = 'which_key_ignore' })
  Keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '[', function()
    local byteidx = vim.fn.col('.')
    local sub = string.sub(vim.fn.getline('.'), 1, (byteidx == 1 and 1 or byteidx - 1))
    return sub:match('%S') == nil and '<HOME>' or '^'
  end, { expr = true, remap = false, buffer = bufnr, nowait = true, desc = 'MONTION: move cursor to head of line.' })

  -- 改善 <END> 的功能
  Keymap.register(e_mode.NORMAL, ']', function()
    local line = vim.fn.getline('.')

    if line:match('%S') == nil then
      return 'g$'
    else
      local max = #line
      local _, col = Helper.get_cursor()

      if max == 0 then
        return 'g$'
      elseif col + 1 >= max then
        return 'g$'
      else
        return 'g_'
      end
    end
  end, { expr = true, remap = false, buffer = bufnr, nowait = true, desc = 'MONTION: move cursor to end of line.' })
  Keymap.register(e_mode.INSERT, '<A-]>', '<END>', { remap = false, buffer = bufnr, nowait = true, desc = 'which_key_ignore' })
  Keymap.register(e_mode.VISUAL, ']', function()
    local line = vim.fn.getline('.')
    return line:match('%S') == nil and 'g$' or 'g_'
  end, { expr = true, remap = false, buffer = bufnr, nowait = true, desc = 'which_key_ignore' })

  -- 进入 insert 模式
  Keymap.register(e_mode.VISUAL, 'a', 'A', { remap = false, nowait = true, buffer = bufnr })
  Keymap.register(e_mode.VISUAL, 'A', 'I', { remap = false, nowait = true, buffer = bufnr })
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()

  Events.rg(e_name.BUFFER_ENTER_ONCE, function(state)
    del_buffer_keymaps(state.buf)
    set_buffer_keymaps(state.buf)
  end)
end

return M

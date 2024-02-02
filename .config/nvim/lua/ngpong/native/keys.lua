local M = {}

local keymap = require('ngpong.common.keybinder')
local events = require('ngpong.common.events')
local ui     = require('ngpong.common.ui')
local icons  = require('ngpong.utils.icon')

local e_mode = keymap.e_mode
local e_events = events.e_name

local del_native_keymaps = function(_)
  -- https://neovim.io/doc/user/repeat.html#complex-repeat
  keymap.unregister(e_mode.NORMAL, 'q')
  keymap.unregister(e_mode.NORMAL, 'Q')

  -- https://neovim.io/doc/user/motion.html#left-right-motions
  keymap.unregister(e_mode.NORMAL, '$')
  keymap.unregister(e_mode.NORMAL, '0')
  keymap.unregister(e_mode.NORMAL, '^')
  keymap.unregister(e_mode.NORMAL, 'h')
  keymap.unregister(e_mode.NORMAL, 'l')
  keymap.unregister(e_mode.NORMAL, '<C-H>')
  keymap.unregister(e_mode.NORMAL, '<SPACE>')
  keymap.unregister(e_mode.NORMAL, 't')
  keymap.unregister(e_mode.NORMAL, 'T')
  keymap.unregister(e_mode.NORMAL, ';')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<A-LEFT>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<A-RIGHT>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<RIGHT>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<LEFT>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<C-S-RIGHT>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<C-S-LEFT>')

  -- https://neovim.io/doc/user/motion.html#up-down-motions
  keymap.unregister(e_mode.NORMAL, 'j')
  keymap.unregister(e_mode.NORMAL, 'k')
  keymap.unregister(e_mode.NORMAL, '<C-P>')
  keymap.unregister(e_mode.NORMAL, '+')
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, '<C-m>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT, e_mode.VISUAL }, '<C-J>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT, e_mode.VISUAL }, '<C-UP>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT, e_mode.VISUAL }, '<A-UP>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT, e_mode.VISUAL }, '<C-DOWN>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT, e_mode.VISUAL }, '<A-DOWN>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT, e_mode.VISUAL }, '<UP>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT, e_mode.VISUAL }, '<DOWN>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT, e_mode.VISUAL }, '<C-S-UP>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT, e_mode.VISUAL }, '<C-S-DOWN>')

  -- https://neovim.io/doc/user/motion.html#word-motions
  keymap.unregister(e_mode.NORMAL, 'w')
  keymap.unregister(e_mode.NORMAL, 'W')
  keymap.unregister(e_mode.NORMAL, 'E')
  keymap.unregister(e_mode.NORMAL, 'b')
  keymap.unregister(e_mode.NORMAL, 'B')
  keymap.unregister(e_mode.NORMAL, 'e')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<S-RIGHT>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<S-LEFT>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<C-RIGHT>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<C-LEFT>')

  -- https://neovim.io/doc/user/insert.html#inserting
  keymap.unregister({ e_mode.VISUAL, e_mode.NORMAL }, 'I')
  keymap.unregister({ e_mode.VISUAL, e_mode.NORMAL }, 'A')
  keymap.unregister({ e_mode.VISUAL, e_mode.NORMAL }, 'O')
  keymap.unregister({ e_mode.VISUAL, e_mode.NORMAL }, 'o')
  keymap.unregister(e_mode.NORMAL, 'a')
  keymap.unregister({ e_mode.VISUAL, e_mode.NORMAL }, 'i')

  -- https://neovim.io/doc/user/scroll.html#scroll-down
  keymap.unregister(e_mode.NORMAL, '<C-e>')
  keymap.unregister(e_mode.NORMAL, '<C-d>')
  keymap.unregister(e_mode.NORMAL, '<C-f>')

  -- https://neovim.io/doc/user/scroll.html#scroll-up
  keymap.unregister(e_mode.NORMAL, '<C-y>')
  keymap.unregister(e_mode.NORMAL, '<C-u>')
  --keymap.unregister(e_mode.NORMAL, '<C-b>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<S-UP>')
  keymap.unregister({ e_mode.NORMAL, e_mode.INSERT }, '<S-DOWN>')

  -- https://neovim.io/doc/user/change.html#deleting
  keymap.unregister(e_mode.VISUAL, '<C-H>')
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'x')
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'X')
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'd')
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'D')
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'J')

  -- https://neovim.io/doc/user/change.html#delete-insert
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'c')
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'C')
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 's')
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'S')
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'R')
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'r')

  -- https://neovim.io/doc/user/motion.html#object-select
  keymap.unregister(e_mode.NORMAL, '(')
  keymap.unregister(e_mode.NORMAL, ')')
  keymap.unregister(e_mode.NORMAL, '{')
  keymap.unregister(e_mode.NORMAL, '}')
  keymap.unregister(e_mode.NORMAL, ']]')
  keymap.unregister(e_mode.NORMAL, '[[')
  keymap.unregister(e_mode.NORMAL, '[]')
  keymap.unregister(e_mode.NORMAL, '][')
  keymap.unregister(e_mode.VISUAL, 'ip')
  keymap.unregister(e_mode.VISUAL, 'i\'')
  keymap.unregister(e_mode.VISUAL, 'a\'')
  keymap.unregister(e_mode.VISUAL, 'ap')

  -- https://neovim.io/doc/user/cmdline.html#cmdline-editing
  keymap.unregister(e_mode.COMMAND, '<C-K>')
  keymap.unregister(e_mode.COMMAND, '<C-J>')
  keymap.unregister(e_mode.COMMAND, '<C-H>')
  keymap.unregister(e_mode.NORMAL, ':')

  -- https://neovim.io/doc/user/cmdline.html#cmdline-completion
  keymap.unregister(e_mode.COMMAND, '<C-L>')

  -- https://neovim.io/doc/user/motion.html#mark-motions
  keymap.unregister(e_mode.NORMAL, '\'')
  keymap.unregister(e_mode.NORMAL, 'm')
  keymap.unregister(e_mode.NORMAL, '`')

  -- https://neovim.io/doc/user/insert.html#ins-completion
  keymap.unregister(e_mode.INSERT, '<C-X>')
  keymap.unregister(e_mode.INSERT, '<C-P>')

  -- https://neovim.io/doc/user/windows.html
  keymap.unregister(e_mode.NORMAL, '<C-w>')

  -- https://neovim.io/doc/user/tagsrch.html#tag-stack
  keymap.unregister(e_mode.NORMAL, '<C-t>')

  -- https://neovim.io/doc/user/various.html#various-cmds
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'K')
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, '<C-L>')

  -- https://neovim.io/doc/user/motion.html#jump-motions
  keymap.unregister(e_mode.NORMAL, '<C-o>')
  keymap.unregister(e_mode.NORMAL, '<C-i>')

  -- https://neovim.io/doc/user/insert.html#ins-special-special
  keymap.unregister(e_mode.INSERT, '<C-G>')
  keymap.unregister(e_mode.INSERT, '<C-O>')

  -- https://neovim.io/doc/user/motion.html#various-motions
  keymap.unregister(e_mode.NORMAL, 'H')
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'L')
  keymap.unregister(e_mode.NORMAL, 'M')

  -- https://neovim.io/doc/user/insert.html#ins-special-keys
  keymap.unregister(e_mode.INSERT, '<C-J>')
  keymap.unregister(e_mode.INSERT, '<C-K>')
  keymap.unregister(e_mode.INSERT, '<C-H>')
  keymap.unregister(e_mode.INSERT, '<C-r>')
  keymap.unregister(e_mode.INSERT, '<C-d>')
  keymap.unregister(e_mode.INSERT, '<C-t>')
  keymap.unregister(e_mode.INSERT, '<C-f>')
  keymap.unregister(e_mode.INSERT, '<C-y>')
  keymap.unregister(e_mode.INSERT, '<C-u>')
  keymap.unregister(e_mode.INSERT, '<C-b>')
  keymap.unregister(e_mode.INSERT, '<C-w>')
  keymap.unregister(e_mode.INSERT, '<C-i>')
  keymap.unregister(e_mode.INSERT, '<C-S-i>')
  keymap.unregister(e_mode.INSERT, '<C-[>')
  keymap.unregister(e_mode.INSERT, '<C-{>')
  keymap.unregister(e_mode.INSERT, '<A-[>')
  keymap.unregister(e_mode.INSERT, '<A-]>')

  -- https://neovim.io/doc/user/vimindex.html#%5B
  keymap.unregister(e_mode.NORMAL, '[')
  keymap.unregister(e_mode.NORMAL, ']')

  -- https://neovim.io/doc/user/vimindex.html#g
  keymap.unregister(e_mode.NORMAL, 'g')
  keymap.unregister(e_mode.NORMAL, 'g,')
  keymap.unregister(e_mode.NORMAL, 'g.')
  keymap.unregister(e_mode.NORMAL, 'G')

  -- https://neovim.io/doc/user/visual.html#Select
  keymap.unregister(e_mode.VISUAL, '<C-O>')

  -- https://neovim.io/doc/user/visual.html#visual-change
  keymap.unregister(e_mode.VISUAL, 'O')
  keymap.unregister(e_mode.VISUAL, 'o')

  -- https://neovim.io/doc/user/map.html#%3Amap-alt-keys
  keymap.unregister(e_mode.INSERT, '<A-;>')
  keymap.unregister(e_mode.INSERT, '<A-o>')
  keymap.unregister(e_mode.INSERT, '<A-l>')
  keymap.unregister(e_mode.INSERT, '<A-k>')
  keymap.unregister(e_mode.INSERT, '<A-i>')
  keymap.unregister(e_mode.INSERT, '<A-u>')
  keymap.unregister(e_mode.INSERT, '<A-j>')
  keymap.unregister(e_mode.INSERT, '<A-p>')
  keymap.unregister(e_mode.INSERT, '<A-\'>')
  keymap.unregister(e_mode.INSERT, '<A-Enter>')
  keymap.unregister(e_mode.INSERT, '<A-backspace>')
  keymap.unregister(e_mode.INSERT, '<A-O>')
  keymap.unregister(e_mode.INSERT, '<A-L>')

  -- https://neovim.io/doc/user/change.html#copy-move
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'p')
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'P')
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'y')
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'Y')

  -- https://neovim.io/doc/user/tagsrch.html#tag-commands
  keymap.unregister(e_mode.NORMAL, '<C-]>')

  -- https://neovim.io/doc/user/change.html#complex-change
  keymap.unregister(e_mode.NORMAL, '=')
  keymap.unregister(e_mode.NORMAL, '&')

  -- https://neovim.io/doc/user/pattern.html#search-commands
  keymap.unregister(e_mode.NORMAL, '?')
  keymap.unregister(e_mode.NORMAL, 'n')
  keymap.unregister(e_mode.NORMAL, 'N')

  -- https://neovim.io/doc/user/change.html#shift-left-right
  keymap.unregister(e_mode.NORMAL, '<')
  keymap.unregister(e_mode.NORMAL, '>')

  -- https://neovim.io/doc/user/pi_netrw.html#netrw-gx
  keymap.unregister(e_mode.NORMAL, 'gx')

  -- https://neovim.io/doc/user/undo.html
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'u')
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'U')
  keymap.unregister(e_mode.NORMAL, '<C-r>')

  -- https://neovim.io/doc/user/starting.html#suspend
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, '<C-z>')
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, '<C-S-z>')

  -- https://neovim.io/doc/user/change.html#formatting
  keymap.unregister({ e_mode.NORMAL, e_mode.VISUAL }, 'gq')

  -- 还不知道
  keymap.unregister(e_mode.INSERT, '<C-l>')
  keymap.unregister(e_mode.INSERT, '<C-;>')
  keymap.unregister(e_mode.NORMAL, '<C-\'>')
  keymap.unregister(e_mode.NORMAL, '<C-S-[>')
  keymap.unregister({ e_mode.INSERT, e_mode.NORMAL }, '<C-S-p>')
  keymap.unregister(e_mode.INSERT, '<C-A-p>')
  keymap.unregister(e_mode.INSERT, '<C-A-l>')
  keymap.unregister(e_mode.INSERT, '<A-">')
  keymap.unregister(e_mode.INSERT, '<A-:>')
  keymap.unregister(e_mode.INSERT, '<A-P>')
  keymap.unregister(e_mode.INSERT, '<A-{>')
  keymap.unregister(e_mode.INSERT, '<A-}>')
  keymap.unregister(e_mode.NORMAL, '<C-S-e>')
  keymap.unregister(e_mode.NORMAL, '<C-S-d>')
  keymap.unregister(e_mode.NORMAL, ',')
  keymap.unregister(e_mode.NORMAL, '.')
end

local set_native_keymaps = function()
  keymap.register(e_mode.NORMAL, '<ESC>', HELPER.close_floating_wins, { remap = false, mixture = 'native', desc = 'which_key_ignore' })
  keymap.register(e_mode.INSERT, '<ESC>', '<ESC>', { remap = false, desc = 'which_key_ignore' })

  -- 重新映射 enter 功能
  keymap.register(e_mode.NORMAL, '<CR>', '<C-m>', { remap = false, desc = 'which_key_ignore' })

  -- 进入 insert 模式
  keymap.register(e_mode.NORMAL, 'a', 'a', { remap = false, desc = 'COMMON: enter(tail) inster mode.' })
  keymap.register(e_mode.NORMAL, 'A', 'i', { remap = false, desc = 'COMMON: enter(head) inster mode.' })

  -- 进入 block visual 模式
  keymap.register(e_mode.NORMAL, '<C-v>', '<C-v>', { remap = false, desc = 'COMMON: enter blockwise-visual mode.' })

  -- Left-Right-Up-Down montions
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'l', 'h', { remap = false, desc = 'MONTION: left.' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '\'', 'l', { remap = false, desc = 'MONTION: right.' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'p', 'k', { remap = false, desc = 'MONTION: top.' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, ';', 'j', { remap = false, desc = 'MONTION: down.' })
  keymap.register(e_mode.INSERT, '<A-l>', '<LEFT>', { remap = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.INSERT, '<A-\'>', '<RIGHT>', { remap = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.INSERT, '<A-p>', '<UP>', { remap = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.INSERT, '<A-;>', '<DOWN>', { remap = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, '<S-p>', '<C-y>', { remap = false, desc = 'MONTION: keep cursor and scroll window upwards.' })
  keymap.register(e_mode.NORMAL, ':', '<C-e>', { remap = false, desc = 'MONTION: keep cursor and scroll window downwards.' })
  keymap.register(e_mode.VISUAL, '<S-p>', '<C-y>', { remap = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.VISUAL, ':', '<C-e>', { remap = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'L\"', 'zz', { remap = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, '\"L', 'zz', { remap = false, desc = 'which_key_ignore' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<C-p>', '<C-u>', { remap = false, desc = 'MONTION: updown.' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<C-;>', '<C-d>', { remap = false, desc = 'MONTION: backward.' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<C-S-p>', '<C-b>', { remap = false, desc = 'MONTION: pageup' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '<C-:>', '<C-f>', { remap = false, desc = 'MONTION: pagedown' })
  keymap.register(e_mode.INSERT, '<C-p>', '<C-o><C-u>', { remap = false, desc = 'MONTION: updown.' })
  keymap.register(e_mode.INSERT, '<C-;>', '<C-o><C-d>', { remap = false, desc = 'MONTION: backward.' })

  -- jump to
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'eh', function()
    HELPER.presskeys('gg')
    HELPER.add_jumplist()
  end, { remap = false, desc = 'file head.' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'et', function ()
    HELPER.presskeys('G')
    HELPER.add_jumplist()
  end, { remap = false, desc = 'file tail.' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'eg', function ()
    HELPER.presskeys('N50%')
    HELPER.add_jumplist()
  end, { remap = false, desc = 'file center.' })
  keymap.register(e_mode.NORMAL, 'e,', '<C-O>', { remap = false, desc = 'older entry.' })
  keymap.register(e_mode.NORMAL, 'e.', '<C-I>', { remap = false, desc = 'next entry.' })

  -- windows
  keymap.register(e_mode.NORMAL, 'rv', '<CMD>vsp<CR>', { desc = 'split window vertically.' })
  keymap.register(e_mode.NORMAL, 'rh', '<CMD>sp<CR>', { desc = 'split window horizontally.' })
  keymap.register(e_mode.NORMAL, 'rc', '<CMD>wincmd c<CR>', { remap = false, desc = 'close current window.' })
  keymap.register(e_mode.NORMAL, 'ro', '<CMD>wincmd o<CR>', { remap = false, desc = 'close all window except current.' })
  keymap.register(e_mode.NORMAL, 'rsv', function()
    M.split_resize_mode = 'v'
  end, { desc = 'set vertically split resize mode.' })
  keymap.register(e_mode.NORMAL, 'rsh', function()
    M.split_resize_mode = 'h'
  end, { desc = 'set horizontally split resize mode.' })
  keymap.register(e_mode.NORMAL, 'r=', function()
    local mode = M.split_resize_mode or 'v'
    if mode == 'v' then
      vim.cmd('vertical resize +5')
    elseif mode == 'h' then
      vim.cmd('horizontal resize +5')
    end
  end, { desc = 'window (vertical/horizontal) resize +5.' })
  keymap.register(e_mode.NORMAL, 'r-', function()
    local mode = M.split_resize_mode or 'v'
    if mode == 'v' then
      vim.cmd('vertical resize -5')
    elseif mode == 'h' then
      vim.cmd('horizontal resize -5')
    end
  end, { desc = 'window (vertical/horizontal) resize -5.' })
  keymap.register(e_mode.NORMAL, 'rp', '<CMD>wincmd k<CR>', { remap = false, desc = 'move cursor to top window.' })
  keymap.register(e_mode.NORMAL, 'r;', '<CMD>wincmd j<CR>', { remap = false, desc = 'move cursor to down window.' })
  keymap.register(e_mode.NORMAL, 'rl', '<CMD>wincmd h<CR>', { remap = false, desc = 'move cursor to left window.' })
  keymap.register(e_mode.NORMAL, 'r\'', '<CMD>wincmd l<CR>', { remap = false, desc = 'move cursor to right window.' })

  -- windows(tabline)
  keymap.register(e_mode.NORMAL, 'ts', '<CMD>tab split<CR>', { desc = 'create a new tabpage.' })
  keymap.register(e_mode.NORMAL, 'tc', '<CMD>tabclose<CR>', { desc = 'close current tabpage.' })
  keymap.register(e_mode.NORMAL, 't.', '<CMD>tabnext<CR>', { desc = 'switch to next tabpage.' })
  keymap.register(e_mode.NORMAL, 't,', '<CMD>tabprev<CR>', { desc = 'switch to prev tabpage.' })
  keymap.register(e_mode.NORMAL, 'to', '<CMD>tabonly<CR>', { desc = 'close all tabpage except current.' })

  -- cmdline
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '\\', ':', { remap = false, silent = false, desc = 'COMMON: enter command mode.' })
  keymap.register(e_mode.COMMAND, '<A-p>', TOOLS.wrap_f(HELPER.feedkeys, '<UP>'), { remap = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.COMMAND, '<A-;>', TOOLS.wrap_f(HELPER.feedkeys, '<DOWN>'), { remap = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.COMMAND, '<A-l>', TOOLS.wrap_f(HELPER.feedkeys, '<LEFT>'), { remap = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.COMMAND, '<A-\'>', TOOLS.wrap_f(HELPER.feedkeys, '<RIGHT>'), { remap = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.COMMAND, '<A-q>', TOOLS.wrap_f(HELPER.feedkeys, '<C-LEFT>'), { remap = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.COMMAND, '<A-w>', TOOLS.wrap_f(HELPER.feedkeys, '<C-RIGHT>'), { remap = false, desc = 'which_key_ignore' })

  -- search command
  keymap.register(e_mode.NORMAL, '<C-.>', function()
    if vim.fn.getreg('/') == '' then
      return
    end

    local success, _ = pcall(vim.cmd, 'keepjumps normal! n')
    if not success then
      HELPER.notify_warn('Pattern [' .. vim.fn.getreg('/') .. '] not found any matched result.', 'System: pattern')
      HELPER.clear_commandline()
    end
  end, { remap = false, desc = 'SEARCH: jump to next match pattern.' })
  keymap.register(e_mode.NORMAL, '<C-,>', function()
    if vim.fn.getreg('/') == '' then
      return
    end

    local success, _ = pcall(vim.cmd, 'keepjumps normal! N')
    if not success then
      HELPER.notify_warn('Pattern [' .. vim.fn.getreg('/') .. '] not found any matched result.', 'System: pattern')
      HELPER.clear_commandline()
    end
  end, { remap = false, desc = 'SEARCH: jump to prev match pattern.' })
  keymap.register(e_mode.NORMAL, '?', function()
    HELPER.clear_searchpattern()
    HELPER.clear_commandline()
  end, { remap = false, desc = 'SEARCH: quit search pattern mode.' })

  -- 文本撤销/反撤销
  keymap.register(e_mode.NORMAL, 'z', 'u', { remap = false, desc = 'TEXT: undo text.' })
  keymap.register(e_mode.NORMAL, 'Z', '<C-r>', { remap = false, desc = 'TEXT: redo text.' })

  -- 文本复制与粘贴
  keymap.register(e_mode.NORMAL, 'y', 'yl', { remap = false, desc = 'TEXT: copy text.' })
  keymap.register(e_mode.VISUAL, 'y', 'y', { remap = false, desc = 'TEXT: copy text.' })
  keymap.register(e_mode.NORMAL, 'u', 'p', { remap = false, desc = 'TEXT: paste(tail) text before.' })
  keymap.register(e_mode.NORMAL, 'U', 'p', { remap = false, desc = 'TEXT: paste(head) text.' })
  keymap.register(e_mode.VISUAL, 'u', 'P', { remap = false, desc = 'which_key_ignore' })

  -- 文本剪切
  keymap.register(e_mode.VISUAL, 'c', 'c', { remap = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, 'c', 'xi', { remap = false, desc = 'TEXT: cut character and enter insert mode.' })

  -- 文本删除
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, 'x', '"_x', { remap = false, desc = 'TEXT: delete character.' })
  keymap.register(e_mode.NORMAL, 'X', 'dl', { remap = false, desc = 'TEXT: delete character and copy into clipboard.' })
  keymap.register(e_mode.VISUAL, 'X', 'd', { remap = false, desc = 'which_key_ignore' })

  -- 重新映射一些键在insert模式下的行为
  keymap.register(e_mode.INSERT, '<A-Enter>', '<CR>', { remap = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.INSERT, '<A-backspace>', '<BS>', { remap = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.INSERT, '<TAB>', '<C-I>', { remap = false, desc = 'which_key_ignore' })

  -- 获取文件信息
  keymap.register(e_mode.NORMAL, '<leader>f', ui.popup_fileinfo, { remap = false, desc = 'popup current file state.' })

  -- 大小写转换
  keymap.register(e_mode.NORMAL, '<leader>u', TOOLS.wrap_f(HELPER.feedkeys, 'guiw'), { remap = false, desc = 'convert word under cursor to lowercase.' })
  keymap.register(e_mode.NORMAL, '<leader>U', TOOLS.wrap_f(HELPER.feedkeys, 'gUiw'), { remap = false, desc = 'convert word under cursor to uppercase.' })
  keymap.register(e_mode.VISUAL, '<leader>u', 'u', { remap = false, desc = 'convert selected text to lowercase.' })
  keymap.register(e_mode.VISUAL, '<leader>U', 'U', { remap = false, desc = 'convert selected text to uppercase.' })
end

local del_buffer_keymaps = function(bufnr)
  bufnr = bufnr or true

  keymap.unregister(e_mode.VISUAL, 'a', { buffer = bufnr })
end

local set_buffer_keymaps = function(bufnr)
  bufnr = bufnr or true

  -- 改善 <HOME> 的功能
  keymap.register(e_mode.INSERT, '<A-[>', function()
    local byteidx = vim.fn.col('.')
    local sub = string.sub(vim.fn.getline('.'), 1, (byteidx == 1 and 1 or byteidx - 1))
    return sub:match("%S") == nil and '<C-o><HOME>' or '<C-o>^'
  end, { expr = true, remap = false, buffer = bufnr, nowait = true, desc = 'which_key_ignore' })
  keymap.register({ e_mode.NORMAL, e_mode.VISUAL }, '[', function()
    local byteidx = vim.fn.col('.')
    local sub = string.sub(vim.fn.getline('.'), 1, (byteidx == 1 and 1 or byteidx - 1))
    return sub:match("%S") == nil and '<HOME>' or '^'
  end, { expr = true, remap = false, buffer = bufnr, nowait = true, desc = 'MONTION: move cursor to head of line.' })

  -- 改善 <END> 的功能
  keymap.register(e_mode.NORMAL, ']', function()
    local line = vim.fn.getline('.')

    if line:match("%S") == nil then
      return 'g$'
    else
      local max = #line
      local _, col = HELPER.get_cursor()

      if max == 0 then
        return 'g$'
      elseif col + 1 >= max then
        return 'g$'
      else
        return 'g_'
      end
    end
  end , { expr = true, remap = false, buffer = bufnr, nowait = true, desc = 'MONTION: move cursor to end of line.' })
  keymap.register(e_mode.INSERT, '<A-]>', '<END>', { remap = false, buffer = bufnr, nowait = true, desc = 'which_key_ignore' })
  keymap.register(e_mode.VISUAL, ']', function()
    local line = vim.fn.getline('.')
    return line:match("%S") == nil and 'g$' or 'g_'
  end, { expr = true, remap = false, buffer = bufnr, nowait = true, desc = 'which_key_ignore' })

  -- 进入 insert 模式
  keymap.register(e_mode.VISUAL, 'a', 'A', { remap = false, nowait = true, buffer = bufnr })
  keymap.register(e_mode.VISUAL, 'A', 'I', { remap = false, nowait = true, buffer = bufnr })
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()

  events.rg(e_events.BUFFER_ENTER_ONCE, function(state)
    del_buffer_keymaps(state.buf)
    set_buffer_keymaps(state.buf)
  end)
end

return M

local M = {}

M.setup = function()
  -- 设置 <leader>
  vim.g.mapleader = ' '

  -- 全局编码
  vim.go.encoding = "utf-8"
  vim.opt.fileencoding = 'utf-8'

  -- 剪切板设置
  --
  -- NOTE:
  --  1. 当 host 为 win11 的情况下，需要将 win32yank.exe 移动到 c/windows/system32/ 目录下才可用
  --  2. 一个目前所找到的可备用的解决方案为：使用 xclip/xsel/wl-cliboard，并在 host 中开启 xserver
  --  3. 由于 WSLG 已内置了 xserver，网上资料说似乎使用内置的即可，但是实际测试没有效果，这一点有待研究(因为 win32yank 偶尔会有问题)
  --  4. 还有一个官方推荐的方案为粘贴时使用 powershell，但是实际体验下来会卡顿
  --
  -- REF:
  --  1. https://neovim.io/doc/user/usr_09.html#_using-the-keyboard
  --  2. https://github.com/neovim/neovim/issues/19204
  --  3. https://stackoverflow.com/questions/68435130/wsl-clipboard-win32yank-in-init-lua
  --  4. https://neovim.io/doc/user/provider.html#provider-clipboard
  --  5. https://stackoverflow.com/questions/44480829/how-to-copy-to-clipboard-in-vim-of-bash-on-windows
  vim.go.clipboard = 'unnamed,unnamedplus'
  vim.g.clipboard = {
    name = 'win32yank-win11-wsl2',
    copy = {
      ['+'] = '/mnt/c/Windows/system32/win32yank.exe -i --crlf',
      ['*'] = '/mnt/c/Windows/system32/win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = '/mnt/c/Windows/system32/win32yank.exe -o --lf',
      ['*'] = '/mnt/c/Windows/system32/win32yank.exe -o --lf',
    },
    cache_enabled = false,
  }

  -- 字符过长自动换行
  vim.wo.wrap = true -- 当一行的字符过长时，超出行的字符将会被包裹并显示在下一行
  vim.wo.breakindent = true -- 换行时自动对齐上一行的格式(可能会有性能损失)
  vim.wo.breakindentopt = 'sbr' -- 设置换行符
  vim.wo.showbreak = '➥►' -- 设置换行符
  vim.go.display = 'lastline' -- '@@@' 放在最后一列上

  -- 禁用鼠标模式
  vim.go.mouse = ''

  -- 侧边显示行号
  vim.wo.number = true
  vim.opt.relativenumber = true

  -- 使用空格替代 <Tab>
  vim.opt.expandtab = true

  -- 控制 <Tab> 缩进所代表的空格数
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2

  -- 控制 shift 缩进所代表的空格数
  vim.opt.shiftwidth = 2
  vim.go.shiftround = true

  -- 新行自动对齐上一行
  -- https://stackoverflow.com/questions/17838500/whenever-i-type-colon-in-insert-mode-it-moves-my-text-to-the-very-beginning-of-l
  vim.opt.autoindent = true
  vim.cmd('filetype indent off') -- disable cindent and smartindent

  -- 设置 24位 RGB 真彩颜色
  vim.go.termguicolors = true

  -- 允许光标移动到行的末端，即最后没有字符的位置
  vim.go.virtualedit = 'onemore'

  -- 高亮所在行
  vim.wo.cursorline = true

  -- 未保存当前buffer的时候就可以切换到其他buffer
  vim.go.hidden = true

  -- 分割窗口
  vim.go.splitbelow = false
  vim.go.splitright = false
  vim.go.splitkeep = 'screen'

  -- 不创建备份文件
  vim.go.backup = false
  vim.go.writebackup = false

  -- 创建swap文件，开启状态下可能会有性能问题，视情况修改
  vim.opt.swapfile = true
  vim.go.updatecount = 200 -- 当输入多少个字符后会刷新swap文件
  vim.go.updatetime = 4000 -- 当多少毫秒未输入后会刷新swap文件

  -- 改进搜索模式
  --  1. 在输入 pattern 后可以立即开始搜索
  --  2. 在还未输入 <CR> 的情况下可以通过 <C-g>/<C-t> 来过滤搜索内容
  --  3. 当搜索到末尾时会出现报错提示而不是循环搜索
  --  4. 当输入全小写的时候忽略大小写搜索，当存在一个大写的时候则使用全词匹配
  vim.go.incsearch = true
  vim.go.wrapscan = true
  vim.go.ignorecase = false
  vim.go.smartcase = true

  -- 上下滚动时可看到的最小行数
  vim.go.scrolloff = 0

  -- 左右滚动时可看到的最好列数
  vim.go.sidescrolloff = 0

  -- 显示左侧图标指示列
  vim.wo.signcolumn = 'auto:1-2'

  -- 组织状态线
  vim.wo.statuscolumn = '%s %r'

  -- 当文件被外部修改时则自动加载
  vim.go.autoread = true

  -- jumplist behavior
  vim.go.jumpoptions = 'stack'

  -- shada文件存储属性，不存储 buffer list
  vim.opt.shada = vim.opt.shada - 'h'
  vim.opt.shada = vim.opt.shada - '%'
  vim.opt.shada = vim.opt.shada - '/'

  -- 快捷键连击等待时间
  vim.go.timeoutlen = 300

  -- 是否显示不可见字符，对于查看文件中是否有多余字符(tab 或 space)有帮助
  vim.wo.list = false

  -- 不可见字符的表示
  -- vim.o.listchars = "space:·,tab:··"

  -- 禁用内置语法高亮
  -- vim.cmd('syntax off')

  -- 禁用折叠
  vim.wo.foldenable = false

  -- 控制 tabline 显示行为
  -- 0  never
  -- 1  only if there are at least two tab pages
  -- 2  always
  vim.go.showtabline = 2

  -- 禁用原生filetype插件所定义的keymaps
  --
  -- REF: https://neovim.io/doc/user/filetype.html#filetype-plugins
  vim.g.no_plugin_maps = 1

  -- 禁用原生的插件
  --
  -- REF: https://github.com/neovim/neovim/blob/master/runtime/pack/dist/opt/matchit/plugin/matchit.vim
  -- REF: https://www.reddit.com/r/neovim/comments/yckqsn/how_to_disable_netrw_in_favor_of_own_plugin/
  vim.g.loaded_spellfile_plugin = 1
  vim.g.loaded_remote_plugins = 1
  vim.g.loaded_tutor_mode_plugin = 1
  vim.g.loaded_gzip = 1
  vim.g.loaded_tar = 1
  vim.g.loaded_tarPlugin = 1
  vim.g.loaded_zip = 1
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_getscript = 1
  vim.g.loaded_getscriptPlugin = 1
  vim.g.loaded_vimball = 1
  vim.g.loaded_vimballPlugin = 1
  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
  vim.g.loaded_2html_plugin = 1
  vim.g.loaded_logiPat = 1
  vim.g.loaded_rrhelper = 1
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1

  -- 禁用一些无用的 providers
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_perl_provider = 0
end

return M

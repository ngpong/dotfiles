local M = {}

M.setup = function()
  -- 提示信息相关的设置
  -- f  use "(3 of 5)" instead of "(file 3 of 5)"
  -- i  use "[noeol]" instead of "[Incomplete last line]"
  -- l  use "999L, 888B" instead of "999 lines, 888 bytes"
  -- m	use "[+]" instead of "[Modified]"
  -- n	use "[New]" instead of "[New File]"
  -- r	use "[RO]" instead of "[readonly]"
  -- w	use "[w]" instead of "written" for file write message	and "[a]" instead of "appended" for ":w >> file" command
  -- x	use "[dos]" instead of "[dos format]", "[unix]" instead of "[unix format]" and "[mac]" instead of "[macformat]"
  -- a	all of the above abbreviations
  -- o	overwrite message for writing a file with subsequent message for reading a file (useful for ":wn" or when 'autowrite' on)
  -- O	message for reading a file overwrites any previous message; also for quickfix message (e.g., ":cn")
  -- s	don't give "search hit BOTTOM, continuing at TOP" or "search hit TOP, continuing at BOTTOM" messages; when using the search count do not show "W" after the count message (see S below)
  -- t	truncate file message at the start if it is too long to fit on the command-line, "<" will appear in the left most column; ignored in Ex mode
  -- T	truncate other messages in the middle if they are too long to fit on the command line; "..." will appear in the middle; ignored in Ex mode
  -- W	don't give "written" or "[w]" when writing a file
  -- A	don't give the "ATTENTION" message when an existing	swap file is found
  -- I	don't give the intro message when starting Vim, see :intro
  -- c	don't give ins-completion-menu messages; for example, "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found", "Back at original", etc.
  -- C	don't give messages while scanning for ins-completion items, for instance "scanning tags"
  -- q	use "recording" instead of "recording @a"
  -- F	don't give the file info when editing a file, like :silent was used for the command
  -- S	do not show search count message when searching, e.g.	"[1/5]"
  vim.opt.shortmess = nil
  vim.opt.shortmess = vim.opt.shortmess + "S"
  vim.opt.shortmess = vim.opt.shortmess + "o"
  vim.opt.shortmess = vim.opt.shortmess + "O"
  vim.opt.shortmess = vim.opt.shortmess + "s"
  vim.opt.shortmess = vim.opt.shortmess + "c"
  vim.opt.shortmess = vim.opt.shortmess + "F"

  -- 不显示当前的输入模式(左下角)
  vim.go.showmode = false

  -- 不显示当前光标所在行号还有列号(右下角)
  vim.go.ruler = false

  -- 关闭状态行(最后一行)
  vim.go.laststatus = 0

  -- 不显示当前输入的命令(右下角)
  -- 暂时禁用它，不然在移动(从下往上一直按p移动)的时候会有一些鼠标乱飘的bug
  -- vim.go.showcmd = false

  -- 控制命令行的高度(最后一行)
  vim.go.cmdheight = 1
end

return M

local function del_keymaps()
  -- vim.__key.unrg("", "0")  -- 跳转至最后一个字符
  -- vim.__key.unrg("", "^")  -- 跳转至第一个非空白字符
  -- vim.__key.unrg("", "$")  -- 跳转至最后一个字符

  -- vim.__key.unrg("", "g_") -- 类似于 <END>
  -- vim.__key.unrg("", "g0") -- 跳转至第一列
  -- vim.__key.unrg("", "g^") -- 跳转至第一个非空白字符；在 linewrap 下会与 ^ 有区别
  -- vim.__key.unrg("", "g$") -- 跳转至最后一个字符；在 linewrap 下会与 $ 有区别
  -- vim.__key.unrg("", "gm") -- 跳转至行的相较于窗口宽度的中间位置
  -- vim.__key.unrg("", "gM") -- 跳转至行的中间位置
  -- vim.__key.unrg("", "gk") -- 向上移动；在 linewrap 下与 k 有区别
  -- vim.__key.unrg("", "gj") -- 向下移动；在 linewrap 下与 j 有区别
  -- vim.__key.unrg("", "ge") -- 向后到单词的最后一个字符
  -- vim.__key.unrg("", "gE") -- 向后到单词的最后一个字符
  -- vim.__key.unrg("", "go") -- 从起始位置按字节跳转
  -- vim.__key.unrg("", "gp") -- 与 p/P 的行为差不多
  -- vim.__key.unrg("", "gP") -- 与 p/P 的行为差不多
  -- vim.__key.unrg("", "gr") -- replace 相关的，没有必要
  -- vim.__key.unrg("", "gR") -- replace 相关的，没有必要
  -- vim.__key.unrg("", "g~") -- 切换字符的大小写
  -- vim.__key.unrg("", "g?") -- 切换为 ROT13 编码，没啥用
  -- vim.__key.unrg("", "ga") -- 显示当前光标下字符的 ASCII 信息
  -- vim.__key.unrg("", "g8") -- 显示当前光标下字符的字节序列
  -- vim.__key.unrg("", "g<C-g>") -- 显示当前光标下的位置（行、列等）
  -- vim.__key.unrg("", "gf") -- 编辑当前光标下指定的文件名
  -- vim.__key.unrg("", "gF") -- 编辑当前光标下指定的文件名
  -- vim.__key.unrg("", "g<C-h>") -- 进入 select block 模式
  -- vim.__key.unrg("", "g<C-]>") -- tag相关
  -- vim.__key.unrg("", "g&") -- 重复最后一次执行的 :s 命令
  -- vim.__key.unrg("", "g'") -- 跳转 mark（不设置jumplist）
  -- vim.__key.unrg("", "g`") -- 跳转 mark（不设置jumplist）
  -- vim.__key.unrg("", "g+") -- 和 <C-R> 的功能类似
  -- vim.__key.unrg("", "g-") -- 和 u 的功能类似
  -- vim.__key.unrg("", "g<") -- 显示上一个命令的输出
  -- vim.__key.unrg("", "gD") -- 从文件中寻找符号定义并跳转
  -- vim.__key.unrg("", "gH") -- 和 V 功能一致
  -- vim.__key.unrg("", "gt") -- 切换到下一个tabpage
  -- vim.__key.unrg("", "gT") -- 切换到上一个tabpage
  -- vim.__key.unrg("", "gV") -- 不知道有什么用
  -- vim.__key.unrg("", "g]") -- tag相关
  -- vim.__key.unrg("", "gh") -- 类似于 v
  -- vim.__key.unrg("", "gw") -- 格式化文本，与 gq 类似，但是不使用 formatexpr
  -- vim.__key.unrg("", "g<tab>") -- 切换到上一次访问的 tabpage
  -- vim.__key.unrg("", "gs") -- 使neovim睡n秒
  -- vim.__key.unrg("n", "gQ") -- 切换到 Ex 模式
  vim.__key.unrg("", "g")
  vim.__key.del("", "gri") -- vim.lsp.buf.implementation
  vim.__key.del("", "grr") -- vim.lsp.buf.references
  vim.__key.del("", "gra") -- vim.lsp.buf.code_action
  vim.__key.del("", "grn") -- vim.lsp.buf.rename
  vim.__key.del("", "gO") -- vim.lsp.buf.document_symbol
  vim.__key.del("", "gx") -- netrw
  vim.__key.del("", "gc") -- comment
  vim.__key.del("", "gcc") -- comment

  -- https://neovim.io/doc/user/quickref.html#Q_sc
  --  vim.__key.unrg({ "n", "v" }, "z-") -- 与 zb 一致
  --  vim.__key.unrg({ "n", "v" }, "z.") -- 与 zz 一致
  --  -- https://neovim.io/doc/user/quickref.html#Q_wq
  --  vim.__key.unrg("n", "ZZ") -- 与 :x 类似
  --  vim.__key.unrg("n", "ZQ") -- 与 :q! 类似
  --  vim.__key.unrg("n", "<C-z>") -- 退出neovim
  --  -- https://neovim.io/doc/user/vimindex.html#_2.5-commands-starting-with-'z'
  --  vim.__key.unrg({ "n", "v" }, "z+") -- 与 zt 类似，但是我们能够指定具体行号并跳转
  --  vim.__key.unrg({ "n", "v" }, "z<CR>") -- 与 zt 一致
  --  vim.__key.unrg({ "n", "v" }, "z=") -- 打开拼写建议
  --  vim.__key.unrg({ "n", "v" }, "zF") -- 与 zf 类似
  --  vim.__key.unrg("n", "zG") -- 拼写建议相关
  --  vim.__key.unrg("n", "zg") -- 拼写建议相关
  --  vim.__key.unrg({ "n", "v" }, "z^") -- 与 zb 类似，但是我们能够指定具体行号并跳转
  --  vim.__key.unrg({ "n", "v" }, "zp") -- 与粘贴有关，还不清楚具体作用
  --  vim.__key.unrg({ "n", "v" }, "zP") -- 与粘贴有关，还不清楚具体作用
  --  vim.__key.unrg("n", "zw") -- 拼写建议相关
  --  vim.__key.unrg({ "n", "v" }, "zy") -- 与复制有关，还不清楚具体作用
  --  vim.__key.unrg("n", "zW") -- 拼写建议相关
  --  vim.__key.unrg("n", "zu") -- 拼写建议相关
  --  vim.__key.unrg("n", "zr") -- fold相关
  --  vim.__key.unrg("n", "zX") -- fold相关
  --  vim.__key.unrg("n", "zj") -- fold相关
  --  vim.__key.unrg("n", "zk") -- fold相关
  --  vim.__key.unrg({ "n", "v" }, "zH")
  --  vim.__key.unrg({ "n", "v" }, "zL")
  vim.__key.unrg("", "z")
  vim.__key.unrg("", "Z")

  -- https://neovim.io/doc/user/quickref.html#Q_wi
  vim.__key.unrg("", "<C-w>")

  -- https://neovim.io/doc/user/quickref.html#Q_ud
  vim.__key.unrg("", "_")
  vim.__key.unrg("", "-")  -- 向上移动；如果有则至第一个非空字符
  vim.__key.unrg("", "+")  -- 向下移动；如果有则至第一个非空字符
  vim.__key.unrg("", "=") -- 和对齐有关的，无用
  vim.__key.unrg("", "!") -- 无用

  -- https://neovim.io/doc/user/quickref.html#Q_pa
  -- vim.__key.unrg("", "/")
  -- vim.__key.unrg("", "?")
  -- vim.__key.unrg("", "*")  -- 搜索当前光标下的单词
  -- vim.__key.unrg("", "#")  -- 搜索当前光标下的单词
  -- vim.__key.unrg("", "g*") -- 搜索当前光标下的单词
  -- vim.__key.unrg("", "g#") -- 搜下并跳转至当前光标下单词的下一个匹配（不使用 \< \>）

  -- https://neovim.io/doc/user/quickref.html#Q_ma
  vim.__key.unrg("", "m") -- 设置 mark
  vim.__key.unrg("", "'") -- 跳转 mark
  vim.__key.unrg("", "`") -- 跳转 mark

  -- https://neovim.io/doc/user/quickref.html#Q_ta
  vim.__key.unrg("", "<C-]>")  -- tag 相关
  vim.__key.unrg({ "", "i" }, "<C-t>")  -- tag 相关

  -- https://neovim.io/doc/user/quickref.html#Q_ss
  vim.__key.unrg("i", "<C-a>") -- 插入上一次插入的字符；效果有点奇怪
  vim.__key.unrg("i", "<C-@>") -- 插入上一次插入的字符并返回 normal mode；效果有点奇怪
  -- vim.__key.unrg("i", "<C-x>") -- 和内置完成列表相关的，但是没啥用

  -- https://neovim.io/doc/user/quickref.html#Q_ch
  -- vim.__key.unrg("", "r") -- replace 相关的，没有必要
  -- vim.__key.unrg("", "R") -- replace 相关的，没有必要
  vim.__key.unrg("", "S") -- 和 c 类似的键
  -- vim.__key.unrg({ "n", "v" }, "s") -- 和 c 类似的键
  vim.__key.unrg("", "~") -- 切换字符的大小写

  -- https://neovim.io/doc/user/quickref.html#Q_vc
  vim.__key.unrg("", "<C-g>") -- 显示当前文件名

  -- https://neovim.io/doc/user/quickref.html#Q_ce
  vim.__key.unrg("c", "<C-v>") -- 用于输入特殊字符的
  vim.__key.unrg("c", "<C-d>") -- 展示光标前面单词能够匹配的所有列表
  vim.__key.unrg("c", "<C-a>") -- 完成一个单词

  -- https://neovim.io/doc/user/quickref.html#Q_ed
  vim.__key.unrg("", "<C-^>")

  -- https://neovim.io/doc/user/vimindex.html#_2.3-square-bracket-commands
  vim.__key.unrg("", "[P") -- 与 P 类似
  vim.__key.unrg("", "[p") -- 与 p 类似
  vim.__key.unrg("", "]P") -- 与 P 类似
  vim.__key.unrg("", "]p") -- 与 p 类似
  vim.__key.unrg("", "[*") -- 跳转至前一个 *
  vim.__key.unrg("", "]*") -- 跳转至下一个 *
  vim.__key.unrg("", "[/") -- 跳转至前一个 C 备注 /* */
  vim.__key.unrg("", "]/") -- 跳转至下一个 C 备注 /* */
  vim.__key.unrg("", "[I") -- 输出当前光标下单词在当前文件中所有匹配的列表
  vim.__key.unrg("", "]I") -- 输出当前光标下单词在当前文件中所有匹配的列表
  vim.__key.unrg("", "]D") -- 与 diagnostic 相关，这里采用 ]d 应该就够了
  vim.__key.unrg("", "[c") -- 不太清楚作用
  vim.__key.unrg("", "]c") -- 不太清楚作用
  vim.__key.unrg("", "[f") -- 与 gf 一致
  vim.__key.unrg("", "[i") -- 显示当前光标下的单词在文件中第一个找到的匹配项
  vim.__key.unrg("", "[s") -- 拼写相关
  vim.__key.unrg("", "]s") -- 拼写相关
  vim.__key.unrg("", "['") -- 跳转至前一个小写 mark
  vim.__key.unrg("", "]'") -- 跳转至下一个小写 mark
  vim.__key.unrg("", "[`") -- 跳转至前一个小写 mark
  vim.__key.unrg("", "]`") -- 跳转至前一个小写 mark
  vim.__key.unrg("", "]f") -- 类似于 gf 的功能
  vim.__key.unrg("", "]i") -- 查找光标下字符的功能，没啥用
  vim.__key.unrg("", "[<C-d>") -- tag相关
  vim.__key.unrg("", "[<C-i>") -- tag相关
  vim.__key.unrg("", "]<C-d>") -- tag相关
  vim.__key.unrg("", "]<C-i>") -- tag相关
  vim.__key.unrg("", "[*") -- 跳转到注释 /* */ 的起始
  vim.__key.unrg("", "]*") -- 跳转到注释 /* */ 的结尾
  vim.__key.unrg("", "[#") -- 跳转到 c/c++ 宏相关
  vim.__key.unrg("", "]#") -- 跳转到 c/c++ 宏相关
  vim.__key.unrg("", "[]") -- 跳转到前一个函数的起始 } 位置；vim的默认行为要求 } 必须独占一列
  vim.__key.unrg("", "][") -- 跳转到后一个函数的起始 } 位置；vim的默认行为要求 } 必须独占一列
  -- vim.__key.unrg("", "[m") -- 跳转到成员函数的开头；要求必须拥有类似 java 的语言结构；与 { 所绑定
  vim.__key.unrg("", "]M") -- 跳转到成员函数的结尾；要求必须拥有类似 java 的语言结构；与 { 所绑定
  -- vim.__key.unrg("", "]m") -- 与 [m 功能类似
  vim.__key.unrg("", "]M") -- 与 [M 功能类似

  -- misc
  -- vim.__key.unrg({ "", "c" }, "<C-h>")
  -- vim.__key.unrg({ "", "c" }, "<C-j>")
  -- vim.__key.unrg({ "", "c" }, "<C-k>")
  -- vim.__key.unrg({ "", "c" }, "<C-l>")
  -- vim.__key.unrg("v", "R")
  vim.__key.unrg("n", "F")
  vim.__key.unrg("", "t")
  vim.__key.unrg("", "T")
  vim.__key.unrg({ "", "c" }, "<C-y>")
  vim.__key.unrg({ "", "c" }, "<C-e>")
  vim.__key.unrg({ "n", "c" }, "<C-r>")
  vim.__key.unrg({ "n", "v" }, ";")
  vim.__key.unrg({ "n", "v" }, ",")
  vim.__key.unrg("v", "u")
  vim.__key.unrg("v", "U")
  vim.__key.unrg("", "|")
  vim.__key.unrg({ "n", "v" }, "?")
  vim.__key.unrg({ "n", "v" }, "<C-a>")
  -- vim.__key.unrg({ "n", "v" }, "<C-x>")
  vim.__key.unrg({ "", "i" }, "<C-c>")
  vim.__key.unrg({ "", "c", "t" }, "<C-q>")
  vim.__key.unrg("i", "<C-y>")
  vim.__key.unrg("i", "<C-e>")
  vim.__key.unrg("i", "<C-d>")
  vim.__key.unrg({ "i", "c" }, "<C-u>")
  vim.__key.unrg({ "n", "v" }, "<C-f>")
  vim.__key.unrg({ "n", "v" }, "<C-b>")
  vim.__key.unrg({ "n", "v" }, "<C-S-B>")
  vim.__key.unrg({ "n", "v" }, "<C-S-F>")
  vim.__key.unrg("", "M")
  -- vim.__key.unrg("i", "<C-i>")
  vim.__key.del("i", "<C-s>")
  vim.__key.del("", "[q")
  vim.__key.del("", "]q")
  vim.__key.del("", "<C-s>")
  vim.__key.del("n", "<C-w>d")
  vim.__key.del("n", "<C-w><C-d>")
end

local set_keymaps = function()
  vim.__key.rg("n", "<leader>?", function()
    vim.cmd("Cheatsheet")
  end)

  -- 补充一些使用 q 关闭的情况
  vim.__autocmd.on(
    "FileType",
    vim.schedule_wrap(function(state)
      vim.__key.rg("n", "q", function()
        vim.__win.close(0)
        vim.__buf.wipeout(state.buf)
      end, { buffer = state.buf, silent = true })
    end),
    { pattern = { "help", "qf", "query", "checkhealth" } }
  )
  vim.__key.rg("n", "q", function()
    if vim.__win.close_diff() then
      return ""
    end
    return "q"
  end, { expr = true })

  vim.__key.rg("n", "<C-e>", vim.schedule_wrap(function()
    local wininfos = {}
    for _, winid in ipairs(vim.__win.all()) do
      table.insert(wininfos, vim.__win.info(winid)[1])
    end

    vim.__autocmd.exec("User", { pattern = "UserPress_CTRLE", data = { wininfos = wininfos } })
  end))
  vim.__key.rg("n", "<C-y>", vim.schedule_wrap(function()
    local wininfos = {}
    for _, winid in ipairs(vim.__win.all()) do
      table.insert(wininfos, vim.__win.info(winid)[1])
    end

    vim.__autocmd.exec("User", { pattern = "UserPress_CTRLY", data = { wininfos = wininfos } })
  end))
  vim.__key.rg("n", "<C-c>", vim.schedule_wrap(function()
    local wininfos = {}
    for _, winid in ipairs(vim.__win.all()) do
      table.insert(wininfos, vim.__win.info(winid)[1])
    end

    vim.__autocmd.exec("User", { pattern = "UserPress_CTRLC", data = { wininfos = wininfos } })
  end))

  -- 防止一些键盘误触的映射
  vim.__key.rg("i", "<C-SPACE>", "<SPACE>")

  -- movement
  vim.__key.rg({ "n", "v" }, "j", function() return vim.v.count > 1 and "m'" .. vim.v.count .. "j" or "j" end, { expr = true })
  vim.__key.rg({ "n", "v" }, "k", function() return vim.v.count > 1 and "m'" .. vim.v.count .. "k" or "k" end, { expr = true })
  vim.__key.rg({ "i", "c" }, "<C-h>", "<left>", { remap = true })
  vim.__key.rg({ "i", "c" }, "<C-j>", "<down>", { remap = true })
  vim.__key.rg({ "i", "c" }, "<C-k>", "<up>", { remap = true })
  vim.__key.rg({ "i", "c" }, "<C-l>", "<right>", { remap = true })
  vim.__key.rg({ "n", "c", "i" }, "<C-S-H>", "<C-LEFT>")
  vim.__key.rg({ "n", "c", "i" }, "<C-S-L>", "<C-RIGHT>")

  vim.__key.rg("", "gp", "%")
  vim.__key.rg("", "ge", "G")
  vim.__key.rg("", "gg", "gg")
  vim.__key.rg("", "gt", "H")
  vim.__key.rg("", "gc", "M")
  vim.__key.rg("", "gb", "L")
  vim.__key.rg("", "gv", function() return "m'gv" end, { expr = true })

  -- vim.__key.rg("", "gj", "j")
  -- vim.__key.rg("", "gk", "k")
  vim.__key.rg("", "<C-f>", "$")
  vim.__key.rg("i", "<C-f>", "<C-o>$")
  vim.__key.rg("c", "<C-f>", "<END>")
  vim.__key.rg("", "<C-S-F>", "g_")
  vim.__key.rg("i", "<C-S-F>", "<C-o>g_<RIGHT>")
  vim.__key.rg("", "<C-s>", "0")
  vim.__key.rg("i", "<C-s>", "<C-o>^")
  vim.__key.rg("c", "<C-s>", "<HOME>")
  vim.__key.rg("", "<C-S-S>", "^")
  vim.__key.rg("i", "<C-S-S>", "<C-o>0")

  do
    local function f(key, msg)
      return function()
        local bufnr = vim.__buf.current()

        local ft = vim.__buf.filetype(bufnr)
        if vim.__filter.contain_fts(ft) then
          return
        end

        local bt = vim.__buf.buftype(bufnr)
        if vim.__filter.contain_bts(bt) then
          return
        end

        local ok, ret = pcall(vim.cmd, "norm! " .. key)
        if not ok then
          ret = ret:match("([^:]+)$")
          ret = ret and ret:sub(2)
          ret = msg or ret
          ret = ret and vim.__echo.err(ret)
        end
      end
    end
    vim.__key.rg("", "g.", f("`.", "changelist is empty"))
    vim.__key.rg("n", "[.", f("m'g;"))
    vim.__key.rg("n", "].", f("m'g,"))
  end

  -- screen
  vim.__key.rg("", "H", "zh")
  vim.__key.rg("", "J", "<C-e>")
  vim.__key.rg("", "K", "<C-y>")
  vim.__key.rg("", "L", "zl")
  vim.__key.rg("", "zh", "zH")
  vim.__key.rg("", "zl", "zL")
  vim.__key.rg("", "zk", "zb")
  vim.__key.rg("", "zj", "zt")
  vim.__key.rg("", "zz", "zz")
  vim.__key.rg("", "ze", "ze")
  vim.__key.rg("", "zs", "zs")

  -- edit
  vim.__key.rg("n", "A", "g_a")
  vim.__key.rg("n", "gA", "A")
  vim.__key.rg("n", "gI", "gI")
  vim.__key.rg({ "n", "v" }, "f<C-a>", "<C-a>")
  vim.__key.rg({ "n", "v" }, "f<C-x>", "<C-x>")
  vim.__key.rg({ "n", "v" }, "fq", "gq")
  vim.__key.rg({ "n", "v" }, "fj", "J")
  vim.__key.rg({ "n", "v" }, "fJ", "gJ")
  vim.__key.rg({ "n", "v" }, "fu", "gu")
  vim.__key.rg({ "n", "v" }, "fU", "gU")

  -- windows
  do
    local function filter_wrap(f)
      return function()
        local winid = vim.__win.current()
        if vim.__win.is_diff(winid) then
          return
        end
        if vim.__win.is_float(winid) then
          return
        end

        if vim.__filter.contain_fts() then
          return
        end

        f()
      end
    end

    local function close_win()
      if vim.bo.modified then
        local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
        if choice == 0 or choice >= 2 then
          return
        end

        if choice == 1 then -- Yes
          vim.cmd.write()
        end
      end

      local curbuf = vim.__buf.current()

      local matchs = {}
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        local bufinfo = vim.fn.getbufinfo(bufnr)[1]

        if bufinfo and
          bufinfo.loaded == 1 and
          bufinfo.listed == 1 and
          bufinfo.hidden == 0 and
          #bufinfo.windows == 1 and
          vim.__win.is_valid(bufinfo.windows[1])
          then
          matchs[#matchs+1] = bufnr
        end
      end

      if #matchs == 1 and matchs[1] == curbuf then
        return vim.__echo.err("Cannot close last window")
      end

      vim.__win.close()
    end
    vim.__key.rg("n", "<C-w>c", filter_wrap(close_win))
    vim.__key.rg("n", "<C-w><C-c>", filter_wrap(close_win))

    local function close_all_win()
      vim.ui.input({ prompt = "Delete all windows except current, y/N: ", }, function(ip)
        if not ip or string.lower(ip) ~= "y" then
          return
        end


        local current = vim.__win.current()

        for _, winid in ipairs(vim.__win.all()) do
          if current ~= winid then
            local bufnr = vim.__buf.number(winid)

            if vim.bo[bufnr].modified then
              local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.__buf.name(bufnr)), "&Yes\n&No\n&Cancel")
              if choice == 1 then -- Yes
                vim.api.nvim_buf_call(bufnr, function() vim.cmd.write() end)
                vim.__win.close(winid)
              end
            else
              vim.__win.close(winid)
            end
          end
        end
      end)
    end
    vim.__key.rg("n", "<C-w>o", filter_wrap(close_all_win))
    vim.__key.rg("n", "<C-w><C-o>", filter_wrap(close_all_win))

    vim.__key.rg("n", "<C-w>s", filter_wrap(function() vim.__key.feed("<C-w>s") end))
    vim.__key.rg("n", "<C-w><C-s>", filter_wrap(function() vim.__key.feed("<C-w>s") end))

    vim.__key.rg("n", "<C-w>v", filter_wrap(function() vim.__key.feed("<C-w>v") end))
    vim.__key.rg("n", "<C-w><C-v>", filter_wrap(function() vim.__key.feed("<C-w>v") end))

    vim.__key.rg("n", "<C-w>z", filter_wrap(function() vim.__key.feed("<C-w>=") end))
    vim.__key.rg("n", "<C-w><C-z>", filter_wrap(function() vim.__key.feed("<C-w>=") end))

    vim.__key.rg("n", "<C-w>t", filter_wrap(function() vim.__key.feed("<C-w>|<C-w>_") end))
    vim.__key.rg("n", "<C-w><C-t>", filter_wrap(function() vim.__key.feed("<C-w>|<C-w>_") end))

    vim.__key.rg("n", "<C-w><LEFT>", filter_wrap(function() vim.__key.feed("<C-w>H") end))
    vim.__key.rg("n", "<C-w><C-LEFT>", filter_wrap(function() vim.__key.feed("<C-w>H") end))

    vim.__key.rg("n", "<C-w><DOWN>", filter_wrap(function() vim.__key.feed("<C-w>J") end))
    vim.__key.rg("n", "<C-w><C-DOWN>", filter_wrap(function() vim.__key.feed("<C-w>J") end))

    vim.__key.rg("n", "<C-w><UP>", filter_wrap(function() vim.__key.feed("<C-w>K") end))
    vim.__key.rg("n", "<C-w><C-UP>", filter_wrap(function() vim.__key.feed("<C-w>K") end))

    vim.__key.rg("n", "<C-w><RIGHT>", filter_wrap(function() vim.__key.feed("<C-w>L") end))
    vim.__key.rg("n", "<C-w><C-RIGHT>", filter_wrap(function() vim.__key.feed("<C-w>L") end))

    vim.__key.rg("n", "<C-h>", "<C-w>h")
    vim.__key.rg("n", "<C-w>h", "<C-w>h")
    vim.__key.rg("n", "<C-w><C-h>", "<C-w>h")

    vim.__key.rg("n", "<C-j>", "<C-w>j")
    vim.__key.rg("n", "<C-w>j", "<C-w>j")
    vim.__key.rg("n", "<C-w><C-j>", "<C-w>j")

    vim.__key.rg("n", "<C-k>", "<C-w>k")
    vim.__key.rg("n", "<C-w>k", "<C-w>k")
    vim.__key.rg("n", "<C-w><C-k>", "<C-w>k")

    vim.__key.rg("n", "<C-l>", "<C-w>l")
    vim.__key.rg("n", "<C-w>l", "<C-w>l")
    vim.__key.rg("n", "<C-w><C-l>", "<C-w>l")

    vim.__key.rg("n", "-", vim.__util.wrap_f(vim.__win.resize_op, "vertical resize -"))
    vim.__key.rg("n", "=", vim.__util.wrap_f(vim.__win.resize_op, "vertical resize +"))
    vim.__key.rg("n", "+", vim.__util.wrap_f(vim.__win.resize_op, "horizontal resize +"))
    vim.__key.rg("n", "_", vim.__util.wrap_f(vim.__win.resize_op, "horizontal resize -"))
  end

  -- undo redo
  vim.__key.rg({ "n", "v" }, "U", "<C-r>")

  -- tabpage
  -- do
  --   local function f(key)
  --     return function()
  --       local winid = vim.__win.current()
  --       if vim.__win.is_diff(winid) then
  --         return
  --       end
  --       if vim.__win.is_float(winid) then
  --         return
  --       end
  --
  --       if vim.__filter.contain_fts() then
  --         return
  --       end
  --
  --       vim.__key.feed(key)
  --     end
  --   end
  --
  --   vim.__key.rg({ "n", "v" }, "<C-t>n", f("<CMD>tabnext<CR>"))
  --   vim.__key.rg({ "n", "v" }, "<C-t>p", f("<CMD>tabprev<CR>"))
  --   vim.__key.rg({ "n", "v" }, "<C-t>t", f("<CMD>tab split<CR>"))
  --   vim.__key.rg({ "n", "v" }, "<C-t><C-t>", f("<CMD>tab split<CR>"))
  --   vim.__key.rg({ "n", "v" }, "<C-t>n", f("<CMD>tab split<CR>"))
  --   vim.__key.rg({ "n", "v" }, "<C-t><C-n>", f("<CMD>tab split<CR>"))
  --   vim.__key.rg({ "n", "v" }, "<C-t>c", f("<CMD>tabclose<CR>"))
  --   vim.__key.rg({ "n", "v" }, "<C-t><C-c>", f("<CMD>tabclose<CR>"))
  --   vim.__key.rg({ "n", "v" }, "<C-t>o", f("<CMD>tabonly<CR>"))
  --   vim.__key.rg({ "n", "v" }, "<C-t><C-o>", f("<CMD>tabonly<CR>"))
  -- end

  -- 获取文件信息
  vim.__key.rg("n", "<leader>i", vim.__ui.popup_fileinfo)

  -- delete-cut
  vim.__key.rg({ "n", "v" }, "d", "d")
  vim.__key.rg("n", "D", "dl")
  vim.__key.rg({ "n", "v" }, "x", "\"_d")
  vim.__key.rg("o", "x", "d")
  vim.__key.rg("n", "X", "\"_dl")
  vim.__key.rg("n", "C", "cl")
  vim.__key.rg("n", "Y", "yl")

  -- copy-paste
  vim.__key.rg("v", "p", "P")

  -- fold
  vim.__key.rg({ "n", "v" }, "tf", "zf")
  vim.__key.rg({ "n", "v" }, "to", "zo")
  vim.__key.rg({ "n", "v" }, "tO", "zO")
  vim.__key.rg({ "n", "v" }, "tc", "zc")
  vim.__key.rg({ "n", "v" }, "tC", "zC")
  vim.__key.rg({ "n", "v" }, "ta", "za")
  vim.__key.rg({ "n", "v" }, "tv", "zv")
  vim.__key.rg({ "n", "v" }, "tM", "zM")
  vim.__key.rg({ "n", "v" }, "tR", "zR")
  vim.__key.rg({ "n", "v" }, "td", "zd")
  vim.__key.rg({ "n", "v" }, "tD", "zD")
  vim.__key.rg({ "n", "v" }, "tE", "zE")
  vim.__key.rg({ "n", "v" }, "tn", "zn")
  vim.__key.rg({ "n", "v" }, "tN", "zN")
  vim.__key.rg({ "n", "v" }, "ti", "zi")
  vim.__key.rg({ "n", "v" }, "tj", "zj")
  vim.__key.rg({ "n", "v" }, "tk", "zk")

  -- search
  vim.__key.rg({ "n", "v" }, "<C-/>", "*", { remap = true })
  vim.__key.rg({ "n", "v" }, "?", function()
    if vim.fn.getreg("/") ~= "" then
      vim.__helper.clear_searchpattern()
      vim.__helper.clear_commandline()
      vim.api.nvim__redraw({ statusline = true })
    end
  end, { silent = true })
  -- 添加前置判断条件以防止奇怪的bug
  --  https://github.com/neovim/neovim/issues/21009
  vim.__key.rg("", "n", function()
    if vim.fn.getreg("/") ~= "" then
      return "n"
    else
      vim.__echo.err("E486: Pattern not found", "ErrorMsg")
      return ""
    end
  end, { expr = true })
  vim.__key.rg("", "N", function()
    if vim.fn.getreg("/") ~= "" then
      return "N"
    else
      vim.__echo.err("E486: Pattern not found", "ErrorMsg")
      return ""
    end
  end, { expr = true })

  -- 跳转到上一个访问的文件
  vim.__key.rg("n", "ga", vim.__buf.goto_altbuf)
  -- 跳转到上一个编辑的文件
  vim.__key.rg("n", "gf", vim.__buf.goto_modifiedbuf)

  -- bookmarks
  vim.__key.rg("n", "mm", function()
    local byte = vim.fn.getchar(-1)
    if type(byte) ~= "number" then
      return
    end
    if byte == 27 then -- <esc>
      return
    end

    local bmid = string.char(byte)
    local bufnr = vim.__buf.current()
    local lnum, _ = vim.__cursor.get()

    vim.__bookmark:set(bufnr, { lnum = lnum, bmid = bmid })
  end, { motion = true })
  vim.__key.rg("n", "mn", function()
    local byte = vim.fn.getchar(-1)
    if type(byte) ~= "number" then
      return
    end
    if byte == 27 then -- <esc>
      return
    end

    local bmid = string.char(byte)
    local bufnr = vim.__buf.current()
    local lnum, _ = vim.__cursor.get()

    vim.ui.input({ prompt = "set alias: ", }, function(alias)
      if vim.trim(alias or "") == "" then alias = nil end
      vim.__bookmark:set(bufnr, { lnum = lnum, bmid = bmid, alias = alias })
    end)
  end, { motion = true })
  vim.__key.rg("n", "ma", function()
    local bufnr = vim.__buf.current()
    local lnum, _ = vim.__cursor.get()
    vim.__bookmark:change_alias(bufnr, lnum)
  end)
  vim.__key.rg("n", "md", function ()
    local bufnr = vim.__buf.current()
    local lnum, _ = vim.__cursor.get()
    vim.__bookmark:del(bufnr, lnum)
  end)
  vim.__key.rg("n", "M", function ()
    vim.ui.input({ prompt = "Delete all bookmarks, y/N: ", }, function(ip)
      if not ip or string.lower(ip) ~= "y" then
        return
      end

      local bufnr = vim.__buf.current()

      local deleted = {}
      for _, extmark in ipairs(vim.__bookmark:get(bufnr)) do
        local extmark_lnum = extmark[2] + 1
        if not deleted[extmark_lnum] then
          deleted[extmark_lnum] = 1
          vim.__bookmark:del(bufnr, extmark_lnum)
        end
      end
    end)
  end)
  vim.__key.rg("n", "mo", function ()
    vim.ui.input({ prompt = "Delete all bookmarks except current, y/N: ", }, function(ip)
      if not ip or string.lower(ip) ~= "y" then
        return
      end

      local bufnr = vim.__buf.current()
      local lnum, _ = vim.__cursor.get()

      local deleted = {}
      for _, extmark in ipairs(vim.__bookmark:get(bufnr)) do
        local extmark_lnum = extmark[2] + 1
        if not deleted[extmark_lnum] and extmark_lnum ~= lnum then
          deleted[extmark_lnum] = 1
          vim.__bookmark:del(bufnr, extmark_lnum)
        end
      end
    end)
  end)
  vim.__key.rg("n", "[m", function ()
    local bufnr = vim.__buf.current()
    vim.__bookmark:jumpto(bufnr, -1)
  end)
  vim.__key.rg("n", "]m", function ()
    local bufnr = vim.__buf.current()
    vim.__bookmark:jumpto(bufnr, 1)
  end)
  vim.__key.rg({ "n", "v" }, "gm", function()
    local bufnr = vim.__buf.current()

    local byte = vim.fn.getchar(-1)
    if type(byte) ~= "number" then
      return
    end
    if byte == 27 then -- <esc>
      return
    end

    local bm_id = string.char(byte)
    vim.__bookmark:goto(bufnr, bm_id)
  end, { motion = true })
  vim.__key.rg("n", "m<f1>", function()
    vim.__bookmark:debug()
  end)
end

local function set_neovide_keymaps()
  if not vim.g.neovide then
    return
  end

  -- 模拟终端中的复制粘贴行为
  vim.__key.rg("i", "<C-S-v>", "<C-o>P")
  vim.__key.rg("n", "<C-S-v>", "p")
  vim.__key.rg("c", "<C-S-v>", "<C-R>*")

  -- 最大化
  vim.__key.rg("n", "<f12>", function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end)

  -- 动态修改字体大小
  local function scale(amount)
    local temp = vim.g.neovide_scale_factor + amount
    if temp < 0.5 then
      return
    end
    vim.g.neovide_scale_factor = temp
  end
  vim.__key.rg("n", "<C-=>", vim.__util.wrap_f(scale, 0.1))
  vim.__key.rg("n", "<C-->", vim.__util.wrap_f(scale, -0.1))

  -- neovide 的鼠标使用有问题，为了方便后续排查问题映射一些 debug 使用的 key
  vim.__key.rg("i", "<f6>", function()
    vim.api.nvim_command_output("messages")
  end)
end

del_keymaps()
set_keymaps()
set_neovide_keymaps()

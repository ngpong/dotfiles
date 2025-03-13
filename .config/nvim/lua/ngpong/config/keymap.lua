local kmode = vim.__key.e_mode
local etypes = vim.__event.types

local NVSO   = kmode.NVSO
local N      = kmode.N
local C      = kmode.C
local I      = kmode.I
local VS     = kmode.VS
local O      = kmode.O
local T      = kmode.T
local NVS    = { N, VS }
local NVSC   = { N, VS, C }
local NC     = { N, C }
local NI     = { N, I }
local NVSOI  = { NVSO, I }
local NVSOC  = { NVSO, C }
local NVSOCT = { NVSO, C, T }
local NVSI   = { N, VS, I }
local IC     = { I, C }

local function del_keymaps()
  -- vim.__key.unrg(NVSO, "0")  -- 跳转至最后一个字符
  -- vim.__key.unrg(NVSO, "^")  -- 跳转至第一个非空白字符
  -- vim.__key.unrg(NVSO, "$")  -- 跳转至最后一个字符

  -- vim.__key.unrg(NVSO, "g_") -- 类似于 <END>
  -- vim.__key.unrg(NVSO, "g0") -- 跳转至第一列
  -- vim.__key.unrg(NVSO, "g^") -- 跳转至第一个非空白字符；在 linewrap 下会与 ^ 有区别
  -- vim.__key.unrg(NVSO, "g$") -- 跳转至最后一个字符；在 linewrap 下会与 $ 有区别
  -- vim.__key.unrg(NVSO, "gm") -- 跳转至行的相较于窗口宽度的中间位置
  -- vim.__key.unrg(NVSO, "gM") -- 跳转至行的中间位置
  -- vim.__key.unrg(NVSO, "gk") -- 向上移动；在 linewrap 下与 k 有区别
  -- vim.__key.unrg(NVSO, "gj") -- 向下移动；在 linewrap 下与 j 有区别
  -- vim.__key.unrg(NVSO, "ge") -- 向后到单词的最后一个字符
  -- vim.__key.unrg(NVSO, "gE") -- 向后到单词的最后一个字符
  -- vim.__key.unrg(NVSO, "go") -- 从起始位置按字节跳转
  -- vim.__key.unrg(NVSO, "gp") -- 与 p/P 的行为差不多
  -- vim.__key.unrg(NVSO, "gP") -- 与 p/P 的行为差不多
  -- vim.__key.unrg(NVSO, "gr") -- replace 相关的，没有必要
  -- vim.__key.unrg(NVSO, "gR") -- replace 相关的，没有必要
  -- vim.__key.unrg(NVSO, "g~") -- 切换字符的大小写
  -- vim.__key.unrg(NVSO, "g?") -- 切换为 ROT13 编码，没啥用
  -- vim.__key.unrg(NVSO, "ga") -- 显示当前光标下字符的 ASCII 信息
  -- vim.__key.unrg(NVSO, "g8") -- 显示当前光标下字符的字节序列
  -- vim.__key.unrg(NVSO, "g<C-g>") -- 显示当前光标下的位置（行、列等）
  -- vim.__key.unrg(NVSO, "gf") -- 编辑当前光标下指定的文件名
  -- vim.__key.unrg(NVSO, "gF") -- 编辑当前光标下指定的文件名
  -- vim.__key.unrg(NVSO, "g<C-h>") -- 进入 select block 模式
  -- vim.__key.unrg(NVSO, "g<C-]>") -- tag相关
  -- vim.__key.unrg(NVSO, "g&") -- 重复最后一次执行的 :s 命令
  -- vim.__key.unrg(NVSO, "g'") -- 跳转 mark（不设置jumplist）
  -- vim.__key.unrg(NVSO, "g`") -- 跳转 mark（不设置jumplist）
  -- vim.__key.unrg(NVSO, "g+") -- 和 <C-R> 的功能类似
  -- vim.__key.unrg(NVSO, "g-") -- 和 u 的功能类似
  -- vim.__key.unrg(NVSO, "g<") -- 显示上一个命令的输出
  -- vim.__key.unrg(NVSO, "gD") -- 从文件中寻找符号定义并跳转
  -- vim.__key.unrg(NVSO, "gH") -- 和 V 功能一致
  -- vim.__key.unrg(NVSO, "gt") -- 切换到下一个tabpage
  -- vim.__key.unrg(NVSO, "gT") -- 切换到上一个tabpage
  -- vim.__key.unrg(NVSO, "gV") -- 不知道有什么用
  -- vim.__key.unrg(NVSO, "g]") -- tag相关
  -- vim.__key.unrg(NVSO, "gh") -- 类似于 v
  -- vim.__key.unrg(NVSO, "<A-g><A-h>") -- 类似于 v
  -- vim.__key.unrg(NVSO, "gw") -- 格式化文本，与 gq 类似，但是不使用 formatexpr
  -- vim.__key.unrg(NVSO, "g<tab>") -- 切换到上一次访问的 tabpage
  -- vim.__key.unrg(NVSO, "gs") -- 使neovim睡n秒
  -- vim.__key.unrg(N, "gQ") -- 切换到 Ex 模式
  vim.__key.unrg(NVSO, "g")
  vim.__key.del(NVSO, "gri") -- vim.lsp.buf.implementation
  vim.__key.del(NVSO, "grr") -- vim.lsp.buf.references
  vim.__key.del(NVSO, "gra") -- vim.lsp.buf.code_action
  vim.__key.del(NVSO, "grn") -- vim.lsp.buf.rename
  vim.__key.del(NVSO, "gO") -- vim.lsp.buf.document_symbol
  vim.__key.del(NVSO, "gx") -- netrw
  vim.__key.del(NVSO, "gc") -- comment
  vim.__key.del(NVSO, "gcc") -- comment

  -- https://neovim.io/doc/user/quickref.html#Q_sc
  --  vim.__key.unrg(NVS, "z-") -- 与 zb 一致
  --  vim.__key.unrg(NVS, "z.") -- 与 zz 一致
  --  -- https://neovim.io/doc/user/quickref.html#Q_wq
  --  vim.__key.unrg(N, "ZZ") -- 与 :x 类似
  --  vim.__key.unrg(N, "ZQ") -- 与 :q! 类似
  --  vim.__key.unrg(N, "<C-z>") -- 退出neovim
  --  -- https://neovim.io/doc/user/vimindex.html#_2.5-commands-starting-with-'z'
  --  vim.__key.unrg(NVS, "z+") -- 与 zt 类似，但是我们能够指定具体行号并跳转
  --  vim.__key.unrg(NVS, "z<CR>") -- 与 zt 一致
  --  vim.__key.unrg(NVS, "z=") -- 打开拼写建议
  --  vim.__key.unrg(NVS, "zF") -- 与 zf 类似
  --  vim.__key.unrg(N, "zG") -- 拼写建议相关
  --  vim.__key.unrg(N, "zg") -- 拼写建议相关
  --  vim.__key.unrg(NVS, "z^") -- 与 zb 类似，但是我们能够指定具体行号并跳转
  --  vim.__key.unrg(NVS, "zp") -- 与粘贴有关，还不清楚具体作用
  --  vim.__key.unrg(NVS, "zP") -- 与粘贴有关，还不清楚具体作用
  --  vim.__key.unrg(N, "zw") -- 拼写建议相关
  --  vim.__key.unrg(NVS, "zy") -- 与复制有关，还不清楚具体作用
  --  vim.__key.unrg(N, "zW") -- 拼写建议相关
  --  vim.__key.unrg(N, "zu") -- 拼写建议相关
  --  vim.__key.unrg(N, "zr") -- fold相关
  --  vim.__key.unrg(N, "zX") -- fold相关
  --  vim.__key.unrg(N, "zj") -- fold相关
  --  vim.__key.unrg(N, "zk") -- fold相关
  --  vim.__key.unrg(NVS, "zH")
  --  vim.__key.unrg(NVS, "zL")
  vim.__key.unrg(NVSO, "z")
  vim.__key.unrg(NVSO, "Z")

  -- https://neovim.io/doc/user/quickref.html#Q_wi
  vim.__key.unrg(NVSO, "<C-w>")

  -- https://neovim.io/doc/user/quickref.html#Q_ud
  vim.__key.unrg(NVSO, "_")
  vim.__key.unrg(NVSO, "-")  -- 向上移动；如果有则至第一个非空字符
  vim.__key.unrg(NVSO, "+")  -- 向下移动；如果有则至第一个非空字符
  vim.__key.unrg(NVSO, "=") -- 和对齐有关的，无用
  vim.__key.unrg(NVSO, "!") -- 无用

  -- https://neovim.io/doc/user/quickref.html#Q_pa
  -- vim.__key.unrg(NVSO, "/")
  -- vim.__key.unrg(NVSO, "?")
  -- vim.__key.unrg(NVSO, "*")  -- 搜索当前光标下的单词
  -- vim.__key.unrg(NVSO, "#")  -- 搜索当前光标下的单词
  -- vim.__key.unrg(NVSO, "g*") -- 搜索当前光标下的单词
  -- vim.__key.unrg(NVSO, "g#") -- 搜下并跳转至当前光标下单词的下一个匹配（不使用 \< \>）

  -- https://neovim.io/doc/user/quickref.html#Q_ma
  vim.__key.unrg(NVSO, "m") -- 设置 mark
  vim.__key.unrg(NVSO, "'") -- 跳转 mark
  vim.__key.unrg(NVSO, "`") -- 跳转 mark

  -- https://neovim.io/doc/user/quickref.html#Q_ta
  vim.__key.unrg(NVSO, "<C-]>")  -- tag 相关
  vim.__key.unrg(NVSOI, "<C-t>")  -- tag 相关

  -- https://neovim.io/doc/user/quickref.html#Q_ss
  vim.__key.unrg(I, "<C-a>") -- 插入上一次插入的字符；效果有点奇怪
  vim.__key.unrg(I, "<C-@>") -- 插入上一次插入的字符并返回 normal mode；效果有点奇怪
  -- vim.__key.unrg(I, "<C-x>") -- 和内置完成列表相关的，但是没啥用

  -- https://neovim.io/doc/user/quickref.html#Q_ch
  -- vim.__key.unrg(NVSO, "r") -- replace 相关的，没有必要
  -- vim.__key.unrg(NVSO, "R") -- replace 相关的，没有必要
  vim.__key.unrg(NVSO, "S") -- 和 c 类似的键
  -- vim.__key.unrg(NVS, "s") -- 和 c 类似的键
  vim.__key.unrg(NVSO, "~") -- 切换字符的大小写

  -- https://neovim.io/doc/user/quickref.html#Q_vc
  vim.__key.unrg(NVSO, "<C-g>") -- 显示当前文件名

  -- https://neovim.io/doc/user/quickref.html#Q_ce
  vim.__key.unrg(C, "<C-v>") -- 用于输入特殊字符的
  vim.__key.unrg(C, "<C-d>") -- 展示光标前面单词能够匹配的所有列表
  vim.__key.unrg(C, "<C-a>") -- 完成一个单词

  -- https://neovim.io/doc/user/quickref.html#Q_ed
  vim.__key.unrg(NVSO, "<C-^>")

  -- https://neovim.io/doc/user/vimindex.html#_2.3-square-bracket-commands
  vim.__key.unrg(NVSO, "[P") -- 与 P 类似
  vim.__key.unrg(NVSO, "[p") -- 与 p 类似
  vim.__key.unrg(NVSO, "]P") -- 与 P 类似
  vim.__key.unrg(NVSO, "]p") -- 与 p 类似
  vim.__key.unrg(NVSO, "[*") -- 跳转至前一个 *
  vim.__key.unrg(NVSO, "]*") -- 跳转至下一个 *
  vim.__key.unrg(NVSO, "[/") -- 跳转至前一个 C 备注 /* */
  vim.__key.unrg(NVSO, "]/") -- 跳转至下一个 C 备注 /* */
  vim.__key.unrg(NVSO, "[I") -- 输出当前光标下单词在当前文件中所有匹配的列表
  vim.__key.unrg(NVSO, "]I") -- 输出当前光标下单词在当前文件中所有匹配的列表
  vim.__key.unrg(NVSO, "]D") -- 与 diagnostic 相关，这里采用 ]d 应该就够了  
  vim.__key.unrg(NVSO, "[c") -- 不太清楚作用
  vim.__key.unrg(NVSO, "]c") -- 不太清楚作用
  vim.__key.unrg(NVSO, "[f") -- 与 gf 一致
  vim.__key.unrg(NVSO, "[i") -- 显示当前光标下的单词在文件中第一个找到的匹配项
  vim.__key.unrg(NVSO, "[s") -- 拼写相关
  vim.__key.unrg(NVSO, "]s") -- 拼写相关
  vim.__key.unrg(NVSO, "['") -- 跳转至前一个小写 mark
  vim.__key.unrg(NVSO, "]'") -- 跳转至下一个小写 mark
  vim.__key.unrg(NVSO, "[`") -- 跳转至前一个小写 mark
  vim.__key.unrg(NVSO, "]`") -- 跳转至前一个小写 mark
  vim.__key.unrg(NVSO, "]f") -- 类似于 gf 的功能
  vim.__key.unrg(NVSO, "]i") -- 查找光标下字符的功能，没啥用
  vim.__key.unrg(NVSO, "[<C-d>") -- tag相关
  vim.__key.unrg(NVSO, "[<C-i>") -- tag相关
  vim.__key.unrg(NVSO, "]<C-d>") -- tag相关
  vim.__key.unrg(NVSO, "]<C-i>") -- tag相关
  vim.__key.unrg(NVSO, "[*") -- 跳转到注释 /* */ 的起始
  vim.__key.unrg(NVSO, "]*") -- 跳转到注释 /* */ 的结尾
  vim.__key.unrg(NVSO, "[#") -- 跳转到 c/c++ 宏相关
  vim.__key.unrg(NVSO, "]#") -- 跳转到 c/c++ 宏相关
  vim.__key.unrg(NVSO, "[]") -- 跳转到前一个函数的起始 } 位置；vim的默认行为要求 } 必须独占一列
  vim.__key.unrg(NVSO, "][") -- 跳转到后一个函数的起始 } 位置；vim的默认行为要求 } 必须独占一列
  vim.__key.unrg(NVSO, "[m") -- 跳转到成员函数的开头；要求必须拥有类似 java 的语言结构；与 { 所绑定
  vim.__key.unrg(NVSO, "]M") -- 跳转到成员函数的结尾；要求必须拥有类似 java 的语言结构；与 { 所绑定
  vim.__key.unrg(NVSO, "]m") -- 与 [m 功能类似
  vim.__key.unrg(NVSO, "]M") -- 与 [M 功能类似

  -- misc
  -- vim.__key.unrg(NVSOC, "<C-h>")
  -- vim.__key.unrg(NVSOC, "<C-j>")
  -- vim.__key.unrg(NVSOC, "<C-k>")
  -- vim.__key.unrg(NVSOC, "<C-l>")
  -- vim.__key.unrg(VS, "R")
  vim.__key.unrg(N, "F")
  vim.__key.unrg(NVSO, "t")
  vim.__key.unrg(NVSO, "T")
  vim.__key.unrg(NVSOC, "<C-y>")
  vim.__key.unrg(NVSOC, "<C-e>")
  vim.__key.unrg(NC, "<C-r>")
  vim.__key.unrg(NVS, ";")
  vim.__key.unrg(NVS, ",")
  vim.__key.unrg(VS, "u")
  vim.__key.unrg(VS, "U")
  vim.__key.unrg(NVSO, "|")
  vim.__key.unrg(NVS, "?")
  vim.__key.unrg(NVS, "<C-a>")
  -- vim.__key.unrg(NVS, "<C-x>")
  vim.__key.unrg(NVSOI, "<C-c>")
  vim.__key.unrg(NVSOCT, "<C-q>")
  vim.__key.unrg(I, "<C-y>")
  vim.__key.unrg(I, "<C-e>")
  vim.__key.unrg(I, "<C-d>")
  vim.__key.unrg(VS, "q")
  -- vim.__key.unrg(I, "<C-i>")
  vim.__key.del(I, "<C-s>")
  vim.__key.del(NVSO, "[q")
  vim.__key.del(NVSO, "]q")
end

local set_keymaps = function()
  local function f1(key)
    return function()
      vim.cmd("keepjumps norm! " .. vim.v.count .. key)
    end
  end

  vim.__autocmd.on("FileType", vim.schedule_wrap(function(state)
    vim.__key.rg(N, "q", function()
      vim.__win.close(0)
      vim.__buf.wipeout(state.buf)
    end, { buffer = state.buf, silent = true })
  end), { pattern = vim.__filter.filetypes[2] })

  vim.__key.rg(N, "q", function()
    if vim.__win.close_diff() then
      return
    end

    if vim.__win.is_float(0) then
      vim.__buf.wipeout()
      vim.__win.close(0)
      return
    end
  end)

  vim.__key.rg(N, "<C-c>", function()
    for _, winid in ipairs(vim.__win.all()) do
      if vim.w[winid].line ~= nil then
        vim.__win.close(winid)
      elseif vim.w[winid].gitsigns_preview ~= nil then
        vim.__win.close(winid)
      end
    end
  end)
  -- vim.__key.rg(I, "<C-c>", function() return "<C-c>" end, { expr = true })

  -- movement
  vim.__key.rg(NVS, "j", function() return vim.v.count > 1 and "m'" .. vim.v.count .. "j" or "j" end, { expr = true })
  vim.__key.rg(NVS, "k", function() return vim.v.count > 1 and "m'" .. vim.v.count .. "k" or "k" end, { expr = true })
  vim.__key.rg(I, "<C-h>", "<left>", { remap = true })
  vim.__key.rg(I, "<C-j>", "<down>", { remap = true })
  vim.__key.rg(I, "<C-k>", "<up>", { remap = true })
  vim.__key.rg(I, "<C-l>", "<right>", { remap = true })
  vim.__key.rg(IC, "<C-b>", "<C-LEFT>")
  vim.__key.rg(IC, "<C-f>", "<C-RIGHT>")
  vim.__key.rg(IC, "<C-S-H>", "<C-LEFT>")
  vim.__key.rg(IC, "<C-S-L>", "<C-RIGHT>")

  vim.__key.rg(NVSO, "gp", "%")
  vim.__key.rg(NVSO, "ge", "G")
  vim.__key.rg(NVSO, "gg", "gg")
  vim.__key.rg(NVSO, "gt", "H")
  vim.__key.rg(NVSO, "gc", "M")
  vim.__key.rg(NVSO, "gb", "L")
  vim.__key.rg(NVSO, "gv", function() return "m'gv" end, { expr = true })

  -- vim.__key.rg(NVSO, "gj", "j")
  -- vim.__key.rg(NVSO, "gk", "k")
  vim.__key.rg(NVSO, "<C-e>", "$")
  vim.__key.rg(I,    "<C-e>", "<C-o>$")
  vim.__key.rg(C,    "<C-e>", "<END>")
  vim.__key.rg(NVSO, "<C-S-E>", "g_")
  vim.__key.rg(I,    "<C-S-E>", "<C-o>g_<RIGHT>")
  vim.__key.rg(NVSO, "<C-s>", "0")
  vim.__key.rg(I,    "<C-s>", "<C-o>^")
  vim.__key.rg(C,    "<C-s>", "<HOME>")
  vim.__key.rg(NVSO, "<C-S-S>", "^")
  vim.__key.rg(I,    "<C-S-S>", "<C-o>0")

  do
    local function f(key, msg)
      return function()
        local bufnr = vim.__bufnr.nr()

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
          ret = ret and vim.__notifier.warn(ret)
        end
      end
    end
    vim.__key.rg(NVSO, "g.", f("`.", "changelist is empty"))
    vim.__key.rg(N, "g;", f("g;"))
    vim.__key.rg(N, "g,", f("g,"))
  end

  -- screen
  vim.__key.rg(NVSO, "H", "zh")
  vim.__key.rg(NVSO, "J", "<C-e>")
  vim.__key.rg(NVSO, "K", "<C-y>")
  vim.__key.rg(NVSO, "L", "zl")
  vim.__key.rg(NVSO, "zh", "zH")
  vim.__key.rg(NVSO, "zl", "zL")
  vim.__key.rg(NVSO, "zk", "zb")
  vim.__key.rg(NVSO, "zj", "zt")
  vim.__key.rg(NVSO, "zz", "zz")
  vim.__key.rg(NVSO, "ze", "ze")
  vim.__key.rg(NVSO, "zs", "zs")

  -- edit
  vim.__key.rg(N, "A", "g_a")
  vim.__key.rg(N, "gA", "A")
  vim.__key.rg(N, "gI", "gI")
  vim.__key.rg(NVS, "f<C-a>", "<C-a>")
  vim.__key.rg(NVS, "f<C-x>", "<C-x>")
  vim.__key.rg(NVS, "fq", "gq")
  vim.__key.rg(NVS, "fj", "J")
  vim.__key.rg(NVS, "fJ", "gJ")
  vim.__key.rg(NVS, "fu", "gu")
  vim.__key.rg(NVS, "fU", "gU")

  -- windows
  do
    vim.__g.resize_step = 1

    local f = {
      [1] = function()
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
          return vim.__notifier.warn("Cannot close last window")
        end

        vim.__win.close()
      end,
      [2] = function()
        if #vim.__win.all() == 1 then
          return
        end

        local winid = require("window-picker").pick_window({
          filter_rules = {
            autoselect_one = false,
            include_current_win = true,
          }
        })
        if not winid then
          return
        end

        vim.__win.goto(winid)
      end,
      [3] = function()
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
      end,
      [4] = function()
        vim.__key.feed("<C-w>|")
        vim.__key.feed("<C-w>_")
      end,
      [6] = function(key)
        return function()
          vim.__key.feed(key)
        end
      end,
      [7] = function(f)
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
      end,
      [8] = function(f)
        return function()
          local winid = vim.__win.current()
          if vim.__win.is_diff(winid) then
            return
          end
          if vim.__win.is_float(winid) then
            return
          end

          f()
        end
      end,
    }

    for _, mtb in ipairs({
      { "c", f[7](f[1]) },
      { "s", f[7](f[6]("<C-w>s")) },
      { "v", f[7](f[6]("<C-w>v")) },
      { "p", f[7](f[2]) },
      { "o", f[7](f[3]) },
      { "g", f[7](f[6]("<C-w>=")) },
      { "f", f[7](f[4]) },
    }) do
      vim.__key.rg(N, "<C-w><C-" .. mtb[1] .. ">", mtb[2])
      vim.__key.rg(N, "<C-w>" .. mtb[1], mtb[2])
    end
    for _, mtb in ipairs({
      { "Left", f[8](f[6]("<C-w>H")) },
      { "Down", f[8](f[6]("<C-w>J")) },
      { "Up", f[8](f[6]("<C-w>K")) },
      { "Right", f[8](f[6]("<C-w>L")) },
    }) do
      vim.__key.rg(N, "<C-w><C-" .. mtb[1] .. ">", mtb[2])
      vim.__key.rg(N, "<C-w>" .. "<" .. mtb[1] .. ">", mtb[2])
    end

    for _, mtb in ipairs({
      { "h", "<C-w>h" },
      { "j", "<C-w>j" },
      { "k", "<C-w>k" },
      { "l", "<C-w>l" },
    }) do
      vim.__key.unrg(N, "<C-w><C-" .. mtb[1] .. ">")
      vim.__key.rg(N, "<C-" .. mtb[1] .. ">", mtb[2])
    end

    for _, mtb in ipairs({
      { "-", vim.__util.wrap_f(vim.__win.resize_op, "vertical resize -") },
      { "=", vim.__util.wrap_f(vim.__win.resize_op, "vertical resize +") },
      { "+", vim.__util.wrap_f(vim.__win.resize_op, "horizontal resize +") },
      { "_", vim.__util.wrap_f(vim.__win.resize_op, "horizontal resize -") },
    }) do
      vim.__key.rg(N, mtb[1], mtb[2])
    end
  end

  -- undo redo
  vim.__key.rg(NVS, "U", "<C-r>")

  -- tabpage
  do
    local function f(key)
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

        vim.__key.feed(key)
      end
    end

    vim.__key.rg(NVS, "]t", f("<CMD>tabnext<CR>"))
    vim.__key.rg(NVS, "[t", f("<CMD>tabprev<CR>"))
    vim.__key.rg(NVS, "<C-t>t", f("<CMD>tab split<CR>"))
    vim.__key.rg(NVS, "<C-t><C-t>", f("<CMD>tab split<CR>"))
    vim.__key.rg(NVS, "<C-t>n", f("<CMD>tab split<CR>"))
    vim.__key.rg(NVS, "<C-t><C-n>", f("<CMD>tab split<CR>"))
    vim.__key.rg(NVS, "<C-t>c", f("<CMD>tabclose<CR>"))
    vim.__key.rg(NVS, "<C-t><C-c>", f("<CMD>tabclose<CR>"))
    vim.__key.rg(NVS, "<C-t>o", f("<CMD>tabonly<CR>"))
    vim.__key.rg(NVS, "<C-t><C-o>", f("<CMD>tabonly<CR>"))
  end

  -- 获取文件信息
  vim.__key.rg(N, "<leader>i", vim.__ui.popup_fileinfo)

  -- delete-cut
  vim.__key.rg(NVS, "d", "d")
  vim.__key.rg(N, "D", "dl")
  vim.__key.rg(NVS, "x", "\"_d")
  vim.__key.rg(O, "x", "d")
  vim.__key.rg(N, "X", "\"_dl")
  vim.__key.rg(N, "C", "cl")
  vim.__key.rg(N, "Y", "yl")

  -- copy-paste
  vim.__key.rg(VS, "p", "P")

  -- record"
  vim.__key.rg(NVSO, "t", "q")
  vim.__key.rg(NVS, "T", "Q")
  vim.__key.rg(O, "T", function()
    local op = vim.v.operator
    if not op or op == "" then
      return
    end

    local ok, record = pcall(vim.fn.reg_recorded)
    if not ok or not record or record == "" then
      return
    end

    local ok, val = pcall(vim.fn.getreg, record)
    if not ok or not val or val == "" then
      return
    end

    pcall(vim.__key.feed, op .. val)
  end)

  -- fold
  vim.__key.rg(NVS, "[Z", "zk")
  vim.__key.rg(NVS, "]Z", "zj")

  -- search
  vim.__key.rg(NVS, "?", "*", { remap = true })
  vim.__key.rg(NVS, "\'", function()
    if vim.fn.getreg("/") ~= "" then
      vim.__helper.clear_searchpattern()
      vim.__helper.clear_commandline()
      vim.api.nvim__redraw({ statusline = true })
    end
  end, { silent = true })
  -- NGPONG/vim-tranquille
  -- vim.__key.rg(N, "/", "<CMD>TranquilleSearch pattern<CR>", { silent = true })
  -- vim.__key.rg(N, "?", "<CMD>TranquilleSearch word<CR>", { silent = true })
  -- vim.__key.rg(VS, "<C-/>", "<CMD>TranquilleSearch pattern<CR>", { silent = true })

  -- 跳转到上一个访问的文件
  vim.__key.rg(N, "ga", vim.__buf.goto_altbuf)
  -- 跳转到上一个编辑的文件
  vim.__key.rg(N, "gm", vim.__buf.goto_modifiedbuf)

  -- -- 重新映射一些键在insert模式下的行为
  -- vim.__key.rg(I, "<A-Enter>", "<CR>")
  -- vim.__key.rg(I, "<A-BS>", "<BS>")
  -- vim.__key.rg(I, "<C-H>", "<DEL>")
  -- vim.__key.rg(I, "<TAB>", "<C-I>")

  -- -- vim.__key.rg(N, "<ESC>", function()
  -- --   return "<ESC>"
  -- -- end, { expr = true })
  -- -- vim.__key.rg(SI, "<ESC>", "<ESC>")
  -- -- vim.__key.rg(C, "<ESC>", "<C-c>")

  -- -- 重新映射 enter 功能
  -- -- vim.__key.rg(N, "<CR>", "<C-m>")

  -- -- search command
  -- vim.__key.rg(N, "<C-]>", function()
  --   if vim.fn.getreg("/") == "" then
  --     return
  --   end

  --   local success, _ = pcall(vim.cmd, "normal! n")
  --   if not success then
  --     vim.__notifier.warn("Pattern [" .. vim.fn.getreg("/") .. "] not found any matched result.")
  --   end
  -- end)
  -- -- vim.__key.rg(N, "<C-[>", function()
  -- --   if vim.fn.getreg("/") == "" then
  -- --     return
  -- --   end

  -- --   local success, _ = pcall(vim.cmd, "normal! N")
  -- --   if not success then
  -- --     vim.__notifier.warn("Pattern [" .. vim.fn.getreg("/") .. "] not found any matched result.")
  -- --   end
  -- -- end)
  -- vim.__key.rg(N, "S", "/")
  -- vim.__key.rg(SV, "S", function ()
  --   local selected_text = vim.__helper.get_selected()
  --   vim.fn.setreg("*", selected_text)
  --   vim.fn.setreg("/", selected_text)
  --   vim.fn.histadd("/", selected_text)
  --   vim.__key.feed("<ESC>")
  -- )
end

local set_buffer_keymaps = vim.__async.schedule_wrap(function(bufnr)
  bufnr = bufnr or true
end)

local function set_neovide_keymaps()
  if not vim.g.neovide then
    return
  end

  -- 模拟终端中的复制粘贴行为
  vim.__key.rg(I, "<C-S-v>", "<C-o>P")
  vim.__key.rg(N, "<C-S-v>", "p")
  vim.__key.rg(C, "<C-S-v>", "<C-R>*")

  -- 最大化
  vim.__key.rg(N, "<f7>", function()
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
  vim.__key.rg(N, "<C-=>", vim.__util.wrap_f(scale, 0.1))
  vim.__key.rg(N, "<C-->", vim.__util.wrap_f(scale, -0.1))

  -- neovide 的鼠标使用有问题，为了方便后续排查问题映射一些 debug 使用的 key
  vim.__key.rg(I, "<f6>", function()
    vim.api.nvim_command_output("messages")
  end)
end

del_keymaps()
set_keymaps()
set_neovide_keymaps()
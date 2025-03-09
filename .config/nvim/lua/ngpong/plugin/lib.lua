return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    first = true,
    init = function()
      vim.__webicons = vim.__lazy.require("nvim-web-devicons")
    end,
    opts = {
      override = {
        zsh = {
          icon = "",
          color = "#6d8086",
          cterm_color = "66",
          name = "Zsh"
        },
      },
      override_by_filename = {
        [".zshrc"] = {
          icon = "",
          color = "#6d8086",
          cterm_color = "66",
          name = "Zsh"
        }
      },
      override_by_extension = {
        ["so"] = {
          icon = "",
          color = vim.__color.dark4,
          cterm_color = "253",
          name = "SharedObject"
        }
      },
      override_by_filetype = {
        lazy = {
          icon = "󰒲",
          color = vim.__color.bright_blue,
          name = "Lazy"
        },
        help = {
          icon = "󰘥",
          color = vim.__color.bright_purple,
          name = "Help"
        },
      }
    },
    config = function(_, opts)
      local override_by_filetype = opts.override_by_filetype
      opts.override_by_filetype = nil

      local override_fts = {}
      for k, v in pairs(override_by_filetype) do
        override_fts[k] = k opts.override[k] = v
      end
      vim.__webicons.set_icon_by_filetype(override_fts)

      vim.__webicons.setup(opts)
    end
  },
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
  {
    "s1n7ax/nvim-window-picker",
    lazy = true,
    opts = {
      selection_chars = "HJKLABCDEFGIMNOPQRSTUVWXYZ",
      picker_config = {
        statusline_winbar_picker = {
          use_winbar = "never",
        },
      },
      show_prompt = false,
      filter_rules = {
        autoselect_one = true,
        include_current_win = false,
        bo = {
          filetype = vim.__filter.filetypes[1],
          buflisted = { false }
        },
        file_path_contains = { 'nvim-tree-preview://' },
      },
      highlights = {
        winbar = {
          focused = {
            fg = "#282828",
            bg = "#b8bb26",
            bold = true,
          },
          unfocused = {
            fg = "#282828",
            bg = "#b8bb26",
            bold = true,
          },
        },
      },
    }
  },
 -- i <C-S-Down> <Plug>(VM-I-Arrow-E)
  -- i <C-C> <Plug>(VM-I-CtrlC)
  -- i <C-Down> <Plug>(VM-I-Arrow-e)
  -- i <C-Left> <Plug>(VM-I-Arrow-b)
  -- i <Up> <Plug>(VM-I-Up-Arrow)
  -- i <C-V> <Plug>(VM-I-Paste)
  -- i <C-S-Left> <Plug>(VM-I-Arrow-B)
  -- i <Insert> <Plug>(VM-I-Replace)
  -- i <Home> <Plug>(VM-I-Home)
  -- i <Right> <Plug>(VM-I-Right-Arrow)
  -- i <C-S-Up> <Plug>(VM-I-Arrow-gE)
  -- i <Down> <Plug>(VM-I-Down-Arrow)
  -- i <End> <Plug>(VM-I-End)
  -- i <BS> <Plug>(VM-I-BS)
  -- i <C-W> <Plug>(VM-I-CtrlW)
  -- i <Del> <Plug>(VM-I-Del)
  -- i <Left> <Plug>(VM-I-Left-Arrow)
  -- i <C-S-Right> <Plug>(VM-I-Arrow-W)
  -- i <C-^> <Plug>(VM-I-Ctrl^)
  -- i <C-U> <Plug>(VM-I-CtrlU)
  -- i <C-O> <Plug>(VM-I-CtrlO)
  -- i <C-F> <Plug>(VM-I-CtrlF)
  -- i <C-D> <Plug>(VM-I-CtrlD)
  -- i <C-B> <Plug>(VM-I-CtrlB)
  -- i <C-Up> <Plug>(VM-I-Arrow-ge)
  -- i <C-Right> <Plug>(VM-I-Arrow-w)
  -- i <CR> <Plug>(VM-I-Return)
  -- n % <Plug>(VM-Motion-%)
  -- n M <Plug>(VM-Toggle-Multiline)
  -- n Q <Plug>(VM-Remove-Region)
  -- n R <Plug>(VM-Replace)
  -- n S <Plug>(VM-Surround)


  -- n \\V <Plug>(VM-Run-Last-Visual)
  -- n \\C <Plug>(VM-Case-Conversion-Menu)
  -- n \\s <Plug>(VM-Split-Regions)
  -- n \\c <Plug>(VM-Case-Setting)
  -- n \\S <Plug>(VM-Search-Menu)
  -- n \\q <Plug>(VM-Remove-Last-Region)
  -- n \\w <Plug>(VM-Toggle-Whole-Word)
  -- n \\e <Plug>(VM-Transform-Regions)
  -- n \\f <Plug>(VM-Filter-Regions)
  -- n \\<C-X> <Plug>(VM-Alpha-Decrease)
  -- n \\<C-A> <Plug>(VM-Alpha-Increase)
  -- n \\m <Plug>(VM-Merge-Regions)
  -- n \\0n <Plug>(VM-Zero-Numbers-Append)
  -- n \\t <Plug>(VM-Transpose)
  -- n \\N <Plug>(VM-Numbers)
  -- n \\Z <Plug>(VM-Run-Last-Normal)
  -- n \\<CR> <Plug>(VM-Toggle-Single-Region)
  -- n \\" <Plug>(VM-Show-Registers)
  -- n \\G <Plug>(VM-Goto-Regex!)
  -- n \\+ <Plug>(VM-Enlarge)
  -- n \\<lt> <Plug>(VM-Align-Char)
  -- n \\a <Plug>(VM-Align)
  -- n \\- <Plug>(VM-Shrink)
  -- n \\X <Plug>(VM-Run-Last-Ex)
  -- n \\v <Plug>(VM-Run-Visual)
  -- n \\0N <Plug>(VM-Zero-Numbers)
  -- n \\r <Plug>(VM-Rewrite-Last-Search)
  -- n \\R <Plug>(VM-Remove-Every-n-Regions)
  -- n \\n <Plug>(VM-Numbers-Append)
  -- n \\d <Plug>(VM-Duplicate)
  -- n \\l <Plug>(VM-Show-Infoline)
  -- n \\L <Plug>(VM-One-Per-Line)
  -- n \\x <Plug>(VM-Run-Ex)
  -- n \\` <Plug>(VM-Tools-Menu)
  -- n \\g <Plug>(VM-Goto-Regex)
  -- n \\> <Plug>(VM-Align-Regex)
  -- n \\. <Plug>(VM-Run-Dot)
  -- n \\z <Plug>(VM-Run-Normal)
  -- n \\  <Plug>(VM-Toggle-Mappings)
  -- n ] <Plug>(VM-Goto-Next)
  -- n f <Plug>(VM-Motion-f)
  -- n gU <Plug>(VM-gU)
  -- n g<C-A> <Plug>(VM-gIncrease)
  -- n g/ <Plug>(VM-Slash-Search)
  -- n g} <Plug>(VM-Motion-]})
  -- n g( <Plug>(VM-Motion-[()
  -- n ge <Plug>(VM-Motion-ge)
  -- n g{ <Plug>(VM-Motion-[{)
  -- n gE <Plug>(VM-Motion-gE)
  -- n g) <Plug>(VM-Motion-]))
  -- n g<C-X> <Plug>(VM-gDecrease)
  -- n gu <Plug>(VM-gu)
  -- n gc <Plug>(VM-gc)
  -- n r <Plug>(VM-Replace-Characters)
  -- n | <Plug>(VM-Motion-|)
  -- n ~ <Plug>(VM-~)
  -- n <M-C-Down> <Plug>(VM-Select-Cursor-Down)
  -- n <Del> <Plug>(VM-Del)
  -- n <M-C-Up> <Plug>(VM-Select-Cursor-Up)
  -- n <C-Up> <Plug>(VM-Add-Cursor-Up)
  -- n <C-B> <Plug>(VM-Seek-Up)
  -- n <C-F> <Plug>(VM-Seek-Down)
  -- n <C-X> <Plug>(VM-Decrease)
  -- n <C-Down> <Plug>(VM-Add-Cursor-Down)
  -- n <M-S-Left> <Plug>(VM-Move-Left)
  -- n <C-A> <Plug>(VM-Increase)
  -- n <M-S-Right> <Plug>(VM-Move-Right)
  -- n <M-Right> <Plug>(VM-Single-Select-l)
  -- n <M-Left> <Plug>(VM-Single-Select-h)
  -- n m         <Plug>(VM-Find-Operator)
  -- n & <Plug>(VM-&)

  -- n \\@ <Plug>(VM-Run-Macro)
  -- n W <Plug>(VM-Motion-W) -- no
  -- n X <Plug>(VM-X) -- no
  -- n [ <Plug>(VM-Goto-Prev) -- yes
  -- x \r <Plug>(VM-Visual-Reduce) -- no
  -- x \s <Plug>(VM-Visual-Subtract) -- yes
  -- n T <Plug>(VM-Motion-T) -- yes
  -- n Y <Plug>(VM-Y) -- no
  -- n t <Plug>(VM-Motion-t) -- yes
  -- n x <Plug>(VM-x)
  -- n B <Plug>(VM-Motion-B)
  -- n C <Plug>(VM-C)
  -- n D <Plug>(VM-D)
  -- n E <Plug>(VM-Motion-E)
  -- n F <Plug>(VM-Motion-F)
  -- n I <Plug>(VM-I)
  -- n J <Plug>(VM-J)
  -- n A <Plug>(VM-A)
  -- n a         <Plug>(VM-a)
  -- n c         <Plug>(VM-c)
  -- n d         <Plug>(VM-Delete)
  -- n i         <Plug>(VM-i)
  -- n o         <Plug>(VM-o)
  -- n y         <Plug>(VM-Yank)
  -- n O         <Plug>(VM-O)
  -- n p         <Plug>(VM-p-Paste)
  -- n P         <Plug>(VM-P-Paste)
  -- n <Esc>     <Plug>(VM-Exit)
  -- n ,         <Plug>(VM-Motion-,)
  -- n ;         <Plug>(VM-Motion-;)
  -- n <Tab>     <Plug>(VM-Switch-Mode)
  -- n (         <Plug>(VM-Motion-() -- 并不好用
  -- n )         <Plug>(VM-Motion-)) -- 并不好用
  -- n {         <Plug>(VM-Motion-{) -- 并不好用
  -- n }         <Plug>(VM-Motion-}) -- 并不好用
  -- n 0         <Plug>(VM-Motion-0)
  -- n $         <Plug>(VM-Motion-$)
  -- n ^         <Plug>(VM-Motion-^)
  -- n b         <Plug>(VM-Motion-b)
  -- n e         <Plug>(VM-Motion-e)
  -- n h         <Plug>(VM-Motion-h)
  -- n j         <Plug>(VM-Motion-j)
  -- n k         <Plug>(VM-Motion-k)
  -- n l         <Plug>(VM-Motion-l)
  -- n w         <Plug>(VM-Motion-w)
  -- n <S-Up>    <Plug>(VM-Select-k)
  -- n <S-Right> <Plug>(VM-Select-l)
  -- n <S-Down>  <Plug>(VM-Select-j)
  -- n <S-Left>  <Plug>(VM-Select-h)
  -- n .         <Plug>(VM-Dot)
  -- n /         <Plug>(VM-/)
  -- n :         <Plug>(VM-:)
  -- n ?         <Plug>(VM-?)
  -- n q         <Plug>(VM-Skip-Region)
  -- n N         <Plug>(VM-Find-Prev)
  -- n n         <Plug>(VM-Find-Next)
  -- n s         <Plug>(VM-Select-Operator)
  { "NGPONG/vim-visual-multi", init = function()
    local kmodes = vim.__key.e_mode

    -- nvimtree, nvimtree-preview

    local builtin_vmkeys = {}
    local user_vmkeys = {}
    local native_keys = {}

    local function remove_local_vm(bufnr)
      local prefix = "<Plug>(VM-"

      for _, mode in ipairs(vim.tbl_filter(function(val) return val ~= kmodes.NVSO end, kmodes)) do
        local keys = {}

        for _, key in ipairs(vim.__key.list(mode, bufnr)) do
          local rhs = key.rhs

          if type(rhs) == "string" and string.sub(rhs, 1, #prefix) == prefix then
            vim.__key.del(mode, key.lhs, { buffer = bufnr })
            table.insert(keys, key.lhs)
          end
        end

        if next(keys) then
          builtin_vmkeys[mode] = keys
        end
      end
    end

    local function remove_native(mode, keys)
      local tmp = {}
      for _, keyspec in ipairs(vim.__key.list(mode)) do
        tmp[keyspec.lhs] = keyspec
      end

      if not native_keys[mode] then
        native_keys[mode] = {}
      end

      for _, key in ipairs(keys) do
        local keyspec = tmp[key]
        if keyspec then
          vim.__key.del(mode, keyspec.lhs)
          native_keys[mode][key] = keyspec
        end
      end
    end

    local function remove_global_vm()
      local prefix = "<Plug>(VM-"

      for _, mode in ipairs(vim.tbl_filter(function(val) return val ~= kmodes.NVSO end, kmodes)) do
        for _, key in ipairs(vim.__key.list(mode)) do
          local rhs = key.rhs

          if type(rhs) == "string" and string.sub(rhs, 1, #prefix) == prefix then
            vim.__key.del(mode, key.lhs)
          end
        end
      end
    end

    local function reset_local_vm(bufnr)
      for mode, keys in pairs(builtin_vmkeys) do
        for _, key in ipairs(keys) do
          vim.__key.rg(mode, key, "<NOP>", { buffer = bufnr })
        end
      end
      builtin_vmkeys = {}
    end

    local function reset_native()
      local function int2bool(val)
        return val ~= 0
      end

      for mode, keys in pairs(native_keys) do
        for _, keyspec in pairs(keys) do
          vim.__key.rg(mode, keyspec.lhs, keyspec.callback or keyspec.rhs, {
            nowait = int2bool(keyspec.nowait),
            remap = not int2bool(keyspec.noremap),
            script = int2bool(keyspec.script),
            silent = int2bool(keyspec.silent),
            expr = int2bool(keyspec.expr)
          })
        end
      end

      native_keys = {}
    end

    local function reg_user(mode, lhs, rhs, opts)
      if not user_vmkeys[mode] then user_vmkeys[mode] = {} end

      local final_opts = {
        silent = false
      }
      vim.__tbl.r_extend(final_opts, opts or {})

      vim.__key.rg(mode, lhs, rhs, final_opts)
      table.insert(user_vmkeys[mode], lhs)
    end

    local function regn_user(lhs, rhs, opts)
      reg_user(kmodes.N, lhs, rhs, opts)
    end

    local function regv_user(lhs, rhs, opts)
      reg_user(kmodes.VS, lhs, rhs, opts)
    end

    local function unreg_user(bufnr)
      for mode, keys in pairs(user_vmkeys) do
        for _, key in ipairs(keys) do
          pcall(vim.__key.del, vim.__key, mode, key, { buffer = bufnr })
        end
      end
      user_vmkeys = {}
    end

    local function exec_cmd(cmd)
      if string.upper(cmd) ~= "<NOP>" then
        -- vim.cmd.execute("\"normal \\" .. cmd .. "\"")
        vim.__key.feed(cmd, "nx")
      end
    end

    vim.g.VM_default_mappings = 0
    vim.g.VM_mouse_mappings = 0
    -- vim.g.VM_leader = { default = "`", visual = "`", buffer = "`" }
    vim.g.VM_recursive_operations_at_cursors = 1
    vim.g.VM_quit_after_leaving_insert_mode = 1
    vim.g.VM_quit_after_yank_operation = 1
    -- vim.g.VM_user_operators = {}
    vim.g.VM_maps = {
      ["Find Under"] = "<C-n>",
      ["Find Subword Under"] = "<C-n>",
      ["Add Cursor At Pos"] = "``",
      ["Add Cursor Down"] = "<C-A-j>",
      ["Add Cursor Up"] = "<C-A-k>",
      ["Select All"] = "~",
      ["Visual All"] = "~",
    }

    vim.g.VM_silent_exit = 1
    vim.g.VM_set_statusline = 0 -- vim.__logger.info(vim.b.VM_Selection.Vars.index + 1, #vim.b.VM_Selection.Regions)
    vim.g.VM_show_warnings = 0
    vim.g.VM_highlight_matches = "hi clear Search"
    vim.g.VM_highlight_incmatches = "hi clear IncSearch"

    local group = vim.__autocmd.augroup("vim-visual-multi")

    group:on("VimEnter", vim.__async.schedule_wrap(function(args)
      -- vim.api.nvim_set_hl(0, "VM_Mono", { underline = true, bold = true, italic = true, sp = vim.__color.light1 })
      -- vim.api.nvim_set_hl(0, "VM_Cursor", { link = "VM_Extend" })

      regv_user("`s", "<Plug>(VM-Visual-Subtract)")
    end))

    group:on("User", function(_)
      remove_native(kmodes.VS, { "f", "F", "t", "T" })
      remove_native(kmodes.O, { "f", "F", "t", "T" })
    end, { pattern = "visual_multi_start" })

    group:on("User", function(_)
      local bufnr = vim.__buf.current()

      remove_local_vm(bufnr)

      regn_user("<ESC>", function()
        -- 现代终端默认会将 alt+key 映射到 <esc>+key 的序列，使用这种方法避免
        -- 如果映射至 <ESC> 则需要下面这段代码
        if vim.fn.getchar(0) ~= 0 then return end

        reset_local_vm(bufnr)
        exec_cmd("<Plug>(VM-Exit)")
      end, { buffer = bufnr })

      for _, keys in ipairs({
        { "/", "<NOP>", { remap = true, silent = false } },
        { "?", "<NOP>", { remap = true, silent = false } },
        { "<C-/>", "<NOP>", { remap = true, silent = false } },
        { ":", ":", { remap = true, silent = false } },
        { "<TAB>", "<Plug>(VM-Switch-Mode)" },
        { ".", "<Plug>(VM-Dot)" },
        { "gj", "<Plug>(VM-J)" },
        { "a", "<Plug>(VM-a)" },
        { "A", "<Plug>(VM-A)" },
        { "i", "<Plug>(VM-i)" },
        { "I", "<Plug>(VM-I)" },
        { "o", "<Plug>(VM-o)" },
        { "O", "<Plug>(VM-O)" },
        { "p", "\"+<Plug>(VM-p-Paste)" },
        { "P", "\"+<Plug>(VM-P-Paste)" },
        { "c", "\"+<Plug>(VM-c)" },
        { "C", "\"+<Plug>(VM-c)l" },
        { "y", "\"+<Plug>(VM-Yank)" },
        { "Y", "\"+<Plug>(VM-Yank)l" },
        { "d", "\"+<Plug>(VM-Delete)" },
        { "D", "\"+<Plug>(VM-Delete)l" },
        { "x", "\"_<Plug>(VM-Delete)" },
        { "X", "\"_<Plug>(VM-Delete)l" },
        { "S", "<Plug>(VM-Select-Operator)" },
        { "[`", "<Plug>(VM-Goto-Prev)" },
        { "]`", "<Plug>(VM-Goto-Next)" },
        { ";", "<Plug>(VM-Motion-;)" },
        { ",", "<Plug>(VM-Motion-,)" },
        { "f", "<Plug>(VM-Motion-f)" },
        { "F", "<Plug>(VM-Motion-F)" },
        { "t", "<Plug>(VM-Motion-t)" },
        { "T", "<Plug>(VM-Motion-T)" },
        { "n", "<Plug>(VM-Find-Next)" },
        { "N", "<Plug>(VM-Find-Prev)" },
        { "<A-n>", function()
          vim.cmd("let b:VM_Selection.Vars.nav_direction = 1")
          exec_cmd("<Plug>(VM-Skip-Region)")
        end },
        { "<A-N>", function()
          vim.cmd("let b:VM_Selection.Vars.nav_direction = 0")
          exec_cmd("<Plug>(VM-Skip-Region)")
        end },
      }) do
        local opts = { buffer = bufnr }
        vim.__tbl.r_extend(opts, keys[3] or {})

        regn_user(keys[1], keys[2], { buffer = bufnr })
      end

      for _, keys in ipairs({
        { "<A-->", "<Plug>(VM-Motion-^)" },
        { "<A-=>", "<Plug>(VM-Motion-$)" },
        { "<A-h>", "<Plug>(VM-Motion-h)" },
        { "<A-j>", "<Plug>(VM-Motion-j)" },
        { "<A-k>", "<Plug>(VM-Motion-k)" },
        { "<A-l>", "<Plug>(VM-Motion-l)" },
        { "<A-q>", "<Plug>(VM-Motion-b)" },
        { "<A-w>", "<Plug>(VM-Motion-w)" },
        { "<A-e>", "<Plug>(VM-Motion-e)" },
      }) do
        regn_user(keys[1], function()
          if vim.g.Vm.extend_mode ~= 1 then
            exec_cmd(keys[2])
          else
            exec_cmd(keys[1])
          end
        end, { buffer = bufnr })
      end
      for _, keys in ipairs({
        { "-", "<Plug>(VM-Motion-^)", },
        { "=", "<Plug>(VM-Motion-$)", },
        { "h", "<Plug>(VM-Select-h)", },
        { "j", "<Plug>(VM-Select-j)", },
        { "k", "<Plug>(VM-Select-k)", },
        { "l", "<Plug>(VM-Select-l)", },
        { "q", "<Plug>(VM-Select-b)", },
        { "w", "<Plug>(VM-Select-w)", },
        { "e", "<Plug>(VM-Select-e)", },
      }) do
        regn_user(keys[1], function()
          if vim.g.Vm.extend_mode == 1 then
            exec_cmd(keys[2])
          else
            exec_cmd(keys[1])
          end
        end, { buffer = bufnr })
      end
    end, { pattern = "visual_multi_mappings" })

    group:on("User", function(_)
      unreg_user(vim.__buf.current())
      reset_native()
    end, { pattern = "visual_multi_exit" })
  end, enabled = false },
}

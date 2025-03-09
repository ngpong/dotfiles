-- https://github.com/ibhagwan/vim-cheatsheet?tab=readme-ov-file#cut-copy-and-paste
-- https://github.com/NvChad/ui
local Cheatsheet = vim.__class.def(function(this)
  local key_modes = {
    n = {
      text = "󰰓",
      hl = "CheatsheetBlue"
    },
    v = {
      text = "󰰫",
      hl = "CheatsheetOrange"
    },
    i = {
      text = "󰰄",
      hl = "CheatsheetRed"
    },
    c = {
      text = "󰯲",
      hl = "CheatsheetGreen"
    },
    o = {
      text = "󰰖",
      hl = "CheatsheetYellow"
    },
    m = {
      text = "󰰐",
      hl = "CheatsheetAqua"
    },
  }
  for _, value in pairs(key_modes) do value.text_len = vim.fn.strlen(value.text) end

  local ascii = {
    "                                      ",
    "                                      ",
    "█▀▀ █░█ █▀▀ ▄▀█ ▀█▀ █▀ █░█ █▀▀ █▀▀ ▀█▀",
    "█▄▄ █▀█ ██▄ █▀█ ░█░ ▄█ █▀█ ██▄ ██▄ ░█░",
    "                                      ",
  }

  local tips = {
    "1. commands that specify {motion} are called `operator`",
    "│",
    "├╴ operator {motion} only work in normal mode.",
    "│",
    "├╴ abbreviate {movement}, {motion}, {textobject} to {motion}.",
    "│",
    "├╴ `operator` can affect an entire line when doubled.",
    "│",
    "├╴ uppercase `operator` is generally used as a synonym for the doubling `operator`.",
    "│",
    "╰╴ [n] can be specified when `operator` doubling.",
    "",
    "2. the specified [n] defaults to 1 if not specifically requested",
    "",
    "3. the [n] specified by `textobject` is a special part.",
    "│",
    "├╴ inside a block, [n] extends the operation outward.",
    "│",
    "╰╴ outside a block, [n] pulls the operation inward.",
    "",
    "4. sentence and paragraph",
    "│",
    "├╴ sentence is defined as ending at a `.`, `!` or `?` followed by either the end of a line, or by a space or tab.",
    "│",
    "╰╴ paragraph starts after an empty line or at macros defined by character pairs in the `paragraphs` option.",
    "",
    "5. <SPACE> is <leader> key.",
    "",
    "6. all <C-W> suffixes can be appended with the ctrl key, e.g. <C-w>h == <C-w><C-h>.",
    "",
  }

  local mode_n = { key_modes.n }
  local mode_v = { key_modes.v }
  local mode_i = { key_modes.i }
  local mode_c = { key_modes.c }
  local mode_n_c = { key_modes.n, key_modes.c }
  local mode_i_c = { key_modes.i, key_modes.c }
  local mode_n_v = { key_modes.n, key_modes.v }
  local mode_n_o = { key_modes.n, key_modes.o }
  local mode_n_v_o = { key_modes.n, key_modes.v, key_modes.o }
  local mode_n_v_o_i = { key_modes.n, key_modes.v, key_modes.o, key_modes.i }
  local mode_m = { key_modes.m }
  local mode_o = { key_modes.o }
  local mode_v_o = { key_modes.v, key_modes.o }

  local builtin_keymaps = {
    {
      head = "cursor",
      maps = {
        { "[n]<C-UP> [n]<C-DOWN>", "add cursor upwards|downwards", mode_m },
        { "[n]<S-LEFT> [n]<S-RIGHT>", "select left|right", mode_m },
      }
    },
    {
      head = "movement",
      maps = {
        { "character" },
        { "[n]h/<ctrl-h> [n]j/<ctrl-j> [n]k/<ctrl-k> [n]l/<ctrl-l>", "← ↓ ↑ →", mode_n_v_o_i },
        { "[n]w/<ctrl-f> [n]W", "[n] word|WORD forward", mode_n_v_o_i },
        { "[n]e [n]E", "forward to the end of word|WORD [n]", mode_n_v_o },
        { "[n]b/<ctrl-b> [n]B", "[n] word|WORD backward", mode_n_v_o_i },
        { "gh/<ctrl-B> gl/<ctrl-f>", "goto first(forward)|last(backward) column of the line", mode_n_v_o_i },
        { "gH/<ctrl-b> gL/<ctrl-F>", "goto first(forward)|last(backward) non-blank character", mode_n_v_o_i },

        { "file" },
        { "{n}%", "jump to {n} percentage in the file", mode_n_v_o },
        { "gg ge/G", "goto first|last line in file", mode_n_v_o },
        { "gt gc gb", "goto top|centre|bottom of the window", mode_n_v_o },
        { "ga", "goto last access file", mode_n },
        { "gm", "goto last modified file", mode_n },
        { "[n][d [n]d", "goto [n] previous|next diagnostics", mode_n_v_o },

        { "sentence-paragraph" },
        { "[n]( [n])", "[n] sentences backward|forward", mode_n_v_o },
        { "[n]{ [n]}", "[n] paragraph backward|forward", mode_n_v_o },

        { "symbol-pair" },
        { "[n][( [n]])", "goto [n] previous|next unclosed ()", mode_n_v_o },
        { "[n][{ [n]]}", "goto [n] previous|next unclosed {}", mode_n_v_o },
        { "gp", "find and jump next <>|()|{}|[]|/**/ pair", mode_n_v_o },

        { "jumplist" },
        { "<ctrl-o>", "goto prev jump position", mode_n_v },
        { "<ctrl-i>", "goto next jump position", mode_n_v },

        { "changelist" },
        { "g.", "goto last change position", mode_n_v_o },
        { "g;", "goto prev change position", mode_n },
        { "g,", "goto next change position", mode_n },
      }
    },
    {
      head = "scroll",
      maps = {
        { "buffer-file" },
        { "<ctrl-d> <ctrl-u>", "scroll upwards|downwards", mode_n_v },
        { "<ctrl-b>/<pageup> <ctrl-f>/<pagedown>", "scroll pageup|pagedown", mode_n_v },

        { "screen-window" },
        { "[n]H [n]J [n]K [n]L", "move screen [n] lines upwards|downwards", mode_n_v },
        { "zz", "move screen line at center", mode_n_v },
        { "zj zk", "move screen line at bottom|top of screen", mode_n_v },
        { "[n]zh [n]zl", "scroll screen half screen to the left|right", mode_n_v },
        { "ze zs", "scroll text horizontally to move cursor to the start|end", mode_n_v },
      }
    },
    {
      head = "edit",
      maps = {
        { "append-insert" },
        { "a i", "insert before|after the cursor", mode_n },
        { "A I", "edit in first|last non-blank-character of the line|selection", mode_n_v },
        { "gA gI", "edit in the last|first column of the line", mode_n },
        { "o O", "begin a new line below|above the cursor", mode_n },

        { "yank-paste" },
        { "[\"r]y{motion} [\"r]Y", "yank by {motion}|character|selection", mode_n_v },
        { "[\"r]p [\"r]P", "paste in after-cursor|before-cursor|selection", mode_n_v },

        { "delete-change" },
        { "[\"r]d{motion} [\"r]D", "delete by {motion}|character|selection and save in clipboard", mode_n_v },
        { "[\"r]x{motion} [\"r]X", "delete by {motion}|character|selection", mode_n_v },
        { "[\"r]c{motion} [\"r]C", "change by {motion}|character|selection and save in clipboard", mode_n_v },
        { "<backspace>", "delete one character before the cursor", mode_i },
        { "r{char}", "replace one-character|selection with {char}", mode_n_v },
        { "R{chars}", "enter replace mode", mode_n },

        { "format-indent" },
        { "<{motion} >{motion}", "shift {motion}|selection one `shiftwidth` leftwards|rightwards", mode_n_v },
        { "fq{motion}", "format {motion}|selection", mode_n_v },
        { "fQ", "format current buffer", mode_n },
        { "[n:2]fj [n:2]fJ", "join current-line|selection with [n], without space", mode_n_v },

        { "comment" },
        { "fc{motion}", "linewise comment {motion}|selection", mode_n_v },
        { "c", "linewise comment current line; only work for {fc} prefix", mode_o },
        { "o", "linewise comment below line; only work for {fc} prefix", mode_o },
        { "O", "linewise comment above line; only work for {fc} prefix", mode_o },
        { "A", "linewise comment end line; only work for {fc} prefix", mode_o },
        { "fb{motion}", "blockwise comment {motion}|selection", mode_n_v },
        { "b", "blockwise comment current line; only work for {fb} prefix", mode_o },

        { "change" },
        { "u U", "undo|redo change", mode_n },
        { "[n]f<ctrl-a> [n]f<ctrl-x>", "find number in current-line|selection and increment|decrement by [n]", mode_n_v },
        { "<ctrl-o>{command}", "execute {command} and return to insert mode", mode_i },
        { "<ctrl-r>{register}", "insert the contents of a {register}", mode_i },
        { "<ctrl-t>", "insert previous insert text", mode_i },
        { "fu{motion} fU{motion}", "convert {motion}|selection to lowercase|uppercase", mode_n_v },
        { ".", "repeat last change", mode_n },

        { "record-macro" },
        { "t{0-9a-zA-Z\"}", "record typed characters into register {}", mode_n },
        { "[n]T", "replay [n:1] times last recorded register", mode_n },
        { "[n]@{0-9a-zA-Z\"}", "replay [n:1] times record in register {0-9a-zA-Z\"}", mode_n },

        { "completion" },
        { "<ctrl-n> <ctrl-p>", "insert next|prev match of identifier before the cursor", mode_i },
        -- { "<ctrl-e> <ctrl-y>", "insert the character from below|above the cursor", mode_i }, -- AA
      }
    },
    {
      head = "search",
      maps = {
        { "search" },
        { "s", "search and jump by char2", mode_n_v },
        { "S", "search and jump by word", mode_n_v },
        { "[n]f{char} [n]F{char}", "find next|previous occurrence of {char}", mode_v_o },
        { "[n]t{char} [n]T{char}", "till next|previous occurrence of {char}", mode_v_o },
        -- { "[n]; [n],", "repeat [n] last fFtT in the same, opposite direction", mode_n_v }, -- 使用了 hop.nvim 替换了 ft，故不支持该功能
        { "/[\\<]{pattern}[\\>]<CR>", "search by pattern", mode_n },
        { "'", "clear search pattern", mode_n_v },
        { "?", "search by <cword>|selection", mode_n_v },
        { "n", "jump to the next matching search", mode_n_v },
        { "N", "jump to the prev matching search", mode_n_v },

        { "replace" },
        { ":[range]s@{search}@{replace}@[flags] [n]", "substitute", mode_c },
      }
    },
    {
      head = "window",
      maps = {
        { "jump" },
        { "<ctrl-h> <ctrl-j> <ctrl-k> <ctrl-l>", "goto window ← ↓ ↑ →", mode_n },
        { "<ctrl-w>p{id}", "goto specify {id} window", mode_n },

        { "close" },
        { "<ctrl-w>c", "close current window", mode_n },
        { "<ctrl-w>o", "close all windows except current", mode_n },

        { "split" },
        { "<ctrl-w>s", "split window horizontally", mode_n },
        { "<ctrl-w>v", "split window vertically", mode_n },

        { "adjust" },
        { "[n]+ [n]_", "increase, decrease window height [n:1] lines", mode_n },
        { "[n]= [n]-", "increase, decrease window width [n:1] columns", mode_n },
        { "<ctrl-w><LEFT> <ctrl-w><RIGHT> <ctrl-w><UP> <ctrl-w><DOWN>", "move window to the left, right, top, bottom, ", mode_n },
        { "<ctrl-w>g", "set all windows the same height, width", mode_n },
        { "<ctrl-w>f", "fold all windows except current", mode_n },
      }
    },
    {
      head = "tabpage",
      maps = {
        { "[t ]t", "switch to prev, next tabpage", mode_n },
        { "<ctrl-t>t/n", "new tabpage", mode_n },
        { "<ctrl-t>c", "close current tabpage", mode_n },
        { "<ctrl-t>o", "close tabpages except current", mode_n },
      }
    },
    {
      head = "fold",
      maps = {
        { "set" },
        { "zf{motion}", "define a fold manually", mode_n_v },

        { "open-close" },
        { "zo zO", "open fold under the cursor, recursively", mode_n_v },
        { "zc zC", "close fold under the cursor, recursively", mode_n_v },
        { "za zA", "toggle the fold under the cursor, recursively", mode_n_v },
        { "zv", "open just enough folds", mode_n_v },
        { "zM zR", "close, open all folds and set `foldlevel` to 0, highest level", mode_n_v },

        { "delete" },
        { "zd zD", "delete fold under the cursor, recursively", mode_n_v },
        { "zE", "eliminate all folds in the window", mode_n_v },

        { "goto" },
        { "[Z ]Z", "goto next, previous fold", mode_n_v }, -- 
        { "[z ]z", "goto the start, end of the current open fold", mode_n_v }, -- 

        { "enable-disable" },
        { "zn zN", "reset, set `foldenable`", mode_n_v },
        { "zi", "invert `foldenable`", mode_n_v },
      },
    },
    {
      head = "selection",
      maps = {
        { "v{motion}", "enter visual charwise mode", mode_n },
        { "V{motion}", "enter visual linewise mode", mode_n },
        { "<ctrl-v>{motion}", "enter visual blockwise mode", mode_n },
        { "gv", "reselect|switch to the previous visual area", mode_n_v },
        { "o O", "horizontally, move cursor to opposite corner of selection area", mode_v },
      }
    },
    {
      head = "textobject",
      maps = {
        { "[n]iw [n]aw", "inner|a word", mode_o },
        { "[n]iW [n]aW", "inner|a WORD", mode_o },
        { "[n]is [n]as", "inner|a sentence", mode_o },
        { "[n]ip [n]ap", "inner|a paragraph", mode_o },
        { "[n]i[ [n]a[", "inner|a [...] block; paired as synonyms `]`", mode_o },
        { "[n]i< [n]a<", "inner|a <...> block; paired as synonyms `>`", mode_o },
        { "[n]ib [n]ab", "inner|a (...) block; paired as synonyms `(`, `)`", mode_o },
        { "[n]iB [n]aB", "inner|a {...} block; paired as synonyms `{`, `}`", mode_o },
        { "i\" a\""    , "inner|a \"...\" block", mode_o },
        { "i' a'"      , "inner|a '...' block", mode_o },
        { "i` a`"      , "inner|a `...` block", mode_o },
        { "if af"      , "inner|a function", mode_o },
      }
    },
    {
      head = "utils",
      maps = {
        { "<leader>f", "show file info", mode_n },
        { "<alt>q", "quit", mode_n },
      }
    },
    {
      head = "commands",
      maps = {
        { ":jumps", "open jump list", mode_c },
        { ":cle[arjumps]", "clear jump list", mode_c },
        { ":reg", "open register list", mode_c },
        { ":changes", "open change list", mode_c },
        { ":w[rite] [path:current] [++p]", "write file into [path:current] with [++opt]", mode_c },
        { ":ene", "create new [No Name] buffer", mode_c },
      }
    },
    {
      head = "git(hunk)",
      maps = {
        { "<leader>hd", "toggle current buffer gitdiff", mode_n },
        { "<leader>hr", "reset current hunk", mode_n },
        { "<leader>hR", "reset current buffer", mode_n },
        { "<leader>hb", "show current line blame", mode_n },
        { "<leader>hp", "show current line preview", mode_n },
        { "[h ]h", "goto previous|next hunk", mode_n_v_o },
      }
    },
    {
      head = "explorer",
      maps = {
        { "<ctrl-r>", "reload", mode_n },
        { "f", "start live-filter", mode_n },
        { "F", "clear live-filter", mode_n },
        { "E", "expand all", mode_n },
        { "W", "collapse all", mode_n },
        { "i", "file info", mode_n },
        { ".", "run command", mode_n },
        { "{", "firsh sibling", mode_n },
        { "}", "last sibling", mode_n },
        { "<", "next sibling", mode_n },
        { ">", "previous sibling", mode_n },
        { "M", "clear all bookmark", mode_n },
        { "<TAB>", "toggle bookmark", mode_n },
        { "md", "delete bookmark", mode_n },
        { "mv", "move bookmark", mode_n },
        { "[h ]h", "next/prev git", mode_n },
        { "[d ]d", "next/prev diagnostic", mode_n },
        { "r", "rename", mode_n },
        { "R", "rename full path", mode_n },
        { "a", "create file or directory", mode_n },
        { "c", "copy", mode_n },
        { "C", "clear clipboard", mode_n },
        { "d", "cut", mode_n },
        { "x", "delete", mode_n },
        { "y", "yank file name", mode_n },
        { "Y", "yank absolute path", mode_n },
        { "p", "paste", mode_n },
        { "tg", "toggle gitignore filter", mode_n },
        { "th", "toggle hidden filter", mode_n },
        { "tb", "toggle nobuffer filter", mode_n },
        { "tm", "toggle nobook filter", mode_n },
        { "T", "clear toggled filter", mode_n },
        { "<BACKSPACE>", "close directory", mode_n },
        { "<CR>", "open", mode_n },
        { "o", "open", mode_n },
        { "O", "close directory", mode_n },
        { "<ctrl-o>t", "open to new tabpage", mode_n },
        { "<ctrl-o>v", "open to new vertical split window", mode_n },
        { "<ctrl-o>s", "open to new horizontal split window", mode_n },
        { "<ctrl-f>", "scroll forward preview window", mode_n },
        { "<ctrl-b>", "scroll backward preview window", mode_n },
        { "`", "toggle focus preview window", mode_n },
        { "<ctrl-s>", "preview file", mode_n },
        { "<ctrl-shift-s>", "watch file", mode_n },
      }
    },
  }

  local win_hl_ns

  function this:__init()
    vim.api.nvim_set_hl(0, "CheatsheetCard", { bg = vim.__color.dark1 })
    vim.api.nvim_set_hl(0, "CheatsheetCardSeparator", { bg = vim.__color.dark1, italic = true, bold = true, fg = vim.__color.gray})
    vim.api.nvim_set_hl(0, "CheatsheetCardTitle", { bg = vim.__color.light2, fg = vim.__color.dark0, })
    vim.api.nvim_set_hl(0, "CheatsheetAscii", { fg = vim.__color.bright_yellow })
    vim.api.nvim_set_hl(0, "CheatsheetTips", { italic = true, bold = true, fg = vim.__color.gray })
    vim.api.nvim_set_hl(0, "CheatsheetGreen", { fg = vim.__color.bright_green })
    vim.api.nvim_set_hl(0, "CheatsheetAqua", { fg = vim.__color.bright_aqua })
    vim.api.nvim_set_hl(0, "CheatsheetYellow", { fg = vim.__color.bright_yellow })
    vim.api.nvim_set_hl(0, "CheatsheetBlue", { fg = vim.__color.bright_blue })
    vim.api.nvim_set_hl(0, "CheatsheetRed", { fg = vim.__color.bright_red })
    vim.api.nvim_set_hl(0, "CheatsheetPurple", { fg = vim.__color.bright_purple })
    vim.api.nvim_set_hl(0, "CheatsheetOrange", { fg = vim.__color.bright_orange })
    vim.api.nvim_set_hl(0, "CheatsheetNeutralRed", { fg = vim.__color.neutral_red })
    vim.api.nvim_set_hl(0, "CheatsheetNeutralGreen", { fg = vim.__color.neutral_green })
    vim.api.nvim_set_hl(0, "CheatsheetNeutralYellow", { fg = vim.__color.neutral_yellow })
    vim.api.nvim_set_hl(0, "CheatsheetNeutralBlue", { fg = vim.__color.neutral_blue })
    vim.api.nvim_set_hl(0, "CheatsheetNeutralPurple", { fg = vim.__color.neutral_purple })
    vim.api.nvim_set_hl(0, "CheatsheetNeutralAqua", { fg = vim.__color.neutral_aqua })

    win_hl_ns = vim.api.nvim_create_namespace("cheatsheet_win")
    vim.api.nvim_set_hl(win_hl_ns, "CursorLine", { bg = vim.__color.dark0_soft })

    vim.__autocmd.augroup("cheatsheet"):on("WinResized", function(_)
      if vim.bo.ft ~= "cheatsheet" then
        return
      end

      this:show(true)
    end)
  end

  local active_buf = -1
  function this:show(refresh)
    if active_buf > 0 then
      local buf = active_buf
      active_buf = -1

      vim.schedule(function ()
        vim.cmd("bwipeout! " .. buf)
      end)

      if not refresh then
        return
      end
    end

    local nsid = vim.api.nvim_create_namespace("cheatsheet")
    local mappings_tb = builtin_keymaps

    active_buf = vim.api.nvim_create_buf(false, true)

    local buf = active_buf

    local tbline_height = #vim.o.tabline == 0 and -1 or 0
    vim.api.nvim_open_win(buf, true, {
      row = 1 + tbline_height,
      col = 0,
      width = vim.o.columns,
      height = vim.o.lines - (3 + tbline_height),
      relative = "editor",
    })

    local win = vim.api.nvim_get_current_win()
    vim.wo[win].winhl = "NormalFloat:Normal"

    vim.api.nvim_set_current_win(win)
    vim.api.nvim_win_set_hl_ns(win, win_hl_ns)

    local winwidth = vim.api.nvim_win_get_width(win)

    -- add left padding (strs) to ascii so it looks centered
    local ascii_header = vim.tbl_values(ascii)
    local ascii_header_size = #ascii_header

    local ascii_padding = (winwidth / 2) - (#ascii_header[1] / 2) - vim.wo.numberwidth - 1
    for i = 1, ascii_header_size do
      ascii_header[i] = string.rep(" ", ascii_padding) .. ascii_header[i]
    end

    -- set ascii
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, ascii_header)

    local tips_header = vim.tbl_values(tips)
    local tips_header_size = #tips_header

    local tips_padding = 0
    -- local tips_padding = (winwidth / 2) - (#tips_header[1] / 2) - vim.wo.numberwidth - 1
    -- for i = 2, tips_header_size do
    --   local padding = (winwidth / 2) - (#tips_header[i] / 2) - vim.wo.numberwidth - 1
    --   if tips_padding > padding then
    --     tips_padding = padding
    --   end
    -- end
    -- tips_padding = tips_padding > 0 and tips_padding or 0
    for i = 1, tips_header_size do
      tips_header[i] = string.rep(" ", tips_padding) .. tips_header[i]
    end

    -- set tips
    vim.api.nvim_buf_set_lines(buf, ascii_header_size, -1, false, tips_header)

    -- column width
    local column_width = 0
    for _, section in ipairs(mappings_tb) do
      for _, mapping in ipairs(section.maps) do
        local text = mapping[1]
        if mapping[2] then
          text = text .. mapping[2]
        end

        local width = vim.__str.displaywidth(text)
        column_width = column_width > width and column_width or width
      end
    end

    -- 10 = space between mapping txt , 4 = 2 & 2 space around mapping txt
    column_width = column_width + 10

    local win_width = vim.o.columns - vim.fn.getwininfo(win)[1].textoff - 4

    local columns_qty = math.floor(win_width / column_width)
    columns_qty = (win_width / column_width < 10 and columns_qty == 0) and 1 or columns_qty

    column_width = math.floor((win_width - (column_width * columns_qty)) / columns_qty) + column_width

    -- add mapping tables with their headings as key names
    local cards = {}
    local card_headings = {}
    local card_separator = {}

    local mode_lines = {}

    for _, section in ipairs(mappings_tb) do
      local name = section.head

      local padding_left = math.floor((column_width - vim.__str.displaywidth(name)) / 2)

      -- center the heading
      name = string.rep(" ", padding_left) .. name .. string.rep(" ", column_width - vim.__str.displaywidth(name) - padding_left)
      table.insert(card_headings, name)

      cards[name] = {}

      local max_modes = 0
      for _, mapping in ipairs(section.maps) do
        if mapping[3] then
          local width = #mapping[3]
          max_modes = max_modes < width and width or max_modes
        end
      end

      for _, mapping in ipairs(section.maps) do
        table.insert(cards[name], string.rep(" ", column_width))

        if #mapping == 1 then
          local text = mapping[1]
          if text == "" then
            text = "⎼"
          end

          text = "  " .. text .. (text == "⎼" and "" or " ")
          text = text .. string.rep("⎼", column_width - vim.__str.displaywidth(text) - 2) .. "  "

          table.insert(cards[name], text)

          card_separator[text] = true
        else
          local mode_str = ""
          local mode_start = 2
          if mapping[3] then
            local t = {}
            for _, mode in ipairs(mapping[3] or {}) do
              table.insert(t, mode.text)
            end

            local mode_count = #mapping[3]
            mode_str = string.rep(" ", max_modes - mode_count) .. table.concat(t) .. " "
            mode_start = mode_start + max_modes - mode_count
          end

          local mapping_1 = mode_str .. mapping[1]
          local mapping_2 = mapping[2]

          local whitespace_len = column_width - 4 - vim.__str.displaywidth(mapping_1 .. mapping_2)
          local pretty_mapping = mapping_1 .. string.rep(" ", whitespace_len) .. mapping_2

          local text = "  " .. pretty_mapping .. "  "

          if mapping[3] then
            mode_lines[text] = { modes = mapping[3], start = mode_start }
          end
          table.insert(cards[name], text)
        end
      end

      table.insert(cards[name], string.rep(" ", column_width))
      table.insert(cards[name], string.rep(" ", column_width))
    end

    -- divide cheatsheet layout into columns
    local columns = {}

    for i = 1, columns_qty, 1 do
      columns[i] = {}
    end

    local function getColumn_height(tb)
      local res = 0

      for _, value in pairs(tb) do
        res = res + #value + 1
      end

      return res
    end

    local function append_table(tb1, tb2)
      for _, val in ipairs(tb2) do
        tb1[#tb1 + 1] = val
      end
    end

    -- imitate masonry layout
    for _, heading in ipairs(card_headings) do
      for column, mappings in ipairs(columns) do
        if column == 1 and getColumn_height(columns[1]) == 0 then
          columns[1][1] = card_headings[1]
          append_table(columns[1], cards[card_headings[1]])
          break
        elseif
          column == 1
          and (
            getColumn_height(mappings) < getColumn_height(columns[#columns])
            or getColumn_height(mappings) == getColumn_height(columns[#columns])
          )
        then
          columns[column][#columns[column] + 1] = heading
          append_table(columns[column], cards[heading])
          break
        elseif column ~= 1 and (getColumn_height(columns[column - 1]) > getColumn_height(mappings)) then
          if not vim.__tbl.contains(columns[1], heading) then
            columns[column][#columns[column] + 1] = heading
            append_table(columns[column], cards[heading])
          end
          break
        end
      end
    end

    local longest_column = 0
    for _, value in ipairs(columns) do
      longest_column = longest_column > #value and longest_column or #value
    end

    local max_col_height = 0

    -- get max_col_height
    for _, value in ipairs(columns) do
      max_col_height = max_col_height < #value and #value or max_col_height
    end

    -- fill empty lines with whitespaces
    -- so all columns will have the same height
    for i, _ in ipairs(columns) do
      for _ = 1, max_col_height - #columns[i], 1 do
        columns[i][#columns[i] + 1] = string.rep(" ", column_width)
      end
    end

    local result = vim.tbl_values(columns[1])

    -- merge all the column strings
    for index, value in ipairs(result) do
      local line = value

      for col_index = 2, #columns, 1 do
        line = line .. "  " .. columns[col_index][index]
      end

      result[index] = line
    end

    -- set columns
    local lnum = ascii_header_size + tips_header_size
    vim.api.nvim_buf_set_lines(buf, lnum, -1, false, result)

    for i = 0, max_col_height, 1 do
      for column_i, _ in ipairs(columns) do
        local col_start = column_i == 1 and 0 or (column_i - 1) * column_width + ((column_i - 1) * 2)

        local text = columns[column_i][i]
        if text then
          -- highlight headings & one line after it
          if cards[text] ~= nil then
            local lines = vim.api.nvim_buf_get_lines(buf, i + lnum - 1, i + lnum + 1, false)
            -- highlight area around card heading
            vim.api.nvim_buf_add_highlight(
              buf,
              nsid,
              "CheatsheetCard",
              i + lnum - 1,
              vim.fn.byteidx(lines[1], col_start),
              vim.fn.byteidx(lines[1], col_start)
                + column_width
                + vim.fn.strlen(text)
                - vim.__str.displaywidth(text)
            )
            -- highlight card heading & randomize hl groups for colorful vim.__color
            vim.api.nvim_buf_add_highlight(
              buf,
              nsid,
              "CheatsheetCardTitle",
              i + lnum - 1,
              vim.fn.stridx(lines[1], vim.trim(text), col_start) - 1,
              vim.fn.stridx(lines[1], vim.trim(text), col_start)
                + vim.fn.strlen(vim.trim(text))
                + 1
            )
            vim.api.nvim_buf_add_highlight(
              buf,
              nsid,
              "CheatsheetCard",
              i + lnum,
              vim.fn.byteidx(lines[2], col_start),
              vim.fn.byteidx(lines[2], col_start) + column_width
            )

          -- highlight mappings & one line after it
          elseif string.match(text, "%s+") ~= text then
            local lines = vim.api.nvim_buf_get_lines(buf, i + lnum - 1, i + lnum + 1, false)

            local hl = "CheatsheetCard"
            if card_separator[text] then
              hl = "CheatsheetCardSeparator"
            end

            local text_idx = vim.fn.stridx(lines[1], text, col_start)

            vim.api.nvim_buf_add_highlight(
              buf,
              nsid,
              hl,
              i + lnum - 1,
             text_idx,
             text_idx + vim.fn.strlen(text)
            )
            vim.api.nvim_buf_add_highlight(
              buf,
              nsid,
              hl,
              i + lnum,
              vim.fn.byteidx(lines[2], col_start),
              vim.fn.byteidx(lines[2], col_start) + column_width
            )

            if mode_lines[text] then
              local mode_start = mode_lines[text].start
              local mode_end = mode_start + mode_lines[text].modes[1].text_len - 1
              for _, mode in ipairs(mode_lines[text].modes or {}) do
                vim.api.nvim_buf_add_highlight(
                  buf,
                  nsid,
                  mode.hl,
                  i + lnum - 1,
                  text_idx + mode_start,
                  text_idx + mode_end
                )

                mode_start = mode_start + mode.text_len
                mode_end = mode_start + mode.text_len - 1
              end
            end
          end
        end
      end
    end

    -- set highlights for ascii header
    for i = 0, ascii_header_size - 1 do
      vim.api.nvim_buf_add_highlight(buf, nsid, "CheatsheetAscii", i, 0, -1)
    end

    -- set highlights for tips
    for i = 0, tips_header_size - 1 do
      vim.api.nvim_buf_add_highlight(buf, nsid, "CheatsheetTips", ascii_header_size + i, math.floor(tips_padding), -1)
    end

    vim.api.nvim_set_current_buf(buf)
    vim.opt_local.buflisted = false
    vim.opt_local.modifiable = false
    vim.opt_local.buftype = "nofile"
    vim.opt_local.number = false
    vim.opt_local.list = false
    vim.opt_local.wrap = false
    vim.opt_local.relativenumber = true
    vim.opt_local.cursorline = true
    vim.opt_local.colorcolumn = "0"
    vim.opt_local.foldcolumn = "0"
    vim.opt_local.filetype = "cheatsheet"

    vim.__key.rg(vim.__key.e_mode.N, "q", function()
      active_buf = -1
      vim.cmd("bwipeout! " .. buf)
    end, { buffer = buf })
  end
end)

local M = {}

-- +-------------------------------------------------------------------+
-- | Mode           | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang |
-- | Command        +------+-----+-----+-----+-----+-----+------+------+
-- | [nore]map      | yes  |  -  |  -  | yes | yes | yes |  -   |  -   |
-- | n[nore]map     | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
-- | [nore]map!     |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
-- | i[nore]map     |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
-- | c[nore]map     |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
-- | v[nore]map     |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
-- | x[nore]map     |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
-- | s[nore]map     |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
-- | o[nore]map     |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
-- | t[nore]map     |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
-- | l[nore]map     |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |
-- +-------------------------------------------------------------------+
M.e_mode = {
  NVSO = "",
  N    = "n",
  VS   = "v",
  I    = "i",
  S    = "s",
  C    = "c",
  V    = "x",
  T    = "t",
  O    = "o",
}

function M.list(mode, bufnr)
  if bufnr then
    return vim.api.nvim_buf_get_keymap(bufnr, mode)
  else
    return vim.api.nvim_get_keymap(mode)
  end
end

function M.get(mode, lhs, bufnr)
  if bufnr ~= nil then
    for _, mapagr in ipairs(vim.api.nvim_buf_get_keymap(bufnr, mode)) do
      if mapagr.lhs == lhs then
        return mapagr
      end
    end
  else
    for _, mapagr in ipairs(vim.api.nvim_get_keymap(mode)) do
      if mapagr.lhs == lhs then
        return mapagr
      end
    end
  end

  return nil
end

function M.hide(mode, key, opts)
  vim.keymap.set(mode, key, function() end, opts or {})
end

function M.unrg(mode, key, opts)
  vim.keymap.set(mode, key, "<NOP>", opts or {})
end

function M.del(mode, key, opts)
  vim.keymap.del(mode, key, opts)
end

function M.rg(mode, lhs, rhs, opts)
  -- fix rhs variable
  if (vim.__util.is_fwrapper(rhs)) then
    local wrapper = rhs
    rhs = function(...)
      wrapper(...)
    end
  end

  vim.keymap.set(mode, lhs, rhs, opts or {})
end

function M.feed(key, mode)
  -- https://neovim.io/doc/user/builtin.html#feedkeys()
  mode = mode or "n"

  -- maybe involve some async logic
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), mode, false)
end

function M.press(key)
  pcall(vim.cmd, "normal! " .. key)
end

function M.resolve(spec)
  local success, module = pcall(require, "lazy.core.handler.keys")
  assert(success)
  assert(module.resolve)
  module.resolve(spec)
end

vim.__event.rg(vim.__event.types.COLOR_SCHEME, function()
  M.cheatsheet = Cheatsheet:new()
end)

return M
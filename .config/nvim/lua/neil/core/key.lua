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
    "7. picker usage",
    "│",
    "├╴ the picker for grep is divided into `live` and `non-live` modes, which can be switched by pressing the specified key.",
    "│",
    "├╴ in live-mode, we specify the query parameters by adding the `--` suffix.",
    "│    * hello -- --fixed-strings",
    "│    * hello -- --type=lua --glob=!*.lua --iglob=src/hello/world/*",
    "│    * hello -- --exclude=src/hello/world",
    "│",
    "╰╴ non-live mode not support `--` suffix but it does support some new syntax. check out: https://junegunn.github.io/fzf/search-syntax/",
    "",
  }

  local mode_n = { key_modes.n }
  local mode_v = { key_modes.v }
  local mode_i = { key_modes.i }
  local mode_c = { key_modes.c }
  local mode_n_i = { key_modes.n, key_modes.i }
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
      head = "movement",
      maps = {
        { "character && line" },
        { "[N]h", "←", mode_n_v_o_i },
        { "[N]j", "↓", mode_n_v_o_i },
        { "[N]k", "↑", mode_n_v_o_i },
        { "[N]l", "→", mode_n_v_o_i },
        { "[N]w", "[N] word forward", mode_n_v_o_i },
        { "[N]W", "[N] WORD forward", mode_n_v_o },
        { "[N]e", "forward to the end of word [N]", mode_n_v_o_i },
        { "[N]E", "forward to the end of WORD [N]", mode_n_v_o },
        { "[N]b", "[N] word backward", mode_n_v_o },
        { "[N]B", "[N] WORD backward", mode_n_v_o },
        { ";", "goto first non-blank-character|column of the line", mode_n_v_o_i },
        { "'", "goto last non-blank-character|column of the line", mode_n_v_o_i },
        { "<ctrl-d>", "scroll downwards", mode_n_v },
        { "<ctrl-u>", "scroll upwards", mode_n_v },
        { "<pageup>", "scroll pageup", mode_n_v },
        { "<pagedown>", "scroll pagedown", mode_n_v },
        { "{N}%", "jump {N} percentage in the file", mode_n_v_o },
        { "[N](", "[N] sentences backward", mode_n_v_o },
        { "[N])", "[N] sentences forward", mode_n_v_o },
        { "[N]{", "[N] paragraph backward", mode_n_v_o },
        { "[N]}", "[N] paragraph forward", mode_n_v_o },
        { "[N]H", "move screen ←", mode_n_v },
        { "[N]J", "move screen ↓", mode_n_v },
        { "[N]K", "move screen ↑", mode_n_v },
        { "[N]L", "move screen →", mode_n_v },
        { "zz", "move screen line at center", mode_n_v },
        { "zj", "move at top of screen line", mode_n_v },
        { "zk", "move at bottom of screen line", mode_n_v },
        { "[N]zh", "scroll screen half screen to the left", mode_n_v },
        { "[N]zl", "scroll screen half screen to the right", mode_n_v },
        { "ze", "scroll text horizontally to move cursor to the end", mode_n_v },
        { "zs", "scroll text horizontally to move cursor to the start", mode_n_v },

        { "pair" },
        { "[N][(", "goto [N] previous unclosed ()", mode_n_v_o },
        { "[N]])", "goto [N] next unclosed ()", mode_n_v_o },
        { "[N][{", "goto [N] previous unclosed {}", mode_n_v_o },
        { "[N]]}", "goto [N] next unclosed {}", mode_n_v_o },
        { "gp", "goto unclosed <>|()|{}|[]|/**/", mode_n_v_o },

        { "object" },
        { "[f", "goto previous function", mode_n_v_o },
        { "]f", "goto next function", mode_n_v_o },
        { "[c", "goto previous class", mode_n_v_o },
        { "]c", "goto next class", mode_n_v_o },
        { "[o", "goto previous condition", mode_n_v_o },
        { "]o", "goto next condition", mode_n_v_o },
        { "[O", "goto previous loop", mode_n_v_o },
        { "]O", "goto next loop", mode_n_v_o },
        { "[[", "goto previous illuminate", mode_n_v_o },
        { "]]", "goto next illuminate", mode_n_v_o },

        { "jumplist" },
        { "<ctrl-o>", "goto prev jump position", mode_n },
        { "<ctrl-i>", "goto next jump position", mode_n },

        { "changelist" },
        { "g.", "goto last change position", mode_n_v_o },
        { "[.", "goto prev change position", mode_n },
        { "].", "goto next change position", mode_n },
      }
    },
    {
      head = "selection",
      maps = {
        { "v", "enter visual charwise mode", mode_n },
        { "V", "enter visual linewise mode", mode_n },
        { "<ctrl-v>", "enter visual blockwise mode", mode_n },
        { "gv", "reselect to the previous visual area", mode_n_v },
        { "o", "move cursor to opposite corner of selection area", mode_v },
        { "O", "horizontally move cursor to opposite corner of selection area", mode_v },
      }
    },
    {
      head = "edit",
      maps = {
        { "insert" },
        { "i", "insert text", mode_n },
        { "a", "append text", mode_n },
        { "I", "edit in last non-blank-character", mode_n_v },
        { "A", "edit in first non-blank-character", mode_n_v },
        { "gI", "edit in the last column", mode_n },
        { "gA", "edit in the first column", mode_n },
        { "o", "edit in below line", mode_n },
        { "O", "edit in above line", mode_n },
        { "<ctrl-o>{command}", "execute {command} and return to insert mode", mode_i },
        { "<ctrl-r>{register}", "insert the contents of a {register}", mode_i },

        { "replace" },
        { "r{char}", "replace with {char}", mode_n_v },
        { "R", "enter replace mode", mode_n },
        { ":[range]s@{search}@{replace}@[flags] [N]", "substitute", mode_c },

        { "macro" },
        { "q{0-9a-zA-Z\"}", "record typed characters into register {}", mode_n },
        { "[N:1]Q", "replay [N] times last recorded register", mode_n },
        { "[N:1]@{0-9a-zA-Z\"}", "replay [N] times record in register {0-9a-zA-Z\"}", mode_n },

        { "multicursor" },
        { "<esc>", "clear all extend cursors", mode_n },
        { "<alt-`>", "place|delete a cursor in current position", mode_n },
        { "<alt-space>", "toggle cursor locked|unlocked mode", mode_n_v },
        { "<alt-.>", "goto next extend cursor", mode_n_v },
        { "<alt-,>", "goto prev extend cursor", mode_n_v },
        { "<alt-d>", "place a cursor below line", mode_n },
        { "<alt-u>", "place a cursor above line", mode_n },
        { "<alt-shift-d>", "skip a cursor below line", mode_n },
        { "<alt-shift-u>", "skip a cursor above line", mode_n },
        { "<alt-n>", "place a cursor in next match", mode_n_v },
        { "<alt-shift-n>", "skip a cursor in next match", mode_n_v },

        { "clipboard" },
        { "[\"r]y{motion}", "yank by {motion}", mode_n_v },
        { "[\"r]Y", "yank character", mode_n_v },
        { "[\"r]p", "paste after", mode_n_v },
        { "[\"r]P", "paste before", mode_n_v },
        { "[\"r]d{motion}", "delete by {motion} and save in clipboard", mode_n_v },
        { "[\"r]D", "delete character and save in clipboard", mode_n_v },
        { "[\"r]x{motion}", "delete by {motion}", mode_n_v },
        { "[\"r]X", "delete character", mode_n_v },
        { "[\"r]c{motion}", "change by {motion} and save in clipboard", mode_n_v },
        { "[\"r]C", "change character and save in clipboard", mode_n_v },

        { "format && indent" },
        { "<{motion}", "shift {motion} one `shiftwidth` leftwards", mode_n_v },
        { ">{motion}", "shift {motion} one `shiftwidth` rightwards", mode_n_v },
        { "fq{motion}", "format by {motion}", mode_n_v },
        { "fQ", "format current buffer", mode_n },
        { "[n:2]fj", "join trim-line with [N]", mode_n_v },
        { "[n:2]fJ", "join current-line with [N]", mode_n_v },

        { "comment" },
        { "fc{motion}", "linewise comment {motion}|selection", mode_n_v },
        { "{fc}c", "linewise comment current line", mode_o },
        { "{fc}o", "linewise comment below line", mode_o },
        { "{fc}O", "linewise comment above line", mode_o },
        { "{fc}A", "linewise comment end line", mode_o },
        { "fb{motion}", "blockwise comment {motion}", mode_n_v },
        { "{fb}b", "blockwise comment current line", mode_o },

        { "change" },
        { ".", "repeat last change", mode_n },
        { "u", "undo change", mode_n },
        { "U", "redo change", mode_n },
        { "fu{motion}", "convert {motion} to lowercase", mode_n_v },
        { "fU{motion}", "convert {motion} to uppercase", mode_n_v },
        { "[N:1]f<ctrl-a>", "add [N] to number", mode_n_v },
        { "[N:1]f<ctrl-x>", "dec [N] to number", mode_n_v },
        { "<shift-backspace>", "delete word backward", mode_i },

        { "completion" },
        { "<ctrl-n>", "select next", mode_i },
        { "<ctrl-p>", "select previout", mode_i },
        { "<ctrl-d>", "select scroll downwards", mode_i },
        { "<ctrl-u>", "select scroll upwards", mode_i },
        { "<tab>", "accept selected|snippet forward", mode_i },
        { "<shift-tab>", "snippet backward", mode_i },
        { "<ctrl-c>", "stop snippet sessions", mode_i },
        { "<ctrl-c>", "hide completion menu", mode_i },
        { "<ctrl-x>", "show completion menu", mode_i },
        { "<ctrl-g>", "show|hide selected document", mode_i },
        { "<ctrl-s>", "show|hide lsp-signature", mode_i },
        { "<ctrl-e>", "scroll forward lsp-signature window", mode_n_i },
        { "<ctrl-y>", "scroll backward lsp-signature window", mode_n_i },

        { "lsp" },
        { "[d", "goto previous diagnostics", mode_n },
        { "]d", "goto next diagnostics", mode_n },
        { "fd", "preview diagnostics", mode_n },
        { "fr", "textDocument/rename", mode_n },
        { "fa", "textDocument/codeAction", mode_n },
        { "fi", "textDocument/signatureHelp", mode_n },
        { "fk", "textDocument/hover", mode_n },
        { "ft", "textDocument/typeHierarchy(clangd)", mode_n },
        { "gr", "textDocument/references", mode_n },
        { "gd", "textDocument/definition", mode_n },
        { "gD", "textDocument/declaration", mode_n },
        { "gi", "textDocument/implementation", mode_n },
        { "gs", "textDocument/switchSourceHeader(clangd)", mode_n },
        { "<ctrl-e>", "scroll forward lsp window", mode_n_i },
        { "<ctrl-y>", "scroll backward lsp window", mode_n_i },
        { "<ctrl-c>", "close lsp window", mode_n },
        { ":ClangdAST", "open clangd ast tree", mode_c },

        { "fold" },
        { "tf{motion}", "define a fold manually", mode_n_v },
        { "td ffD", "delete fold under the cursor, recursively", mode_n_v },
        { "tE", "eliminate all folds in the window", mode_n_v },
        { "to ffO", "open fold under the cursor, recursively", mode_n_v },
        { "tc ffC", "close fold under the cursor, recursively", mode_n_v },
        { "ta ffA", "toggle the fold under the cursor, recursively", mode_n_v },
        { "tv", "open just enough folds", mode_n_v },
        { "tM ffR", "close, open all folds and set `foldlevel` to 0, highest level", mode_n_v },
        { "tj ffk", "goto down, up fold", mode_n_v },
        { "tn ffN", "reset, set `foldenable`", mode_n_v },
        { "ti", "invert `foldenable`", mode_n_v },
      }
    },
    {
      head = "search",
      maps = {
        { "search" },
        { "s", "search and jump char2", mode_n_v },
        { "S", "search and jump word", mode_n_v },
        { "[N]f{char}", "find next occurrence of {char}", mode_v_o },
        { "[N]F{char}", "find previous occurrence of {char}", mode_v_o },
        { "[N]t{char}", "till next occurrence of {char}", mode_v_o },
        { "[N]T{char}", "till previous occurrence of {char}", mode_v_o },
        -- { "[N]; [N],", "repeat [N] last fFtT in the same, opposite direction", mode_n_v }, -- 使用了 hop.nvim 替换了 ft，故不支持该功能
        { "/{pattern}<CR>", "search by {pattern}", mode_n },
        { "<C-/>", "search by cWORD|selection", mode_n_v },
        { "?", "clear search pattern", mode_n_v },
        { "n", "jump to the next matching search", mode_n_v },
        { "N", "jump to the prev matching search", mode_n_v },
      }
    },
    {
      head = "surround(mini.surround)",
      maps = {
        { "fsa{char}", "add {char} surround", mode_v },
        { "fsa{motion}{char}", "add {char} surround by {motion}", mode_n },
        { "fsd{motion}{char}", "del {char} surround by {motion}", mode_n },
        { "fsr{find}{replace}", "replace {find} surround to {replace}", mode_n },
      }
    },
    {
      head = "buffer(barbar.nvim)",
      maps = {
        { "<ctrl-,>", "goto previous buffer", mode_n },
        { "<ctrl-.>", "goto next buffer", mode_n },
        { "<ctrl-<>", "buffer move previous", mode_n },
        { "<ctrl->>", "buffer move next", mode_n },
        { "<ctrl-b>p", "pin buffer", mode_n },
        { "<ctrl-b>g", "goto buffer", mode_n },
        { "<ctrl-b>r", "restore last deleted buffer", mode_n },
        { "<ctrl-b>d", "delete buffer", mode_n },
        { "<ctrl-b>c", "delete selected buffer", mode_n },
        { "<ctrl-b>'", "delete buffers left", mode_n },
        { "<ctrl-b>;", "delete buffers right", mode_n },
        { "<ctrl-b>o", "delete all buffer except current", mode_n },
        { "ga", "goto last access buffer", mode_n },
        { "gf", "goto last modified buffer", mode_n },
      }
    },
    {
      head = "window",
      maps = {
        { "<ctrl-h>", "goto window ←", mode_n },
        { "<ctrl-j>", "goto window ↓", mode_n },
        { "<ctrl-k>", "goto window ↑", mode_n },
        { "<ctrl-l>", "goto window →", mode_n },
        { "<ctrl-w>c", "close current window", mode_n },
        { "<ctrl-w>o", "close all windows except current", mode_n },
        { "<ctrl-w>s", "split window horizontally", mode_n },
        { "<ctrl-w>v", "split window vertically", mode_n },
        { "[N:1]+", "increase window height [N] lines", mode_n },
        { "[N:1]_", "decrease window height [N] lines", mode_n },
        { "[N:1]=", "increase window width [N] columns", mode_n },
        { "[N:1]-", "decrease window width [N] columns", mode_n },
        { "<ctrl-w>z", "set all windows the same height, width", mode_n },
        { "<ctrl-w>f", "fold all windows except current", mode_n },
        { "<ctrl-w><left>", "move window to the left", mode_n },
        { "<ctrl-w><right>", "move window to the right", mode_n },
        { "<ctrl-w><up>", "move window to the top", mode_n },
        { "<ctrl-w><down>", "move window to the bottom", mode_n },
      }
    },
    {
      head = "tabpage",
      maps = {
        { "[t", "switch to prev tabpage", mode_n },
        { "]t", "switch to next tabpage", mode_n },
        { ":tabnew", "new tabpage", mode_c },
        { ":tabclose", "close current tabpage", mode_c },
      }
    },
    {
      head = "textobject(mini.ai)",
      maps = {
        { "scope" },
        { "[N:1]i", "inside", mode_o },
        { "[N:1]a", "around", mode_o },
        { "[N:1]in", "inside next", mode_o },
        { "[N:1]il", "inside last", mode_o },
        { "[N:1]an", "around next", mode_o },
        { "[N:1]al", "around last", mode_o },

        { "target" },
        { "w", "word", mode_o },
        { "W", "cWORD", mode_o },
        { "s", "sentence", mode_o },
        { "p", "paragraph", mode_o },
        { "o", "condiftion", mode_o },
        { "O", "loop", mode_o },
        { "c", "class", mode_o },
        { "f", "function", mode_o },
        { "a", "function argument", mode_o },
        { "F", "function call", mode_o },
        { "c", "class", mode_o },
        { "t", "html-tag", mode_o },
        { "?", "custom left...right block", mode_o },
        { "[]", "[...] block", mode_o },
        { "<>", "<...> block", mode_o },
        { "()", "(...) block", mode_o },
        { "{}", "{...} block", mode_o },
        { "b", "[...] or (...) or {...} block", mode_o },
        { "B", "{...} block", mode_o },
        { "\"", "\"...\" block", mode_o },
        { "'", "'...' block", mode_o },
        { "`", "`...` block", mode_o },
        { "q", "\"...\" '...' `...` block", mode_o },
        { "_", "_..._ block", mode_o },
      }
    },
    {
      head = "bookmark",
      maps = {
        { "[m", "goto previous bookmark", mode_n },
        { "]m", "goto next bookmark", mode_n },
        { "mn{bmid}{alias}", "set new {bmid} bookmark with {alias}", mode_n },
        { "mm{bmid}", "set new {bmid} bookmark", mode_n },
        { "ma{alias}", "set bookmark {alias}", mode_n },
        { "md", "delete current bookmark", mode_n },
        { "mo", "delete all bookmark except current", mode_n },
        { "M", "delete all bookmarks", mode_n },
        { "gm{bmid}", "goto bookmark with {bmid}", mode_n },
        { "m<f1>", "bookmark debug", mode_n },
      }
    },
    {
      head = "picker(snacks.nvim)",
      maps = {
        { "<leader>ff", "open file picker", mode_n },
        { "<leader>fg", "open grep picker", mode_n },
        { "<leader>fG{search}", "open grep picker with {search}", mode_n },
        { "<leader>fd", "open document diagnostic picker", mode_n },
        { "<leader>fD", "open workspace diagnostic picker", mode_n },
        { "<leader>fm", "open bookmark picker", mode_n },
        { "<leader>fs", "open lsp-symbols picker", mode_n },
        { "<leader>fS", "open treesitter picker", mode_n },
        { "<leader>fb", "open buffer picker", mode_n },
        { "<leader>fr", "restore last close picker", mode_n },
        { "<leader>f/", "open lines picker", mode_n },
        { "<leader>f<leader>", "open picker selector", mode_n },

        { "" },
        { "q", "close picker", mode_n },
        { "<alt-q>", "close picker", mode_n_i },
        { "<ctrl-a>", "select all", mode_n_i },
        { "<ctrl-q>", "send all|selected to quickfix", mode_n_i },
        { "<F10>", "toggle maximize", mode_n_i },
        { "<ctrl-r>w", "insert word", mode_i },
        { "<ctrl-r>W", "insert cWORD", mode_i },
        { "<ctrl-r>p", "insert file path", mode_i },
        { "<ctrl-r>l", "insert line", mode_i },
        { "<ctrl-s>", "cycle window", mode_n_i },
        { "<ctrl-o>v", "open in vertical split", mode_n_i },
        { "<ctrl-o>s", "open in horizontal split", mode_n_i },
        { "<ctrl-,>", "history backward", mode_i },
        { "<ctrl-.>", "history forward", mode_i },
        { "<cr>", "open", mode_n_i },
        { "<ctrl-cr>", "open selection in trouble list", mode_n_i },
        { "<F9>", "toggle live-search mode", mode_n_i },
        { "<ctrl-d>", "scroll list downwards", mode_n_i },
        { "<ctrl-u>", "scroll list upwards", mode_n_i },
        { "<ctrl-p>", "previous item", mode_n_i },
        { "<ctrl-n>", "next item", mode_n_i },
        { "k", "previous item", mode_n },
        { "j", "next item", mode_n },
        { "<ctrl-g>", "toggle preview", mode_n_i },
        { "<ctrl-e>", "scroll forward preview window", mode_n_i },
        { "<ctrl-y>", "scroll backward preview window", mode_n_i },
        { "<tab>", "toggle selection and move next", mode_n_i },
        { "<shift-tab>", "toggle selection and move previous", mode_n_i },
        { "G", "goto bottom of list", mode_n },
        { "gg", "goto top of list", mode_n },
        { "a", "focus input", mode_n },
        { "i", "focus input", mode_n },
        { "gb", "goto list scroll bottom", mode_n },
        { "gt", "goto list scroll top", mode_n },
        { "gc", "goto list scroll center", mode_n },
      }
    },
    {
      head = "githunk(gitsigns.nvim)",
      maps = {
        { "<leader>hd", "toggle current buffer gitdiff", mode_n },
        { "<leader>hr", "reset current hunk", mode_n },
        { "<leader>hR", "reset current buffer", mode_n },
        { "<leader>hb", "show current line blame", mode_n },
        { "<leader>hp", "show current line preview", mode_n },
        { "<ctrl-e>", "scroll forward hunk window", mode_n_i },
        { "<ctrl-y>", "scroll backward hunk window", mode_n_i },
        { "<ctrl-c>", "close hunk window", mode_n },
        { "[h ]h", "goto previous|next hunk", mode_n_v },
        { "ih", "inner hunk", mode_o },
      }
    },
    {
      head = "explorer(nvim-tree.nvim)",
      maps = {
        { "<leader>e", "open explorer", mode_n },
        { "q", "close explorer", mode_n },
        { "<ctrl-r>", "reload", mode_n },
        { "=", "resize+", mode_n },
        { "-", "resize-", mode_n },

        { "" },
        { "o", "open", mode_n },
        { "O", "close directory", mode_n },
        { "E", "expand all", mode_n },
        { "W", "collapse all", mode_n },
        { "<CR>", "open", mode_n },
        { "<backspace>", "close directory", mode_n },
        { "<ctrl-o>v", "open in vertical split", mode_n },
        { "<ctrl-o>s", "open in horizontal split", mode_n },
        { "<ctrl-g>", "toggle preview", mode_n },
        { "<ctrl-e>", "scroll forward preview window", mode_n },
        { "<ctrl-y>", "scroll backward preview window", mode_n },
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
        { "F", "clear all selection", mode_n },
        { "ff", "toggle selection", mode_n },
        { "fd", "delete selection", mode_n },
        { "fm", "move selection", mode_n },
        { "fp", "paste selection", mode_n },
        { "i", "file info", mode_n },
        { ".", "run command", mode_n },
        { "{", "firsh sibling", mode_n },
        { "}", "last sibling", mode_n },
        { "<", "next sibling", mode_n },
        { ">", "previous sibling", mode_n },
        { "[h ]h", "next/prev git", mode_n },
        { "[d ]d", "next/prev diagnostic", mode_n },
      }
    },
    {
      head = "trouble(trouble.nvim)",
      maps = {
        { "<leader>tt", "open troublelist selector", mode_n },
        { "<leader>tm", "open bookmark list", mode_n },
        { "<leader>tf", "open picker list", mode_n },
        { "<leader>tb", "open buffer list", mode_n },
        { "<leader>td", "open document diagnostic list", mode_n },
        { "<leader>tD", "open workspace diagnostic list", mode_n },
        { "<leader>ts", "open lsp-symbols list", mode_n },

        { "" },
        { "E", "expand all", mode_n },
        { "W", "collapse all", mode_n },
        { "<cr>", "open and close", mode_n },
        { "o", "open", mode_n },
        { "O", "collapse", mode_n },
        { "r", "refresh", mode_n },
        { "q", "close trouble list", mode_n },
        { "<ctrl-o>v", "open in vertical split", mode_n },
        { "<ctrl-o>s", "open in horizontal split", mode_n },
        { "<ctrl-g>", "toggle preview", mode_n },
        { "<ctrl-e>", "scroll forward preview window", mode_n },
        { "<ctrl-y>", "scroll backward preview window", mode_n },
      },
    },
    {
      head = "misc",
      maps = {
        { "<leader>i", "show file info", mode_n },
        { "<leader>p", "show lazy plugin manager", mode_n },
        { "<leader>P", "show mason package manager", mode_n },
        { "<leader>?", "show cheatsheet", mode_n },

        { ":cdo {command}", "quickfix do {command}", mode_c },
        { ":cdof {command}", "quickfix do file {command}", mode_c },
        { ":jumps", "open jump list", mode_c },
        { ":cle[arjumps]", "clear jump list", mode_c },
        { ":reg", "open register list", mode_c },
        { ":changes", "open change list", mode_c },
        { ":w[rite] [path:current] [++opt]", "write file into [path] with [++opt]", mode_c },
        { ":ene", "create new [No Name] buffer", mode_c },
      }
    },
  }

  function this:__init()
    vim.api.nvim_set_hl(0, "CheatsheetCard", { bg = vim.__color.dark1 })
    vim.api.nvim_set_hl(0, "CheatsheetCardSeparator", { bg = vim.__color.dark1, italic = true, bold = true, fg = vim.__color.dark0_hard })
    vim.api.nvim_set_hl(0, "CheatsheetCardTitle", { link = "FloatTitle" })
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
    vim.api.nvim_set_hl(0, "CheatsheetCursorLine", { bg = vim.__color.dark0 })
  end

  local showing_buf = -1
  function this:show(refresh)
    if showing_buf > 0 then
      local buf = showing_buf
      showing_buf = -1

      vim.schedule(function ()
        vim.cmd("bwipeout! " .. buf)
      end)

      if not refresh then
        return
      end
    end

    local nsid = vim.api.nvim_create_namespace("cheatsheet")
    local mappings_tb = builtin_keymaps

    showing_buf = vim.api.nvim_create_buf(false, true)
    local buf = showing_buf

    local tbline_height = #vim.o.tabline == 0 and -1 or 0
    vim.api.nvim_open_win(buf, true, {
      row = 1 + tbline_height,
      col = 0,
      width = vim.o.columns,
      height = vim.o.lines - (3 + tbline_height),
      relative = "editor",
    })

    local win = vim.api.nvim_get_current_win()
    vim.wo[win].winhl = table.concat({
      "NormalFloat:Normal",
      "CursorLine:CheatsheetCursorLine"
    }, ",")

    vim.api.nvim_set_current_win(win)

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
            vim.api.nvim_buf_set_extmark(
              buf,
              nsid,
              i + lnum - 1,
              vim.fn.byteidx(lines[1], col_start),
              {
                hl_group = "CheatsheetCard",
                end_col = vim.fn.byteidx(lines[1], col_start)
                  + column_width
                  + vim.fn.strlen(text)
                  - vim.__str.displaywidth(text)
              }
            )
            -- highlight card heading & randomize hl groups for colorful vim.__color
            vim.api.nvim_buf_set_extmark(
              buf,
              nsid,
              i + lnum - 1,
              vim.fn.stridx(lines[1], vim.trim(text), col_start) - 1,
              {
                hl_group = "CheatsheetCardTitle",
                end_col = vim.fn.stridx(lines[1], vim.trim(text), col_start)
                  + vim.fn.strlen(vim.trim(text))
                  + 1
              }
            )
            vim.api.nvim_buf_set_extmark(
              buf,
              nsid,
              i + lnum,
              vim.fn.byteidx(lines[2], col_start),
              {
                hl_group = "CheatsheetCard",
                end_col = vim.fn.byteidx(lines[2], col_start) + column_width
              }
            )

          -- highlight mappings & one line after it
          elseif string.match(text, "%s+") ~= text then
            local lines = vim.api.nvim_buf_get_lines(buf, i + lnum - 1, i + lnum + 1, false)

            local hl = "CheatsheetCard"
            if card_separator[text] then
              hl = "CheatsheetCardSeparator"
            end

            local text_idx = vim.fn.stridx(lines[1], text, col_start)

            vim.api.nvim_buf_set_extmark(
              buf,
              nsid,
              i + lnum - 1,
              text_idx,
              {
                hl_group = hl,
                end_col = text_idx + vim.fn.strlen(text)
              }
            )
            vim.api.nvim_buf_set_extmark(
              buf,
              nsid,
              i + lnum,
              vim.fn.byteidx(lines[2], col_start),
              {
                hl_group = hl,
                end_col = vim.fn.byteidx(lines[2], col_start) + column_width
              }
            )

            if mode_lines[text] then
              local mode_start = mode_lines[text].start
              local mode_end = mode_start + mode_lines[text].modes[1].text_len - 1
              for _, mode in ipairs(mode_lines[text].modes or {}) do
                vim.api.nvim_buf_set_extmark(
                  buf,
                  nsid,
                  i + lnum - 1,
                  text_idx + mode_start,
                  {
                    hl_group = mode.hl,
                    end_col = text_idx + mode_end
                  }
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
    -- vim.opt_local.filetype = "cheatsheet"

    vim.__autocmd.on({ "WinResized", "VimResized" }, function(_)
      this:show(true)
    end, { buffer = buf })

    vim.__autocmd.on("WinLeave", function()
      showing_buf = -1
      vim.cmd("bwipeout! " .. buf)
    end, { buffer = buf, once = true })

    vim.__key.rg("n", "q", function()
      showing_buf = -1
      vim.cmd("bwipeout! " .. buf)
    end, { buffer = buf })

    vim.__key.unrg("n", "<C-j>", { buffer = buf })
    vim.__key.unrg("n", "<C-h>", { buffer = buf })
    vim.__key.unrg("n", "<C-k>", { buffer = buf })
    vim.__key.unrg("n", "<C-l>", { buffer = buf })
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

  if opts and opts.motion then
    opts.motion = nil
    M.rg(mode, string.format("%sÞ", lhs), rhs, opts)
  end

  vim.keymap.set(mode, lhs, rhs, opts or {})
end

local kcode_cache = {}
function M.kcode(key)
  local ret = kcode_cache[key]
  if not ret then
    ret = vim.api.nvim_replace_termcodes(key, true, true, true)
    kcode_cache[key] = ret
  end
  return ret
end

function M.feed(key, mode)
  -- https://neovim.io/doc/user/builtin.html#feedkeys()
  mode = mode or "n"

  -- maybe involve some async logic
  vim.api.nvim_feedkeys(M.kcode(key), mode, false)
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

local __cheatsheet
vim.api.nvim_create_user_command(
  "Cheatsheet",
  function(_)
    if not __cheatsheet then
      __cheatsheet = Cheatsheet:new()
    end
    __cheatsheet:show()
  end,
  {}
)

return M

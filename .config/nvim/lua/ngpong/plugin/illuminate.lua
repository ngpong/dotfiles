local function cursorword_jump(backward)
  local bufnr = vim.__buf.current()
  if not vim.__buf.is_valid(bufnr) then
    return
  end
  if vim.b[bufnr].minicursorword_disable then
    return
  end

  local winid = vim.__win.current()
  if not vim.__win.is_valid(winid) then
    return
  end

  local has_match = false
  for _, match in ipairs(vim.fn.getmatches(winid) or {}) do
    if match.group == "MiniCursorwordCurrent" then
      has_match = true
      break
    end
  end
  if not has_match then return end

  local word = vim.fn.escape(vim.fn.expand('<cword>'), [[\/]])
  if not word then return end
  local wordlen = word:len()

  local orglnum, orgcol = vim.__cursor.get()

  local flag
  local stopline
  if backward then
    flag = "Wsb"
    stopline = vim.fn.line("w0")
  else
    flag = "Ws"
    stopline = vim.fn.line("w$")
  end

  vim.fn.search(word, flag, stopline, 3000, function()
    if not backward then
      return 0
    end

    local curlnum, curcol = vim.__cursor.get()
    if curlnum == orglnum then
      if orgcol > curcol and orgcol <= curcol + wordlen then
        return 1
      end
    end

    return 0
  end)
end

return {
  "echasnovski/mini.cursorword",
  lazy = true,
  event = "VeryLazy",
  highlights = {
    { "MiniCursorword", italic = true, bold = true, underline = true },
    { "MiniCursorwordCurrent", italic = true, bold = true, underline = true },
  },
  autocmds = {
    { "FileType", function() vim.b.minicursorword_disable = true end, pattern = vim.__filter.filetypes[1] }
  },
  opts = {
    delay = 375,
  },
  keys = {
    { "]]", function() cursorword_jump(false) end, },
    { "[[", function() cursorword_jump(true) end, },
  }
}
local M = {}

local Gitsigns = vim.__lazy.require("gitsigns")

local etypes = vim.__event.types

local is_special_winid = function(id, winid)
  local vimw = vim.w[winid]
  local success, result = pcall(getmetatable(vimw).__index, vimw, "gitsigns_preview")
  return success and result == id
end

local get_win_state = function(id)
  for _, _winid in pairs(vim.__win.all()) do
    if is_special_winid(id, _winid) then
      return { winid = _winid, bufnr = vim.__buf.number(_winid) }
    end
  end

  return nil
end

local is_open_win = function(id)
  for _, _winid in pairs(vim.__win.all()) do
    if is_special_winid(id, _winid) then
      return true
    end
  end

  return false
end

M.blame_line = vim.__async.void(function()
  local opened = is_open_win("blame")

  Gitsigns.blame_line()

  local timespan = 0
  while not is_open_win("blame") do
    if timespan >= 1000 then
      return
    end
    timespan = timespan + 100

    vim.__async.sleep(100)
  end

  local state = get_win_state("blame")

  if not opened and state then
    vim.__event.emit(etypes.GITSIGNS_OPEN_POPUP, state)
    vim.__event.emit(etypes.BUFFER_ENTER, { buf = state.bufnr })
  end
end)

M.preview_hunk = vim.__async.void(function()
  local opened = is_open_win("hunk")

  Gitsigns.preview_hunk()

  local timespan = 0
  while not is_open_win("hunk") do
    if timespan >= 1000 then
      return
    end
    timespan = timespan + 100

    vim.__async.sleep(100)
  end

  local state = get_win_state("hunk")

  if not opened and state then
    vim.__event.emit(etypes.GITSIGNS_OPEN_POPUP, state)
    vim.__event.emit(etypes.BUFFER_ENTER, { buf = state.bufnr })
  end
end)

M.is_attach = function(bufnr)
  return require("gitsigns.cache").cache[bufnr] ~= nil
end

local open_diffthis = function()
  Gitsigns.diffthis()

  for _, _winid in pairs(vim.__win.all()) do
    local bufnr = vim.__buf.number(_winid)
    if vim.__buf.name(bufnr):match("^gitsigns:") then
      vim.__event.emit(etypes.GITSIGNS_OPEN_DIFFTHIS, { bufnr = bufnr })
      break
    end
  end
end
M.toggle_diffthis = function()
  -- close diff base working tree window
  for _, _winid in pairs(vim.__win.all()) do
    local bufnr   = vim.__buf.number(_winid)
    local bufname = vim.__buf.name(bufnr)

    if bufname:match("^gitsigns:") then
      vim.__win.close(_winid)
      return
    end
  end

  -- open diffthis if has git status
  local path = vim.__buf.name(vim.__buf.current())
  vim.__git.if_has_diff_or_untracked(path, vim.__util.wrap_f(open_diffthis))
end

return M

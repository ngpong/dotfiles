local M = {}

-- stylua: ignore start
local Events   = require('ngpong.common.events')
local libP     = require('ngpong.common.libp')
local Gitter   = require('ngpong.utils.git')
local Lazy     = require('ngpong.utils.lazy')
local Gitsigns = Lazy.require('gitsigns')

local e_name = Events.e_name
-- stylua: ignore end

local is_special_winid = function(id, winid)
  local vimw = vim.w[winid]
  local success, result = pcall(getmetatable(vimw).__index, vimw, 'gitsigns_preview')
  return success and result == id
end

local get_win_state = function(id)
  for _, _winid in pairs(Helper.get_list_winids()) do
    if is_special_winid(id, _winid) then
      return { winid = _winid, bufnr = Helper.get_bufnr(_winid) }
    end
  end

  return nil
end

local is_open_win = function(id)
  for _, _winid in pairs(Helper.get_list_winids()) do
    if is_special_winid(id, _winid) then
      return true
    end
  end

  return false
end

M.blame_line = libP.async.void(function()
  local opened = is_open_win('blame')

  Gitsigns.blame_line()

  local timespan = 0
  while not is_open_win('blame') do
    if timespan >= 1000 then
      return
    end
    timespan = timespan + 100

    libP.async.util.sleep(100)
  end

  local state = get_win_state('blame')

  if not opened and state then
    Events.emit(e_name.GITSIGNS_OPEN_POPUP, state)
    Events.emit(e_name.BUFFER_ENTER, { buf = state.bufnr })
  end
end)

M.preview_hunk = libP.async.void(function()
  local opened = is_open_win('hunk')

  Gitsigns.preview_hunk()

  local timespan = 0
  while not is_open_win('hunk') do
    if timespan >= 1000 then
      return
    end
    timespan = timespan + 100

    libP.async.util.sleep(100)
  end

  local state = get_win_state('hunk')

  if not opened and state then
    Events.emit(e_name.GITSIGNS_OPEN_POPUP, state)
    Events.emit(e_name.BUFFER_ENTER, { buf = state.bufnr })
  end
end)

M.is_attach = function(bufnr)
  return require('gitsigns.cache').cache[bufnr] ~= nil
end

local open_diffthis = function()
  Gitsigns.diffthis()

  for _, _winid in pairs(Helper.get_list_winids()) do
    local bufnr = Helper.get_bufnr(_winid)
    if Helper.get_buf_name(bufnr):match('^gitsigns:') then
      Events.emit(e_name.GITSIGNS_OPEN_DIFFTHIS, { bufnr = bufnr })
      break
    end
  end
end
M.toggle_diffthis = function()
  -- close diff base working tree window
  for _, _winid in pairs(Helper.get_list_winids()) do
    local bufnr   = Helper.get_bufnr(_winid)
    local bufname = Helper.get_buf_name(bufnr)

    if bufname:match('^gitsigns:') then
      Helper.close_win(_winid)
      return
    end
  end

  -- open diffthis if has git status
  local path = Helper.get_buf_name(Helper.get_cur_bufnr())
  Gitter.if_has_diff_or_untracked(path, Tools.wrap_f(open_diffthis))
end

return M
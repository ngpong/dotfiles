local M = {}

function M.is_valid(winid)
  return vim.api.nvim_win_is_valid(winid)
end

function M.is_float(winid)
  if winid then
    return vim.api.nvim_win_get_config(winid).relative ~= ""
  else
    return false
  end
end

function M.is_notify(winid)
  winid = winid or M.current()
  return vim.__buf.filetype(vim.__buf.number(winid)) == "notify"
end

function M.is_diff(winid)
  winid = winid or M.current()
  return vim.wo[winid].diff
end

function M.close(winid)
  pcall(vim.api.nvim_win_close, winid or 0, true)
end

function M.close_diff()
  local winid = M.current()

  local function get_closing_winids()
    local closing_winids = {}
    for _, _winid in pairs(M.all()) do
      if vim.wo[_winid].diff then
        if _winid ~= winid then
          table.insert(closing_winids, _winid)
        elseif vim.__buf.name(vim.__buf.number(_winid)):match("^gitsigns:") then
          table.insert(closing_winids, _winid)
        end
      end
    end

    return closing_winids
  end

  local function reset_opts()
    vim.go.scrollopt = "ver,jump"
    for _, _winid in pairs(M.all()) do
      vim.wo[_winid].wrap = false
      vim.wo[_winid].diff = false
      vim.wo[_winid].scrollbind = false
      vim.wo[_winid].foldcolumn = "0"
      vim.wo[_winid].foldmethod = "expr"
      vim.wo[_winid].foldenable = false
    end
  end

  if M.is_diff(winid) then
    for _, _winid in ipairs(get_closing_winids()) do
      vim.api.nvim_win_call(_winid, function() vim.cmd("diffoff") end)
      M.close(_winid)
    end

    reset_opts()
    return true
  end

  return false
end

function M.close_float(async)
  local close_fn
  if async then
    close_fn = vim.__async.schedule_wrap(function(winid)
      M.close(winid)
    end)
  else
    close_fn = function(winid)
      M.close(winid)
    end
  end

  local ret = false

  for _, winid in pairs(M.all()) do
    if M.is_valid(winid) and M.is_float(winid) and not M.is_notify(winid) then
      close_fn(winid)
      ret = true
    end
  end

  return ret
end

function M.last(...)
  local args = { ... }
  local tabpage = #args > 0 and args[1] or vim.__tab.page()

  local winnr = vim.fn.winnr("#")
  local tabnr = vim.__tab.nr(tabpage)

  if winnr == 0 then
    return -1
  else
    return vim.fn.win_getid(winnr, tabnr)
  end
end

function M.current()
  return vim.api.nvim_get_current_win()
end

function M.bufnr(winid)
  winid = winid or M.current()

  local success, ret = pcall(vim.api.nvim_win_get_buf, winid)
  if success then
    return ret
  else
    return -1
  end
end

function M.ids(bufnr_or_path)
  if not bufnr_or_path then
    return { M.current() }
  end

  if type(bufnr_or_path) == "number" then
    local bufnr = bufnr_or_path
    return vim.fn.win_findbuf(bufnr)
  elseif type(bufnr_or_path) == "string" then
    local bufnr = vim.__buf.number(bufnr_or_path)
    return vim.fn.win_findbuf(bufnr)
  else
    assert(false)
  end
end

function M.all(...)
  local args = { ... }
  local tabpage = next(args) and args[1] or vim.__tab.page()

  local success, winids = pcall(vim.api.nvim_tabpage_list_wins, tabpage)
  if success then
    return winids
  else
    return {}
  end
end

function M.info(winid)
  local success, wininfo = pcall(vim.fn.getwininfo, winid)
  if not success then
    return {}
  end

  return wininfo
end

function M.infos(...)
  local args = { ... }

  local tabpage = next(args) and args[1] or vim.__tab.page()
  local tabnr   = vim.__tab.nr(tabpage)

  local ret = {}

  local success, wininfos = pcall(vim.fn.getwininfo)
  if not success then
    return ret
  end

  for _, wininfo in pairs(wininfos) do
    if wininfo.tabnr == tabnr then
      ret[#ret + 1] = wininfo
    end
  end

  return ret
end

function M.jump(winid)
  assert(winid and winid > 0)

  pcall(vim.api.nvim_set_current_win, winid)
end

function M.goto(winid)
  vim.fn.win_gotoid(winid)
end

function M.resize(cmd, size)
  vim.cmd(cmd .. size)
end

local resize_op_step = 1
function M.resize_op(cmd)
  if vim.v.count > 0 then resize_op_step = vim.v.count end
  M.resize(cmd, resize_op_step)
end

return M
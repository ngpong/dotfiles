local M = {}

function M.is_listed(bufnr)
  if not M.is_valid(bufnr) then
    return false
  end

  return vim.bo[bufnr].buflisted
end

function M.is_valid(bufnr)
  return vim.api.nvim_buf_is_valid(bufnr)
end

function M.is_unnamed(bufnr)
  return vim.bo[bufnr].filetype == "" and M.name(bufnr) == ""
end

function M.is_scratch(bufnr)
  return vim.bo[bufnr].buftype == "nofile" and
         vim.bo[bufnr].bufhidden == "hide" and
         vim.bo[bufnr].swapfile == false
end

function M.is_loaded(bufnr)
  return vim.api.nvim_buf_is_loaded(bufnr)
end

function M.switch(bufnr)
  if not bufnr then
    return
  end

  pcall(vim.api.nvim_set_current_buf, bufnr)
end

function M.add(arg)
  local type = type(arg)

  if type == "string" then
    vim.cmd.badd(arg)
  elseif type == "number" then
    local bufnr = arg

    for _, _bufnr in pairs(vim.api.nvim_list_bufs()) do
      if _bufnr == bufnr then
        vim.cmd.badd(M.name(bufnr))
        vim.api.nvim_buf_call(bufnr, vim.cmd.edit)
      end
    end
  end
end

function M.del(bufnr, force, cond)
  bufnr = bufnr or M.current()
  force = force or true

  if cond and not cond(bufnr) then
    return false
  end

  if not force and vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 2 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
      return
    end
    if choice == 1 then -- Yes
      vim.cmd.write()
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
    vim.api.nvim_win_call(win, function()
      if not vim.__win.is_valid(win) or vim.__win.bufnr(win) ~= bufnr then
        return
      end
      -- Try using alternate buffer
      local alt = vim.fn.bufnr("#")
      if alt ~= bufnr and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end

      -- Try using previous buffer
      local has_previous = pcall(vim.cmd, "bprevious")
      if has_previous and bufnr ~= vim.__win.bufnr(win) then
        return
      end

      -- Create new listed buffer
      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_win_set_buf(win, new_buf)
    end)
  end

  local success
  if M.is_valid(bufnr) then
    success, _ = pcall(vim.cmd, "keepjumps bdelete! " .. bufnr)
  end

  return success
end

function M.wipeout(bufnr, cond)
  bufnr = bufnr or M.current()

  if cond and not cond(bufnr) then
    return false
  end

  for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
    vim.api.nvim_win_call(win, function()
    if not vim.__win.is_valid(win) or vim.__win.bufnr(win) ~= bufnr then
      return
    end
    -- Try using alternate buffer
    local alt = vim.fn.bufnr("#")
    if alt ~= bufnr and vim.fn.buflisted(alt) == 1 then
      vim.api.nvim_win_set_buf(win, alt)
      return
    end

    -- Try using previous buffer
    local has_previous = pcall(vim.cmd, "bprevious")
    if has_previous and bufnr ~= vim.__win.bufnr(win) then
      return
    end

    -- Create new listed buffer
    local new_buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_win_set_buf(win, new_buf)
    end)
  end

  local success
  if M.is_valid(bufnr) then
    success, _ = pcall(vim.cmd, "keepjumps bwipeout! " .. bufnr)
  end

  return success
end

function M.current()
  return vim.api.nvim_get_current_buf()
end

function M.number(winid_or_path)
  if not winid_or_path then
    return M.current()
  end

  if type(winid_or_path) == "number" then
    local winid = winid_or_path

    local bufnr = vim.__win.bufnr(winid)
    if bufnr > 0 then
      return bufnr
    else
      return -1
    end
  elseif type(winid_or_path) == "string" then
    local path = winid_or_path

    local bufinfo = vim.fn.getbufinfo(path)[1]
    if bufinfo then
      return bufinfo.bufnr
    else
      return -1
    end
  else
    assert(false)
  end
end

function M.info(bufnr)
  bufnr = bufnr or M.current()
  return vim.fn.getbufinfo(bufnr)
end

function M.all()
  return vim.api.nvim_list_bufs()
end

function M.size(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr or M.current())

  local state = vim.__fs.state(path)
  if state then
    return state.size
  else
    return -1
  end
end

function M.name(bufnr)
  bufnr = bufnr or M.current()

  local success, result = pcall(vim.api.nvim_buf_get_name, bufnr)
  if not success then
    vim.__logger.error(debug.traceback())
    return nil
  else
    return result
  end
end

function M.filetype(bufnr)
  bufnr = bufnr or 0
  return vim.bo[bufnr].filetype
end

function M.buftype(bufnr)
  bufnr = bufnr or 0
  return vim.bo[bufnr].buftype
end

-- https://github.com/chrisgrieser/.config/blob/c96a64e8b3cfc4cdc2d7ce6dde1fb9ad51572028/nvim/lua/funcs/alt-alt.lua
local function has_altbuf(bufnr)
  if bufnr < 0 then return false end

  local valid               = M.is_valid(bufnr)
  local non_special         = M.buftype(bufnr) == ""
  local morethan_one_buffer = #(vim.fn.getbufinfo { buflisted = 1 }) > 1
  local curbuf_not_alt      = M.current() ~= bufnr -- fixes weird rare vim bug
  local altfile_exists      = vim.loop.fs_stat(M.name(bufnr)) ~= nil

  return valid and non_special and morethan_one_buffer and curbuf_not_alt and altfile_exists
end
function M.goto_altbuf()
  if vim.__filter.contain_fts() then
    return
  end

  local bufnr = vim.fn.bufnr("#")

  if has_altbuf(bufnr) then
    vim.cmd.buffer("#")
  else
    vim.__notifier.warn("Alternative buffer not found or closed")
  end
end

local last_modifiedbuf = nil
vim.__autocmd.on({ "TextChanged", "TextChangedI" }, function(state)
  local bufnr = state.buf
  if bufnr == last_modifiedbuf then
    return
  end

  local ft      = vim.__buf.filetype(bufnr)
  local bt      = vim.__buf.buftype(bufnr)
  local bufname = vim.__buf.name(bufnr)

  if vim.__buf.is_scratch(bufnr) or
     vim.__filter.contain_fts(ft) or
     vim.__filter.contain_bts(bt) or
     vim.__filter.contain_names(bufname) then
    return
  end

  last_modifiedbuf = bufnr -- vim.loop.hrtime(), vim.loop.now()
end)
function M.goto_modifiedbuf()
  local bufnr = M.current()

  local ft = vim.__buf.filetype(bufnr)
  if vim.__filter.contain_fts(ft) then
    return
  end

  if not last_modifiedbuf or
     not M.is_listed(last_modifiedbuf) or
     not M.is_loaded(last_modifiedbuf) then
    vim.__notifier.warn("Last-modified buffer not found or closed")
    return
  end

  if last_modifiedbuf == bufnr then
    return
  end

  vim.cmd.buffer(last_modifiedbuf)
end

return M

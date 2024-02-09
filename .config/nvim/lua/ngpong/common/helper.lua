local helper = {}

local timestamp = require('ngpong.utils.timestamp')
local icons     = require('ngpong.utils.icon')

helper.get_cur_bufnr = function(_)
  return vim.api.nvim_get_current_buf and vim.api.nvim_get_current_buf() or vim.fn.bufnr()
end

helper.is_buf_hidden = function(bufnr)
  if not helper.is_buf_valid(bufnr) then
    return true
  end

  return not vim.bo[bufnr].buflisted
end

helper.is_buf_valid = function(bufnr)
  return vim.api.nvim_buf_is_valid(bufnr)
end

helper.get_all_bufs = function()
  return vim.api.nvim_list_bufs()
end

helper.switch_buffer = function(bufnr)
  if not bufnr then
    return
  end

  pcall(vim.api.nvim_set_current_buf, bufnr)
end

helper.buffer_list = function()
  vim.cmd('ls!')
end

helper.add_buffer = function(arg)
  local type = type(arg)

  if type == 'string' then
    vim.cmd.badd(arg)
  elseif type == 'number' then
    local bufnr = arg

    for _, _bufnr in pairs(helper.get_all_bufs()) do
      if _bufnr == bufnr then
        vim.cmd.badd(helper.get_buf_name(bufnr))
        vim.api.nvim_buf_call(bufnr, vim.cmd.edit)
      end
    end
  end
end

helper.delete_buffer = function(bufnr, force, cond)
  if not require('bufdelete') then
    return
  end

  local async = require('plenary.async')
  if not async then
    return
  end

  bufnr = bufnr or HELPER.get_cur_bufnr()
  force = force == nil and true or force
  cond  = cond or nil

  if cond and not cond(bufnr) then
    return
  end

  local success, _ = pcall(vim.cmd, 'keepjumps lua require(\'bufdelete\').bufdelete(' .. bufnr .. ', ' .. tostring(force) .. ')')

  local wipeout_unnamed_buf = function()
    for _, _bufnr in pairs(helper.get_all_bufs()) do
      if helper.is_loaded_buf(_bufnr) then
        goto continue
      end

      if not helper.is_unnamed_buf(_bufnr) then
        goto continue
      end

      helper.wipeout_buffer(_bufnr)

      ::continue::
    end
  end

  if success then
    async.run(wipeout_unnamed_buf)
  end
end

helper.delete_all_buffers = function(force, cond)
  for _, bufnr in pairs(helper.get_all_bufs()) do
    helper.delete_buffer(bufnr, force, cond)
  end
end

helper.wipeout_buffer = function(bufnr, force, cond)
  if not require('bufdelete') then
    return
  end

  bufnr = bufnr or helper.get_cur_bufnr()
  force = force == nil and true or force
  cond  = cond  or nil

  if cond and not cond(bufnr) then
    return
  end

  pcall(vim.cmd, 'keepjumps lua require(\'bufdelete\').bufwipeout(' .. bufnr .. ', ' .. tostring(force) .. ')')
end

helper.wipeout_all_buffers = function(force, cond)
  for _, bufnr in pairs(helper.get_all_bufs()) do
    helper.wipeout_buffer(bufnr, force, cond)
  end
end

helper.clear_commandline = function()
  vim.fn.feedkeys(':', 'nx')
end

helper.clear_searchpattern = function()
  -- https://neovim.io/doc/user/change.html#registers
  vim.fn.setreg('/', {})
end

helper.clear_jumplist = function()
  vim.cmd('clearjumps')
end

helper.ishide_cursor = function()
  if vim.o.guicursor == "a:NGPONGHiddenCursor" then
    return true
  else
    return false
  end
end

helper.hide_cursor = function()
  local f = function()
    if not helper.ishide_cursor() then
      if vim.o.termguicolors and vim.o.guicursor ~= "" then
        helper.guicursor = vim.o.guicursor
        vim.o.guicursor = "a:NGPONGHiddenCursor"
      end
    end
  end

  local async = require('plenary.async')
  if not async then
    return
  end

  async.run(function()
    async.util.scheduler() f()
  end)
end

helper.unhide_cursor = function()
  local f = function()
    if helper.ishide_cursor() then
      vim.o.guicursor = helper.guicursor
    end
  end

  local async = require('plenary.async')
  if not async then
    return
  end

  async.run(function()
    async.util.scheduler() f()
  end)
end

helper.feedkeys = function(key, mode)
  -- https://neovim.io/doc/user/builtin.html#feedkeys()
  mode = mode or 'n'

  -- maybe involve some async logic
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), mode, false)
end

helper.presskeys = function(key)
  pcall(vim.cmd, "normal! " .. key)
end

helper.keep_screen_center = function()
  helper.presskeys('zz')
end

helper.get_bufnr = function(winid)
  local success, bufnr = pcall(vim.api.nvim_win_get_buf, winid)

  if success then
    return bufnr
  else
    return -1
  end
end

helper.get_buflines = function(bufnr)
  return vim.api.nvim_buf_line_count(bufnr or helper.get_cur_bufnr())
end

helper.get_bufsize = function(bufnr, cb)
  local path = vim.api.nvim_buf_get_name(bufnr or helper.get_cur_bufnr())

  local state = TOOLS.get_filestate(path)
  if state then
    return state.size
  else
    return -1
  end
end

helper.get_cur_winid = function()
  return vim.api.nvim_get_current_win()
end

helper.get_last_winid = function(...)
  local args = {...}
  local tabpage = #args > 0 and args[1] or helper.get_cur_tabpage()

  local winnr = vim.fn.winnr('#')
  local tabnr = helper.get_tabnr_by_tabpage(tabpage)

  if winnr == 0 then
    return -1
  else
    return vim.fn.win_getid(winnr, tabnr)
  end
end

helper.get_winid = function(bufnr, tabpage)
  bufnr = bufnr or helper.get_cur_bufnr()
  tabpage = tabpage or helper.get_cur_tabpage()

  for _, _winid in pairs(helper.get_list_winids(tabpage)) do
    if bufnr == helper.get_bufnr(_winid) then
      return _winid
    end
  end

  return -1
end

helper.get_winid_by_path = function(path)
  local tabpage = helper.get_cur_tabpage()

  for _, _winid in pairs(helper.get_list_winids(tabpage)) do
    if helper.get_buf_name(helper.get_bufnr(_winid)) == path then
      return _winid
    end
  end

  return nil
end

helper.is_win_valid = function(winid)
  return vim.api.nvim_win_is_valid(winid)
end

helper.is_floating_win = function(winid)
  winid = winid or helper.get_cur_winid()
  return vim.api.nvim_win_get_config(winid).relative ~= ''
end

helper.is_notify_win = function(winid)
  winid = winid or helper.get_cur_winid()
  return HELPER.get_filetype(HELPER.get_bufnr(winid)) == 'notify'
end

helper.get_tabnr_by_tabpage = function(tabpage)
  for _, _tabpage in pairs(helper.get_list_tabpage()) do
    if _tabpage == tabpage then
      return vim.api.nvim_tabpage_get_number(_tabpage)
    end
  end
end

helper.get_tabpage_by_tabnr = function(tabnr)
  for _, _tabpage in pairs(helper.get_list_tabpage()) do
    local _tabnr = vim.api.nvim_tabpage_get_number(_tabpage)

    if _tabnr == tabnr then
      return _tabpage
    end
  end

  return -1
end

helper.get_list_tabpage = function(_)
  return vim.api.nvim_list_tabpages()
end

helper.get_cur_tabpage = function(_)
  return vim.api.nvim_get_current_tabpage()
end

helper.get_last_tabpage = function(_)
  local last_tabnr = vim.fn.tabpagenr('#')

  return helper.get_tabpage_by_tabnr(last_tabnr)
end

helper.get_filetype = function(bufnr)
  local success, result = pcall(vim.api.nvim_get_option_value, 'filetype', { buf = bufnr })
  if not success then
    return nil
  else
    return result
  end
end

helper.get_list_winids = function(...)
  local args = {...}
  local tabpage = next(args) and args[1] or helper.get_cur_tabpage()

  local success, winids = pcall(vim.api.nvim_tabpage_list_wins, tabpage)
  if success then
    return winids
  else
    return {}
  end
end

helper.get_list_wininfos = function(...)
  local args = {...}
  local tabpage = next(args) and args[1] or helper.get_cur_tabpage()
  local tabnr = helper.get_tabnr_by_tabpage(tabpage)

  local ret = {}

  local success, wininfos = pcall(vim.fn.getwininfo)
  if not success then
    return ret
  end

  for _, wininfo in pairs(wininfos) do
    if wininfo.tabnr == tabnr then
      table.insert(ret, wininfo)
    end
  end

  return ret
end

helper.get_wininfo = function(winid)
  local success, wininfo = pcall(vim.fn.getwininfo, winid)
  if not success then
    return {}
  end

  return wininfo
end

helper.get_loaded_bufnrs = function()
  local ret = {}

  for _, bufnr in pairs(helper.get_all_bufs()) do
    if helper.is_loaded_buf(bufnr) then
      table.insert(ret, bufnr)
    end
  end

  return ret
end

helper.get_list_bufs = function(tabpage)
  local ret

  if tabpage == nil then
    ret = vim.fn.tabpagebuflist()
  else
    local tabnr = helper.get_tabnr_by_tabpage(tabpage)
    ret = vim.fn.tabpagebuflist(tabnr)
  end

  if type(ret) == 'number' then
    return {}
  else
    return ret
  end
end

helper.get_shown_bufs = function(tabpage)
  local ret = {}

  for _, _winid in pairs(helper.get_list_winids(tabpage) or {}) do
    table.insert(ret, helper.get_bufnr(_winid))
  end

  return ret
end

helper.get_buf_name = function(bufnr)
  bufnr = bufnr or helper.get_cur_bufnr()

  local success, result = pcall(vim.api.nvim_buf_get_name, bufnr)
  if not success then
    LOGGER.error(debug.traceback())
    return nil
  else
    return result
  end
end

helper.is_unnamed_buf = function(bufnr)
  return helper.get_filetype(bufnr) == '' and helper.get_buf_name(bufnr) == ''
end

helper.is_loaded_buf = function(bufnr)
  return vim.api.nvim_buf_is_loaded(bufnr)
end

helper.hide_tabline = function()
  vim.go.showtabline = 0
end

helper.show_tabline = function()
  vim.go.showtabline = 2
end

helper.reload_cfg = function()
  for name, _ in pairs(package.loaded) do
    if name:match('^ngpong') then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
end

helper.jump2_win = function(winid)
  vim.api.nvim_set_current_win(winid)
end

helper.reload_file_if_shown = function(path)
  local tabpage = helper.get_cur_tabpage()

  local cur_winid = helper.get_cur_winid()
  for _, _winid in pairs(helper.get_list_winids(tabpage)) do
    local bufnr   = helper.get_bufnr(_winid)
    local bufname = helper.get_buf_name(bufnr)
    if bufname == path then
      helper.jump2_win(_winid)
      vim.cmd('edit!')
      helper.jump2_win(cur_winid)
      return true
    end
  end

  return false
end

helper.get_cursor = function()
  return TOOLS.tbl_unpack(vim.api.nvim_win_get_cursor(0))
end

helper.close_win = function(winid)
  pcall(vim.api.nvim_win_close, winid, true)
end

helper.close_floating_wins = function(async)
  local ret = false

  for _, winid in pairs(HELPER.get_list_winids()) do
    if helper.is_win_valid(winid) and
       helper.is_floating_win(winid) and
       not helper.is_notify_win(winid) then
      if async then
        vim.schedule(function() HELPER.close_win(winid) end)
      else
        HELPER.close_win(winid)
      end

      ret = true
    end
  end

  return ret
end

helper.add_jumplist = function()
  helper.presskeys('m\'')
end

helper.is_has_qflst = function()
  return next(vim.fn.getqflist()) ~= nil
end

helper.set_qflst = function(items, action, options)
  vim.fn.setqflist(items or {}, action or 'r', options or {})
end

helper.clear_qflst = function()
  vim.fn.setqflist({}, 'r')
end

helper.get_cur_mode = function()
  return vim.api.nvim_get_mode()
end

helper.set_cursor = function(row, col)
  pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
end

helper.set_wincursor = function(winid, row, col)
  pcall(vim.api.nvim_win_set_cursor, winid, { row, col })
end

-- will causes a lazy loading with nvim-notify plugin.
helper.notify = function(msg, title, opts, lv)
  vim.schedule(function()
    local final_opts = { title = title or 'System' }
    TOOLS.tbl_r_extend(final_opts, opts or {})

    vim.notify(tostring(msg), lv, final_opts)
  end)
end
helper.notify_err = function(msg, title, opts)
  helper.notify(tostring(msg), title, TOOLS.tbl_r_extend({ icon = icons.diagnostic_err }, opts or {}), vim.log.levels.ERROR)
end
helper.notify_warn = function(msg, title, opts)
  helper.notify(tostring(msg), title, TOOLS.tbl_r_extend({ icon = icons.diagnostic_warn }, opts or {}), vim.log.levels.WARN)
end
helper.notify_info = function(msg, title, opts)
  helper.notify(tostring(msg), title, TOOLS.tbl_r_extend({ icon = icons.diagnostic_info }, opts or {}), vim.log.levels.INFO)
end

helper.get_visual_selected = function()
  local _, ls, cs = unpack(vim.fn.getpos("v"))
  local _, le, ce = unpack(vim.fn.getpos("."))

  ls, le = math.min(ls, le), math.max(ls, le)
  cs, ce = math.min(cs, ce), math.max(cs, ce)

  return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})[1] or ''
end

helper.dclock = {
  reset = function(self)
    self.begin = self.begin or 0
    self.begin = timestamp.get_microsecond()
  end
}
setmetatable(helper.dclock, {
  __call = function(self, key)
    local ended = timestamp.get_microsecond() - helper.dclock.begin
    local text = (key ~= nil and (key .. ': ') or '') .. ended
    LOGGER.info(text)
  end,
})

helper.is_neovide = function()
  return vim.g.neovide
end

helper.debug = function()
  local datas = {}

  for _, winid in pairs(helper.get_list_winids()) do
    local bufnr = helper.get_bufnr(winid)

    table.insert(datas, {
      bufnr = bufnr,
      ft = helper.get_filetype(bufnr),
      name = helper.get_bufnr(winid)
    })
  end

  LOGGER.info(datas)
end

return helper

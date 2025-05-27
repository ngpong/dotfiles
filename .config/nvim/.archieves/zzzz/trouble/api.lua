local M = {}

local API     = vim.__lazy.require("trouble.api")
local View    = vim.__lazy.require("trouble.view")
local Preview = vim.__lazy.require("trouble.view.preview")

M.jump = vim.__async.void(function()
  vim.__jumplst.add()

  API.jump()

  vim.__jumplst.add()
end)

M.jump_close = vim.__async.void(function()
  vim.__jumplst.add()

  API.jump_close()

  vim.__jumplst.add()
end)

M.is_previewing = function()
  return Preview.is_open()
end

M.toggle_preview = function()
  local v = M.find_view({ winid = vim.__win.current() })
  if not v then
    return
  end

  if M.is_previewing() then
    v.opts.auto_preview = false
    Preview.close()
  else
    v.opts.auto_preview = true
    Preview.open(v, v:at().item, { scratch = v.opts.preview.scratch })
  end

  vim.__stl:refresh()
end

local _refresh = vim.__bouncer.throttle_leading(500, vim.__async.schedule_wrap(function()
  local winid = vim.__win.current()

  local v = M.find_view({ winid = winid })
  if v == nil then
    return
  end

  vim.__trouble.refresh_mode = v.opts.mode

  v:refresh()

  vim.__trouble.refresh_mode = nil
end))
M.refresh = function(...)
  _refresh(...)
end

M.has_switch = function(mode)
  local success, module = pcall(require, "trouble.sources." .. mode)
  if success and module.switch then
    return module
  else
    return nil
  end
end

M.switch = function(mode, offset)
  local module = M.has_switch(mode)
  if module then
    module.switch(offset)
  end
end

M.has_toggle = function(mode)
  local success, module = pcall(require, "trouble.sources." .. mode)
  if success and module.toggle then
    return module
  end
end

M.toggle = function(mode, opts)
  local module = M.has_toggle(mode)
  if module then
    module.toggle()
  else
    local default_opts = {
      mode = mode or "",
    }

    opts = vim.__tbl.rr_extend(opts or {}, default_opts)

    API.toggle(opts)
  end
end

M.open = function(mode, opts)
  local default_opts = {
    mode = mode or "",
  }
  opts = vim.__tbl.rr_extend(opts or {}, default_opts)

  return API.open(opts)
end

M.is_open = function(opts)
  return M.find_view(opts) and true or false
end

local _strict_filter = function(v)
  return (v.win:valid() and v.win.win)
end
local _view_filter = function(v1, v2)
  return v1 == v2
end
local _bufnr_filter = function(v, bufnr)
  return (bufnr and {v.win.buf == bufnr} or {true})[1]
end
local _winid_filter = function(v, winid)
  return (winid and {v.win.win == winid} or {true})[1]
end
local _mode_filter = function(v, mode)
  return (mode and {v.opts.mode == mode} or {true})[1]
end
local _modes_filter = function(v, modes)
  return (modes and {vim.__tbl.contains(modes, v.opts.mode)} or {true})[1]
end
M.find_view = function(opts)
  -- stylua: ignore
  for v, _ in pairs(View._views or {}) do
    if _strict_filter(v) then
      if opts.bufnr and _bufnr_filter(v, opts.bufnr) then
        return v
      end

      if opts.view and _view_filter(v, opts.view) then
        return v
      end

      if opts.winid and _winid_filter(v, opts.winid) then
        return v
      end

      if opts.mode and _mode_filter(v, opts.mode) then
        return v
      end

      if opts.modes and _modes_filter(v, opts.modes) then
        return v
      end
    end
  end

  return nil
end

M.get_cur_view_name = function()
  local winid = vim.__win.current()

  local v = M.find_view({ winid = winid })
  if v == nil then
    return ""
  end

  return v.opts.desc
end

M.close = function(opts)
  local v = M.find_view(opts)
  if v == nil then
    return
  end

  v:close()
end

M.close_current = function()
  local v = M.find_view({ winid = vim.__win.current() })
  if v == nil then
    return
  end

  v:close()
end

return setmetatable(M, {
  __index = function(_, k)
    return vim.__util.wrap_f(vim.__lazy.access("trouble.api", k))
  end,
})

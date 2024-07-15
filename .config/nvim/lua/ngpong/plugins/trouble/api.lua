local M = {}

-- stylua: ignore start
local Lazy    = require('ngpong.utils.lazy')
local libP    = require('ngpong.common.libp')
local API     = Lazy.require('trouble.api')
local View    = Lazy.require('trouble.view')
local Preview = Lazy.require('trouble.view.preview')
-- stylua: ignore end

M.jump = libP.async.void(function()
  VAR.set('DisablePresistCursor', true)

  Helper.add_jumplist()
  API.jump()
  Helper.add_jumplist()

  libP.async.util.scheduler()

  Helper.keep_screen_center()

  VAR.unset('DisablePresistCursor')
end)

M.jump_close = libP.async.void(function()
  VAR.set('DisablePresistCursor', true)

  Helper.add_jumplist()
  API.jump_close()
  Helper.add_jumplist()

  libP.async.util.scheduler()

  Helper.keep_screen_center()

  VAR.unset('DisablePresistCursor')
end)

M.is_previewing = function()
  return Preview.is_open()
end

M.toggle_preview = function()
  local v = M.find_view_by_winid(Helper.get_cur_winid())
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

  Plgs.lualine.api.refresh()
end

M.toggle = function(mode)
  API.toggle({ mode = mode or '' })
end

M.open = function(mode)
  API.open({ mode = mode or '' })
end

M.find_view_by_mode = function(mode)
  for v, _ in pairs(View._views or {}) do
    if v.opts.mode == mode then
      return v
    end
  end

  return nil
end

M.find_view_by_winid = function(winid)
  for v, _ in pairs(View._views or {}) do
    if v.win.win == winid then
      return v
    end
  end

  return nil
end

M.find_view_by_bufnr = function(bufnr)
  for v, _ in pairs(View._views or {}) do
    if v.win.buf == bufnr then
      return v
    end
  end

  return nil
end

M.close = function(winid)
  winid = winid or Helper.get_cur_winid()

  local v = M.find_view_by_winid(winid)
  if v == nil then
    return
  end

  v:close()
end

M.get_cur_view_name = function()
  local winid = Helper.get_cur_winid()

  local v = M.find_view_by_winid(winid)
  if v == nil then
    return ''
  end

  return v.opts.desc
end

M.close_all = function()
  for _, v in pairs(API._find() or {}) do
    v:close()
  end
end

return setmetatable(M, {
  __index = function(_, k)
    return Tools.wrap_f(Lazy.access('trouble.api', k))
  end,
})

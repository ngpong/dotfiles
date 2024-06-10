local M = {}

-- stylua: ignore start
local libP    = require('ngpong.common.libp')
local Bouncer = require('ngpong.utils.debounce')
local Icons   = require('ngpong.utils.icon')
local Lazy    = require('ngpong.utils.lazy')
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

M.toggle_preview = function()
  local v = M.find_view_by_winid(Helper.get_cur_winid())
  if not v then
    return
  end

  if Preview.is_open() then
    v.opts.auto_preview = false
    Preview.close()
  else
    v.opts.auto_preview = true
    Preview.open(v, v:at().item, { scratch = v.opts.preview.scratch })
  end
end

M.toggle = setmetatable({
  ___open_state = {},
}, {
  __call = function(self, mode)
    local is_open = API.is_open({ mode = mode })

    if not is_open and self.___open_state[mode] then
      return
    end

    API.toggle({ mode = mode or '' })

    if not is_open then
      self.___open_state[mode] = true
    end
  end,
})

M.open = setmetatable({
  ___open_state = {},
}, {
  __call = function(self, mode)
    if self.___open_state[mode] then
      return
    end

    API.open({ mode = mode or '' })
    self.___open_state[mode] = true
  end,
})

M.find_view_by_mode = function(mode)
  for v, _ in pairs(View._views or {}) do
    if v.opts.mode == mode then
      return v
    end
  end

  return nil
end

---@param winid number? window id
M.find_view_by_winid = function(winid)
  for v, _ in pairs(View._views or {}) do
    if v.win.win == winid then
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

local M = {}

local dclock_tb = {}
M.dclock = setmetatable({
  wrap = function(self, f, key)
    return function(...)
      self(key)
      local ret1, ret2, ret3, ret4, ret5, ret6, ret7, ret8 = f(...)
      self(key)
      return ret1, ret2, ret3, ret4, ret5, ret6, ret7, ret8
    end
  end,
}, {
  __call = function(self, key)
    key = key or "default"
    local ts = vim.loop.hrtime()

    local begin = dclock_tb[key]
    if not begin then
      dclock_tb[key] = ts
    else
      local ended = ts - begin
      local text = (key ~= "default" and (key .. ": ") or "") .. "ns(" .. ended .. "), µs(" .. ended / 1000 .. "), ms(" .. ended / 1000 / 1000 .. ")"
      vim.__logger.info(text)
      dclock_tb[key] = nil
    end
  end
})

function M.clear_commandline()
  print(" ")
end

function M.clear_searchpattern()
  -- https://neovim.io/doc/user/change.html#registers
  vim.fn.setreg("/", {})
  vim.v.hlsearch = 0
end

function M.reload_cfg()
  for name, _ in pairs(package.loaded) do
    if name:match("^ngpong") then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
end

function M.get_mode()
  return vim.api.nvim_get_mode().mode
end

function M.get_selection()
  local _, ls, cs = unpack(vim.fn.getpos("v"))
  local _, le, ce = unpack(vim.fn.getpos("."))

  ls, le = math.min(ls, le), math.max(ls, le)
  cs, ce = math.min(cs, ce), math.max(cs, ce)

  return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})[1] or ""
end

return M

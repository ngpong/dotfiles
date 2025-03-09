local M = {}

function M.shuffle(tbl)
  for i = #tbl, 2, -1 do
    local j = vim.__util.rand(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

function M.dump(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
        if type(k) ~= "number" then k = '"' .. k .. '"' end
        s = s .. "[" .. k .. "] = " .. M.dump(v) .. ", "
    end
    return s .. "} "
  else
    return tostring(o)
  end
end

function M.remove_iter(t, f)
  local j, n = 1, #t

  for i = 1, n do
    if f(t, i, j) then
      if i ~= j then
        t[j] = t[i]
        t[i] = nil
      end
      j = j + 1
    else
      t[i] = nil
    end
  end

  return t
end

function M.insert_arr(l, r)
  local size = #l
  for i, item in ipairs(r) do
    l[i + size] = item
  end
  return l
end

function M.contains(t, v)
  return vim.tbl_contains(t, v)
end

function M.rr_extend(...)
  return vim.tbl_deep_extend("force", ...)
end

function M.keys(t, f)
  local ret = {}

  for k, v in pairs(t) do
    if f and not f(k, v) then
      goto continue
    end

    ret[#ret+1] = k

    ::continue::
  end
  return ret
end

function M.r_extend(org, ...)
  local function can_merge(v)
    return type(v) == "table" and (vim.tbl_isempty(v) or not vim.isarray(v))
  end

  if select("#", ...) <= 0 then
    return
  end

  for i = 1, select("#", ...) do
    local tbl = select(i, ...)
    if tbl then
      for k, v in pairs(tbl) do
        if can_merge(v) and can_merge(org[k]) then
          M.tbl_r_extend(org[k], v)
        else
          org[k] = v
        end
      end
    end
  end
end

function M.pack(...)
  return { n = select("#", ...), ... }
end

function M.unpack(t, i, j)
  return table.unpack(t, i or 1, j or t.n or table.maxn(t))
end

function M.reverse(t)
  for i=1, math.floor(#t / 2) do
    local tmp = t[i]
    t[i] = t[#t - i + 1]
    t[#t - i + 1] = tmp
  end
end

function M.length(t)
  if vim.isarray(t) then
    return #t
  else
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
  end
end

return M
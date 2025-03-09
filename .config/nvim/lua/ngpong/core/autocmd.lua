local M = {}

local group_cache = {}

local Autocmd = vim.__class.def(function(this)
  local acid

  function this:__init(event, args)
    acid = vim.api.nvim_create_autocmd(event, args)
  end

  function this:del()
    vim.api.nvim_del_autocmd(acid)
    acid = nil
  end
end)

local Augroup = vim.__class.def(function(this)
  local groupid, key, name

  function this:__init(_key)
    key = _key
    group_cache[key] = this
    name = "user-ngpong-" .. key
    groupid = vim.api.nvim_create_augroup( name, { clear = true } )
  end

  function this:del()
    pcall(vim.api.nvim_del_augroup_by_id, groupid)
    groupid = nil
    group_cache[key] = nil
  end

  function this:reset()
    groupid = vim.api.nvim_create_augroup(name, { clear = true } )
  end

  function this:empty()
    local success, result = pcall(vim.api.nvim_get_autocmds, { group = groupid })
    if not success then
      return true
    else
      return #result > 0
    end
  end

  function this:on(event, cb, args)
    assert(groupid)

    args = args or {}
    args.group = groupid
    args.callback = cb

    return Autocmd:new(event, args)
  end
end)

function M.augroup(key)
  assert(key and key ~= "")

  local group = group_cache[key]
  if group then
    return group
  end

  return Augroup:new(key)
end

function M.del_augroup(arg, api_selector)
  assert(arg, "invalid argument not support")

  local group = group_cache[arg]
  if group then
    return group:del()
  end

  if api_selector then
    api_selector = "nvim_del_augroup_by_" .. api_selector

    local fc = vim.api[api_selector]
    if not fc or type(fc) ~= "function" then
      vim.__notifier.err("delete augroup error, invalid selector not found: " .. api_selector)
      return
    end

    local success = pcall(fc, arg)
    if not success then
      vim.__logger.error("delete augroup error: " .. debug.traceback())
      assert(false, "delete auto cmd error, please check log file for more information.")
    end
  end
end

function M.exec(event, opts)
  vim.api.nvim_exec_autocmds(event, opts)
end

local default_augroup = M.augroup("deafult")
function M.on(...)
  return default_augroup:on(...)
end

return M
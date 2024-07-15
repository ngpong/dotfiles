local autocmd = {}

local group_ids = {}

autocmd.get_groupid = function(key)
  return group_ids[key]
end

autocmd.new_augroup = function(key)
  if key ~= nil then
    key = key and key or ''

    local group_name = 'ngpong_plugins_manager_group' .. (key == '' and key or ('_' .. key))

    local group_id = vim.api.nvim_create_augroup(group_name, { clear = true })

    group_ids[key] = group_id
  end

  return {
    on = function(event, cb, ...)
      local args = { ... }

      assert(cb, 'Invalid cb arg type')
      assert(#args <= 2, 'Invalid agrs')

      local buf
      local pattern
      for _, value in pairs(args) do
        local type = type(value)

        if type == 'number' then
          buf = value
        elseif type == 'string' or type == 'table' then
          pattern = value
        end
      end

      return vim.api.nvim_create_autocmd(event, {
        group = group_ids[key],
        pattern = pattern,
        buffer = buf,
        callback = cb,
      })
    end,
  }
end

autocmd.del_augroup = function(key)
  local group_id = autocmd.get_groupid(key)
  if not group_id then
    return
  end

  if not pcall(vim.api.nvim_del_augroup_by_id, group_id) then
    Helper.notify_err('delete auto cmd error, please check log file for more information.', 'System: autocmd')
    Logger.error('delete augroup error: ' .. debug.traceback())
  end

  group_ids[key] = nil
end

autocmd.del_augroup_by = function(selector, key)
  selector = 'nvim_del_augroup_by_' .. selector

  local fc = vim.api[selector]
  if not fc or type(fc) ~= 'function' then
    Helper.notify_err('delete augroup error, invalid selector not found: ' .. selector, 'System: autocmd')
    return
  end

  pcall(fc, key)
end

autocmd.del_autocmd_filter = function(filter)
  local autocmds = vim.api.nvim_get_autocmds(filter)

  if not next(autocmds) then
    Helper.notify_warn('Find autocmds error. filter: ' .. vim.inspect(filter))
    return
  end

  for _, ac in ipairs(autocmds) do
    vim.api.nvim_del_autocmd(ac.id)
  end
end

autocmd.exec = function(event, opts)
  vim.api.nvim_exec_autocmds(event, opts)
end

return autocmd

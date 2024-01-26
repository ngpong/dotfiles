local autocmd = {}

local group_ids = {}

autocmd.get_groupid = function(key)
  return group_ids[key]
end

autocmd.new_augroup = function(key)
  key = key and key or ''

  local group_name = 'ngpong_plugins_manager_group' .. (key == '' and key or ('_' .. key))

  local group_id = vim.api.nvim_create_augroup(group_name, { clear = true, })

  group_ids[key] = group_id

  return group_id
end

autocmd.del_augroup = function(key)
  local group_id = autocmd.get_groupid(key)
  if not group_id then
    return
  end

  if not pcall(vim.api.nvim_del_augroup_by_id, group_id) then
    HELPER.notify_err('delete auto cmd error, please check log file for more information.', 'System: autocmd')
    LOGGER.error('delete augroup error: ' .. debug.traceback())
  end

  group_ids[key] = nil
end

return autocmd

local M = {}

M.is_active = function()
  local is_loaded = Plgs.is_loaded('multicursors.nvim')

  if is_loaded then
    local success, hydra = pcall(require, 'hydra.statusline')
    return success and hydra.is_active()
  else
    return false
  end
end

M.get_cur_mode = function()
  local is_loaded = Plgs.is_loaded('multicursors.nvim')

  if is_loaded then
    local success, hydra = pcall(require, 'hydra.statusline')
    if success then
      return hydra.get_name():sub(4)
    else
      return nil
    end
  else
    return nil
  end
end

M.set_first_time_enter_normal = function()
  if M.get_cur_mode() == 'Normal' then
    M.__set_first_time_enter_normal = true
  end
end

M.unset_first_time_enter_normal = function()
  M.__set_first_time_enter_normal = false
end

M.is_first_time_enter_normal = function()
  return not M.__set_first_time_enter_normal
end

return M

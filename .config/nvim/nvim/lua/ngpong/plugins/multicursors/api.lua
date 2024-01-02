local M = {}

M.is_active = function()
  local is_loaded = PLGS.is_loaded('multicursors.nvim')

  if is_loaded then
    local success, hydra = pcall(require, 'hydra.statusline')
    return success and hydra.is_active()
  else
    return false
  end
end

M.get_cur_mode = function()
  local is_loaded = PLGS.is_loaded('multicursors.nvim')

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

return M
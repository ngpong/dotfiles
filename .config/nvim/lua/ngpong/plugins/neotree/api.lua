local M = {}

local Lazy            = require('ngpong.utils.lazy')
local Neotree         = Lazy.require('neo-tree')
local NeotreeRenderer = Lazy.require('neo-tree.ui.renderer')
local SourceManager   = Lazy.require('neo-tree.sources.manager')

M.is_neotree_bufnr = function(bufnr)
  local success, _ = pcall(vim.api.nvim_buf_get_var, bufnr, "neo_tree_source")

  return success
end

M.is_neotree_winid = function(winid)
  return M.is_neotree_bufnr(Helper.get_bufnr(winid))
end

M.is_opened = function(tabpage)
  for _, _tabpage in pairs(Helper.get_list_tabpage()) do
    if tabpage ~= nil and tabpage ~= _tabpage then
      goto continue
    end

    for _, _winid in pairs(Helper.get_list_winids(_tabpage)) do
      if M.is_neotree_winid(_winid) then
        return true
      end
    end

    ::continue::
  end

  return false
end

M.redraw = function(state)
  if state ~= nil then
    NeotreeRenderer.redraw(state)
  end
end

M.refresh = function(state)
  if state ~= nil then
    SourceManager.refresh(state.name)
  end
end

M.get_state = function(tabpage)
  for _, _winid in pairs(Helper.get_list_winids(tabpage)) do
    local state = SourceManager.get_state_for_window(_winid)
    if state ~= nil then
      return state
    end
  end

  return nil
end

M.refresh_if_exists = function(tabpage)
  local state = M.get_state(tabpage)
  if state ~= nil then
    M.refresh(state)
  end
end

M.redraw_if_exists = function(tabpage)
  local state = M.get_state(tabpage)
  if state ~= nil then
    M.redraw(state)
  end
end

M.open_tree = function()
  if M.is_opened(Helper.get_cur_tabpage()) then
    vim.cmd('Neotree action=close')
  else
    vim.cmd('Neotree action=show')
  end
end

return M

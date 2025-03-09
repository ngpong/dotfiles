local M = {}

local Neotree         = vim.__lazy.require("neo-tree")
local NeotreeRenderer = vim.__lazy.require("neo-tree.ui.renderer")
local SourceManager   = vim.__lazy.require("neo-tree.sources.manager")
local CommonPreview   = vim.__lazy.require("neo-tree.sources.common.preview")
local SourceCommand   = vim.__lazy.require("neo-tree.sources.common.commands")

M.is_neotree_bufnr = function(bufnr)
  local success, _ = pcall(vim.api.nvim_buf_get_var, bufnr, "neo_tree_source")

  return success
end

M.is_neotree_winid = function(winid)
  return M.is_neotree_bufnr(vim.__buf.number(winid))
end

M.toggle_preview = function(state)
  state = state or M.get_state(vim.__tab.page())

  SourceCommand.toggle_preview(state)

  vim.__stl:refresh()
end

M.is_previewing = function()
  return CommonPreview.is_active()
end

M.is_opened = function(tabpage)
  for _, _tabpage in pairs(vim.__tab.pages()) do
    if tabpage ~= nil and tabpage ~= _tabpage then
      goto continue
    end

    for _, _winid in pairs(vim.__win.all(_tabpage)) do
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
  for _, _winid in pairs(vim.__win.all(tabpage)) do
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
  if M.is_opened(vim.__tab.page()) then
    vim.cmd("Neotree action=close")
  else
    vim.cmd("Neotree action=focus")
  end
end

return M

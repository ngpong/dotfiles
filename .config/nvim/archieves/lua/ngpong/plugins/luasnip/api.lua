local M = {}

local Luasnip = vim.__lazy.require("luasnip")
local Session = vim.__lazy.require("luasnip.session")

M.unlink_current_if_expandable = function()
  -- ensure snippet is expandable and avoid error message shown

  if not Luasnip.expandable() then
    return
  end

  local bufnr = vim.__buf.current()
  local node = Session.current_nodes[bufnr]
	if not node then
    return
	end

  Luasnip.unlink_current()
end

M.locally_jumpable = function(idx)
  return Luasnip.locally_jumpable(idx)
end

M.jump = function(idx)
  Luasnip.jump(idx)
end

M.is_in_snippet = function()
  return Luasnip.in_snippet()
end

return M

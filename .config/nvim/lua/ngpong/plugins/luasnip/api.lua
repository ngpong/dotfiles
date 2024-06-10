local M = {}

local Lazy    = require('ngpong.utils.lazy')
local Luasnip = Lazy.require('luasnip')
local Session = Lazy.require('luasnip.session')

M.unlink_current_if_expandable = function()
  -- ensure snippet is expandable and avoid error message shown

  if not Luasnip.expandable() then
    return
  end

  local bufnr = Helper.get_cur_bufnr()
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

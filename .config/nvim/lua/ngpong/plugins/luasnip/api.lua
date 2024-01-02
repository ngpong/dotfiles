local M = {}

local lazy    = require('ngpong.utils.lazy')
local luasnip = lazy.require('luasnip')
local session = lazy.require('luasnip.session')

M.unlink_current_if_expandable = function()
  -- ensure snippet is expandable and avoid error message shown

  if not luasnip.expandable() then
    return
  end

  local bufnr = HELPER.get_cur_bufnr()
  local node = session.current_nodes[bufnr]
	if not node then
    return
	end

  luasnip.unlink_current()
end

return M
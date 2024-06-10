local M = {}

local Lazy            = require('ngpong.utils.lazy')
local View            = Lazy.require('trouble.view')
local TelescopeSource = Lazy.require('trouble.sources.telescope')

local this = Plgs.trouble

M.setup = function()
  local org_refresh = View.refresh
  View.refresh = function(self, opts)
    return org_refresh(self, opts):next(function()
      this.api.open.___open_state[self.opts.mode] = nil
      this.api.toggle.___open_state[self.opts.mode] = nil
    end)
  end

  local org_telescope_item = TelescopeSource.item
  TelescopeSource.item = function(item)
    local ret = org_telescope_item(item)
    ret.pos[2] = 0
    ret.end_pos[2] = vim.v.maxcol

    return ret
  end
end

return M

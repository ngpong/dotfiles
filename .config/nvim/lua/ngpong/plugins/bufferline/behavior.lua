local M = {}

-- stylua: ignore start
local Events           = require('ngpong.common.events')
local Lazy             = require('ngpong.utils.lazy')
local libP             = require('ngpong.common.libp')
local BufferlineState  = Lazy.require('bufferline.state')

local e_name = Events.e_name
-- stylua: ignore end

M.setup = function()
  -- 当仅剩一个 NO NAME buffer 且下一次打开的文件是已经加载为 buffer 时，默认情况下并不会删除掉 NO NAME buffer
  Events.rg(e_name.BUFFER_ADD, libP.async.void(function()
    libP.async.util.scheduler()

    if #BufferlineState.components == 2 then
      for _, _item in ipairs(BufferlineState.components) do
        local element = _item:as_element()
        if Helper.is_unnamed_buf(element.id) then
          Helper.delete_buffer(element.id, true)
        end
      end
    end
  end))
end

return M

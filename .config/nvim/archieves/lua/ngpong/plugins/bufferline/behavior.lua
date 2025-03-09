local M = {}

local BufferlineState = vim.__lazy.require("bufferline.state")

local etypes = vim.__event.types

M.setup = function()
  -- 当仅剩一个 NO NAME buffer 且下一次打开的文件是已经加载为 buffer 时，默认情况下并不会删除掉 NO NAME buffer
  vim.__event.rg(etypes.BUFFER_ADD, vim.__async.schedule_wrap(function()
    if #BufferlineState.components == 2 then
      for _, _item in ipairs(BufferlineState.components) do
        local element = _item:as_element()
        if vim.__buf.is_unnamed(element.id) then
          vim.__buf.del(element.id, true)
        end
      end
    end
  end))
end

return M

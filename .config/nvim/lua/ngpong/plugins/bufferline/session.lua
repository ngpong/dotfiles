local session = {}

-- stylua: ignore start
local Events           = require('ngpong.common.events')
local Json             = require('ngpong.utils.json')
local Lazy             = require('ngpong.utils.lazy')
local libP             = require('ngpong.common.libp')
local BufferlineState  = Lazy.require('bufferline.state')
local BufferlineGroup  = Lazy.require('bufferline.groups')
local BufferlineUI     = Lazy.require("bufferline.ui")

local this   = Plgs.bufferline
local e_name = Events.e_name
-- stylua: ignore end

session.setup = function()
  local file = libP.path:new(vim.fn.stdpath('data') .. '/bufferline/' .. Tools.get_workspace_sha1() .. '.json')

  Events.rg(e_name.VIM_LEAVE_PRE, libP.async.void(function()
      if not this.api.is_plugin_loaded() then
        return
      end

      if not file:exists() then
        file:touch({ parents = true })
      end

      local datas = {}
      for _, _item in ipairs(BufferlineState.components) do
        local element = _item:as_element()

        if element.name ~= 'COMMIT_EDITMSG' and not Tools.isempty(element.path) then
          table.insert(datas, {
            file = element.path,
            is_pinned = this.api.is_pinned(element),
            is_activation = Helper.get_cur_bufnr() == element.id and true or false,
          })
        end
      end

      file:write(Json.encode(datas), 'w')
    end)
  )

  Events.rg(
    e_name.VIM_ENTER,
    libP.async.void(function()
      if not file:exists() then
        return
      end

      local data = file:read()

      -- 获取持久化的 buffer
      local pre_buffs = Json.decode(data)
      if not next(pre_buffs) then
        return
      end

      -- 获取新加进来的 buffer
      local new_buffs = {}
      for _, _bufnr in pairs(Helper.get_all_bufs()) do
        if not Helper.is_unnamed_buf(_bufnr) then
          new_buffs[Helper.get_buf_name(_bufnr)] = _bufnr
        end
      end

      -- 仅当 bufferline 加载后
      while not this.api.is_plugin_loaded() do
        libP.async.util.sleep(1)
      end

      -- 按照顺序追加持久化的 buffers
      local final_buffs = {}
      for _, _data in pairs(pre_buffs) do
        if vim.fn.filereadable(_data.file) > 0 then
          local bufnr

          if new_buffs[_data.file] ~= nil then
            bufnr = new_buffs[_data.file]
          else
            bufnr = vim.fn.bufadd(_data.file)

            vim.bo[bufnr].buflisted = true
          end

          -- 此段逻辑会有一点延迟
          -- 当通过命令行打开的文件，则直接激活它，而不是使用持久化的buffer数据
          if _data.is_activation and not next(new_buffs) then
            Helper.switch_buffer(bufnr)
          end

          final_buffs[bufnr] = { file = _data.file, is_pinned = _data.is_pinned }

          libP.async.util.scheduler()
        end
      end
      for _file, _bufnr in pairs(new_buffs) do
        if final_buffs[_bufnr] == nil then
          final_buffs[_bufnr] = { file = _file, is_pinned = false }
        end
      end

      if Helper.is_unnamed_buf(1) then
        Helper.wipeout_buffer(1, true)
      end

      -- 等待 bufferline components 初始化完毕
      while true do
        local is_complete = true

        for _, _item in ipairs(BufferlineState.components) do
          local element = _item:as_element()

          if not final_buffs[element.id] then
            is_complete = false
            break
          end
        end

        if not is_complete or not next(BufferlineState.components) then
          libP.async.util.sleep(5)
        else
          break
        end
      end

      -- 设置 pinned buffer
      for _, _item in ipairs(BufferlineState.components) do
        local element = _item:as_element()
        local buf = final_buffs[element.id]

        if buf and buf.is_pinned then
          BufferlineGroup.add_element('pinned', element)

          libP.async.util.scheduler()
        end
      end

      BufferlineUI.refresh()
    end)
  )
end

return session

local session = {}

local events           = require('ngpong.common.events')
local lazy             = require('ngpong.utils.lazy')
local json             = require('ngpong.utils.json')
local async            = lazy.require('plenary.async')
local Path             = lazy.require('plenary.path')
local bufferline_state = lazy.require('bufferline.state')
local bufferline_group = lazy.require('bufferline.groups')
local bufferline_ui    = lazy.require("bufferline.ui")

local this = PLGS.bufferline
local e_events = events.e_name

session.setup = function()
  local path = Path.__get()

  local file = path:new(vim.fn.stdpath('data') .. '/bufferline/' .. TOOLS.get_workspace_sha1() .. '.json')

  events.rg(e_events.VIM_LEAVE_PRE, async.void(function()
    if not this.api.is_plugin_loaded() then
      return
    end

    if not file:exists() then
      file:touch({ parents = true })
    end

    local datas = {}
    for _, _item in ipairs(bufferline_state.components) do
      local element = _item:as_element()

      if not TOOLS.isempty(element.path) then
        table.insert(datas, {
          file = element.path,
          is_pinned = this.api.is_pinned(element),
          is_activation = HELPER.get_cur_bufnr() == element.id and true or false
        })
      end
    end

    file:write(json.encode(datas), 'w')
  end))

  events.rg(e_events.VIM_ENTER, async.void(function()
    if not file:exists() then
      return
    end

    local data = file:read()

    -- 获取持久化的 buffer
    local pre_buffs = json.decode(data)
    if not next(pre_buffs) then
      return
    end

    -- 获取新加进来的 buffer
    local new_buffs = {}
    for _, _bufnr in pairs(HELPER.get_all_bufs()) do
      if not HELPER.is_unnamed_buf(_bufnr) then
        new_buffs[HELPER.get_buf_name(_bufnr)] = _bufnr
      end
    end

    -- 仅当 bufferline 加载后
    while not this.api.is_plugin_loaded() do
      async.util.sleep(1)
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
          HELPER.switch_buffer(bufnr)
        end

        final_buffs[bufnr] = { file = _data.file, is_pinned = _data.is_pinned }

        async.util.scheduler()
      end
    end
    for _file, _bufnr in pairs(new_buffs) do
      if final_buffs[_bufnr] == nil then
        final_buffs[_bufnr] = { file = _file, is_pinned = false }
      end
    end

    -- 擦除第一个默认打开的 [NONAME] BUFFERS
    if HELPER.is_unnamed_buf(1) then
      HELPER.wipeout_buffer(1, true)
    end

    -- 等待 bufferline components 初始化完毕
    while true do
      local is_complete = true

      for _, _item in ipairs(bufferline_state.components) do
        local element = _item:as_element()

        if not final_buffs[element.id] then
          is_complete = false
          break
        end
      end

      if not is_complete or not next(bufferline_state.components) then
        async.util.sleep(5)
      else
        break
      end
    end

    -- 设置 pinned buffer
    for _, _item in ipairs(bufferline_state.components) do
      local element = _item:as_element()
      local buf = final_buffs[element.id]

      if buf and buf.is_pinned then
        bufferline_group.add_element("pinned", element)

        async.util.scheduler()
      end
    end

    bufferline_ui.refresh()
  end))
end

return session

local M = {}

local etypes = vim.__event.types

local setup_cursor_persist = function()
  local path = vim.__path.join(vim.__path.standard("data"), "cursor_presist", vim.__path.cwdsha1() .. ".json")

  local is_init = false

  local vim_enter = function(_)
    if is_init then
      return
    end

    if not vim.__fs.exists(path) then
      return
    end

    local data = vim.__fs.read(path)
    if vim.__util.isempty(data) then
      return
    end

    vim.__g.cursor_pos     = vim.json.decode(data) or {}
    vim.__g.cursor_persist = true

    -- 缓慢删除掉过期(一天未访问过的)的 key
    local cur = vim.__timestamp.get_utc() or 0
    local max = 1000 * 60 * 60 * 24 * 3 -- 3天
    for _k, _v in pairs(vim.__g.cursor_pos) do
      if cur - (_v.ts or 0) > max then
        vim.__g.cursor_pos[_k] = nil
      end
    end

    is_init = true
  end

  local vim_leave_pre = function(_)
    vim.__fs.makepath(vim.__path.dirname(path))
    vim.__fs.write(path, vim.json.encode(vim.__g.cursor_pos))
  end

  local cursor_normal = vim.__bouncer.throttle_trailing(400, true, vim.__async.schedule_wrap(function(args)
    if not vim.__buf.is_valid(args.buf) then
      return
    end

    if not args.file then
      return
    end

    -- 仅刷新指定文件类型的文件
    local ft = vim.__buf.filetype(args.buf)
    if vim.__filter.contain_fts(ft) then
      return
    end

    local relpath = vim.__path.relpath(args.file, vim.__path.cwd())

    local row, col = vim.__cursor.get()

    vim.__g.cursor_pos[relpath] = { row = row, col = col, ts = vim.__timestamp.get_utc() }
  end))

  local buffer_read_post = function(args)
    if not is_init then
      vim_enter()
    end

    -- hidden buffer 不更新
    if vim.__buf.is_listed(args.buf) then
      return
    end

    -- 浮动窗口下不更新
    local winid = vim.__win.current()
    if vim.__win.is_float(winid) then
      return
    end

    if not args.file then
      return
    end

    local relpath = vim.__path.relpath(args.file, vim.__path.cwd())

    local cache = vim.__g.cursor_pos[relpath]

    if cache and vim.__g.cursor_persist then
      vim.__cursor.set(cache.row, cache.col)
      vim.__key.press("zz") -- keep screen center
    end
  end

  vim.__event.rg(etypes.VIM_ENTER, vim_enter)

  vim.__event.rg(etypes.VIM_LEAVE_PRE, vim_leave_pre)

  vim.__event.rg(etypes.CURSOR_NORMAL, cursor_normal)

  vim.__event.rg(etypes.BUFFER_READ_POST, buffer_read_post)
end

local setup_bufferline_persist = function()
  local bufferline = vim._plugins.bufferline

  local path = vim.__path.join(vim.__path.standard("data"), "bufferline", vim.__path.cwdsha1() .. ".json")

  vim.__event.rg(etypes.VIM_LEAVE_PRE, vim.__async.void(function()
    if not bufferline.api.is_plugin_loaded() then
      return
    end

    vim.__fs.makepath(vim.__path.dirname(path))

    local datas = {}
    for _, _item in ipairs(bufferline.api.get_components()) do
      local element = _item:as_element()

      if element.name ~= "COMMIT_EDITMSG" and not vim.__util.isempty(element.path) then
        local is_pinned     = bufferline.api.is_pinned(element)
        local is_activation = bufferline.api.is_activation_element(element)

        datas[#datas+1] = {
          file = element.path,
          is_pinned = is_pinned,
          is_activation = is_activation,
        }
      end
    end

    vim.__fs.write(path, vim.json.encode(datas))
  end))

  vim.__event.rg(etypes.VIM_ENTER, vim.__async.void(function()
    if not vim.__fs.exists(path) then
      return
    end

    local data = vim.__fs.read(path)
    if vim.__util.isempty(data) then
      return
    end

    -- 获取持久化的 buffer
    local pre_buffs = vim.json.decode(data)
    if not next(pre_buffs) then
      return
    end

    -- 获取新加进来的 buffer
    local new_buffs = {}
    for _, _bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if not vim.__buf.is_unnamed(_bufnr) then
        new_buffs[vim.__buf.name(_bufnr)] = _bufnr
      end
    end

    -- 仅当 bufferline 加载后
    while not bufferline.api.is_plugin_loaded() do
      vim.__async.sleep(1)
    end

    -- 按照顺序追加持久化的 buffers
    local final_buffs = {}
    for _, _data in ipairs(pre_buffs) do
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
          vim.__buf.switch(bufnr)
        end

        final_buffs[bufnr] = { file = _data.file, is_pinned = _data.is_pinned }
      end
    end
    for _file, _bufnr in pairs(new_buffs) do
      if final_buffs[_bufnr] == nil then
        final_buffs[_bufnr] = { file = _file, is_pinned = false }
      end
    end

    if vim.__buf.is_unnamed(1) then
      vim.__buf.wipeout(1)
    end

    -- 等待 bufferline components 初始化完毕
    while true do
      local is_complete = true

      for _, _item in ipairs(bufferline.api.get_components()) do
        local element = _item:as_element()

        if not final_buffs[element.id] then
          is_complete = false
          break
        end
      end

      if not is_complete or not next(bufferline.api.get_components()) then
        vim.__async.sleep(1)
      else
        break
      end
    end

    -- 设置 pinned buffer
    for _, _item in ipairs(bufferline.api.get_components()) do
      local element = _item:as_element()
      local buf = final_buffs[element.id]

      if buf and buf.is_pinned then
        bufferline.api.pin(element)
      end
    end

    bufferline.api.refresh()
  end))
end

M.setup = function()
  setup_cursor_persist()
  -- setup_bufferline_persist()
end

return M

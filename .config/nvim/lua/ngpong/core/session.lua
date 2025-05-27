local BufferSession = vim.__class.def(function(this)
  local barbar_state  = vim.__lazy.require("barbar.state")
  local barbar_config = vim.__lazy.require("barbar.config")
  local barbar_render = vim.__lazy.require('barbar.ui.render')
  local barbar_bbye   = vim.__lazy.require("barbar.bbye")

  local buffer = require("string.buffer")

  local session_data = {}

  function this:__init()
    local session_file = vim.__path.join(
      vim.__path.standard("data"),
      "session",
      vim.__path.cwdsha1()
    )
    vim.__fs.makepath(vim.__path.dirname(session_file))

    local serialize_data = vim.__fs.read(session_file)
    if not vim.__util.isempty(serialize_data) then
      --- @type table
      session_data = buffer.decode(serialize_data) or {}
      for _, buffs in ipairs(session_data) do
        vim.__tbl.remove_iter(buffs, function(t, i, _)
          return vim.__fs.readable(t[i].path)
        end)
      end
    end

    vim.__autocmd.on("VimLeavePre", function()
      barbar_state.get_updated_buffers()

      local session_buffs = { date = os.date() }
      for _, bufnr in ipairs(barbar_state.buffers) do
        local bufdata = barbar_state.get_buffer_data(bufnr)

        local path          = vim.__buf.name(bufnr)
        local is_pinned     = bufdata.pinned or nil
        local is_activation = bufnr == barbar_state.last_current_buffer or nil

        if
          not bufdata.closing and
          not bufdata.will_close and
          vim.__fs.readable(path)
        then
          table.insert(session_buffs, {
            path = path,
            is_pinned = is_pinned,
            is_activation = is_activation
          })
        end
      end

      table.insert(session_data, 1, session_buffs)
      if #session_data > 5 then
        table.remove(session_data, nil) -- remove the last element
      end

      if next(session_data) then
        vim.__fs.write(session_file, buffer.encode(session_data))
      end
    end)

    vim.api.nvim_create_user_command("SessionSelect", function(_) this:select() end, {})
  end

  function this:debug()
    for _, buffs in ipairs(session_data) do
      vim.__logger.info(buffs)
    end
  end

  function this:get(idx)
    idx = idx or 1
    return session_data[idx]
  end

  function this:select()
    local items = {}
    for _, buffs in ipairs(session_data) do
      local t = {}
      for _, buff in ipairs(buffs) do
        table.insert(t, vim.__path.basename(buff.path))
      end
      table.insert(items, string.format("%s: %s", buffs.date, table.concat(t, " ")))
    end
    if not next(items) then
      return
    end

    vim.ui.select(items, { prompt = "Select restore session: " }, vim.__async.void(function(choice, idx)
      if not choice or not idx then
        return
      end

      for _, bufnr in ipairs(barbar_state.buffers) do
        barbar_bbye.bwipeout(true, bufnr)
        vim.__async.scheduler()
      end

      vim.__async.scheduler()
      this:load(idx)
    end))
  end

  function this:load(idx)
    barbar_config.options.insert_at_end = true

    local session_buffs = this:get(idx)
    if not session_buffs then
      return
    end

    -- 获取新加进来的 buffer
    local opened_buffs = {}
    for _, bufnr in ipairs(vim.__buf.all()) do
      local ft = vim.__buf.filetype(bufnr)
      local bt = vim.__buf.buftype(bufnr)

      local is_listed    = vim.__buf.is_listed(bufnr)
      local is_valid     = vim.__buf.is_valid(bufnr)
      local is_named     = not vim.__buf.is_unnamed(bufnr)
      local is_ft_permit = not vim.__filter.contain_fts(ft)
      local is_bt_permit = not vim.__filter.contain_bts(bt)

      if
        is_named and is_valid and is_listed and is_ft_permit and is_bt_permit
      then
        opened_buffs[vim.__buf.name(bufnr)] = bufnr
      end
    end
    local has_opened_files = next(opened_buffs) ~= nil

    -- 按照顺序追加持久化的buffers
    local pinned_buffs = {}
    for _, buff in ipairs(session_buffs) do
      local path  = buff.path
      local bufnr = opened_buffs[path]

      if not bufnr then
        bufnr = vim.__buf.add(path)
        vim.bo[bufnr].buflisted = true
      end

      if buff.is_activation and not has_opened_files then
        vim.__buf.switch(bufnr)
      end

      if buff.is_pinned then
        table.insert(pinned_buffs, bufnr)
      end
    end

    -- 移除首个未命名的buff；仅当没有显示（命令行）打开任何 buff 的情况下
    if not has_opened_files then
      for _, bufnr in ipairs(barbar_state.buffers) do
        if vim.__buf.is_unnamed(bufnr) then
          barbar_bbye.bwipeout(true, bufnr)
          break
        end
      end
    end

    -- 设置pinned-buffer
    for _, bufnr in ipairs(pinned_buffs) do
      require("barbar.state").toggle_pin(bufnr)
    end

    barbar_render.update()
    barbar_config.options.insert_at_end = false
  end
end)

local CursorSession = vim.__class.def(function(this)
  function this:__init()
    -- restore cursor position when opening a file
    --  # https://github.com/neovim/neovim/issues/16339
    vim.__autocmd.on("BufRead", function(state)
      local bufnr = state.buf

      vim.__autocmd.on("BufWinEnter", function(_)
        local buftype = vim.__buf.buftype(bufnr)
        if vim.__filter.contain_bts(buftype) then
          return
        end

        local filetype = vim.__buf.filetype(bufnr)
        if vim.__filter.contain_fts(filetype) then
          return -- vim.cmd[[normal! gg]] reset cursor to first line
        end

        local last_line = vim.fn.line([['"]])
        local buff_last_line = vim.fn.line("$")

        -- If the last line is set and the less than the last line in the buffer
        if last_line > 0 and last_line <= buff_last_line then
          local win_last_line = vim.fn.line("w$")
          local win_first_line = vim.fn.line("w0")
          -- Check if the last line of the buffer is the same as the win
          if win_last_line == buff_last_line then
            -- Set line to last line edited
            vim.cmd[[normal! g`"]]
            -- Try to center
          elseif buff_last_line - last_line > ((win_last_line - win_first_line) / 2) - 1 then
            vim.cmd[[normal! g`"zz]]
          else
            vim.cmd[[normal! G'"<c-e>]]
          end
        end
      end, { once = true, buffer = bufnr })
    end)
  end
end)

return {
  buffer = BufferSession:new(),
  cursor = CursorSession:new(),
}

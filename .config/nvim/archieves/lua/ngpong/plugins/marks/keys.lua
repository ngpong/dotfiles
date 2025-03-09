local M = {}

local Marks = vim.__lazy.require("marks")

local m_api = vim._plugins.marks.api
local t_api = vim._plugins.trouble.api

local kmodes = vim.__key.e_mode

local del_native_keymaps = function()
  vim.__key.unrg({ kmodes.N, kmodes.S, kmodes.VS }, "m")
end

local set_native_keymaps = function()
  for code = string.byte("a"), string.byte("z") do
    local lower = string.char(code)
    local upper = string.upper(lower)

    -- mark set
    do
      -- lowercase
      local lower_lhs = "ms" .. lower
      local lower_rhs = vim.__util.wrap_f(m_api.set, lower)
      vim.__key.rg(kmodes.N, lower_lhs, lower_rhs, { desc = "" .. lower .. "" })

      -- uppercase
      local upper_lhs = "ms" .. upper
      local upper_rhs = vim.__util.wrap_f(m_api.set, upper)
      vim.__key.rg(kmodes.N, upper_lhs, upper_rhs, { desc = "" .. upper .. "" })
    end

    -- mark delete
    do
      -- lowercase
      local lower_lhs = "md" .. lower
      local lower_rhs = vim.__util.wrap_f(m_api.del, lower)
      vim.__key.rg(kmodes.N, lower_lhs, lower_rhs, { desc = "" .. lower .. "" })

      -- uppercase
      local upper_lhs = "md" .. upper
      local upper_rhs = vim.__util.wrap_f(m_api.del, upper)
      vim.__key.rg(kmodes.N, upper_lhs, upper_rhs, { desc = "" .. upper .. "" })
    end

    -- mark jump
    do
      -- lowercase
      local lower_lhs = "me" .. lower
      local lower_rhs = vim.__util.wrap_f(m_api.jump, lower)
      vim.__key.rg(kmodes.N, lower_lhs, lower_rhs, { desc = "" .. lower .. "" })

      -- uppercase
      local upper_lhs = "me" .. upper
      local upper_rhs = vim.__util.wrap_f(m_api.jump, upper)
      vim.__key.rg(kmodes.N, upper_lhs, upper_rhs, { desc = "" .. upper .. "" })
    end
  end

  vim.__key.rg(kmodes.N, "m[", function()
    m_api.jump_2_prev()
  end, { desc = "jump to prev." })
  vim.__key.rg(kmodes.N, "m]", function()
    m_api.jump_2_next()
  end, { desc = "jump to next." })
  vim.__key.rg(kmodes.N, "ms<leader>", vim.__util.wrap_f(vim.__lazy.access("marks", "set_next")), { desc = "[NEXT]" })
  vim.__key.rg(kmodes.N, "md<leader>", function()
    local bufnr = vim.__buf.current()
    local row, _ = vim.__cursor.get()

    local datas = Marks.mark_state.buffers[bufnr].marks_by_line[row]
    if not datas then
      return
    end

    local delete_marks = {}
    for _, _mark in pairs(datas) do
      delete_marks[#delete_marks+1] = _mark
    end

    table.sort(delete_marks, function(r, l)
      return string.byte(r) < string.byte(l)
    end)

    local texts = {}
    for _, _mark in pairs(delete_marks) do
      texts[#texts+1] = string.format("[[%s]]", _mark)
    end

    Marks.delete_line()
    m_api.on_mark_change()

    if next(texts) then
      vim.__notifier.info(string.format("Success to delete marks %s", table.concat(texts, " ")))
    end
  end, { desc = "<LINE>" })
  vim.__key.rg(kmodes.N, "md<CR>", function()
      local bufnr = vim.__buf.current()

      local datas = Marks.mark_state.buffers[bufnr].marks_by_line
      if not datas then
        return
      end

      local delete_marks = {}
      for _, _marks in pairs(datas) do
        for _, _mark in pairs(_marks) do
          delete_marks[#delete_marks+1] = _mark
        end
      end

      table.sort(delete_marks, function(r, l)
        return string.byte(r) < string.byte(l)
      end)

      local texts = {}
      for _, _mark in pairs(delete_marks) do
        texts[#texts+1] = string.format("[[%s]]", _mark)
      end

      m_api.dels(delete_marks)

      if next(texts) then
        vim.__notifier.info(string.format("Success to delete marks %s", table.concat(texts, " ")))
      end
    end,
    { desc = "<BUFFER>" }
  )
  vim.__key.rg(kmodes.N, "mm", vim.__util.wrap_f(t_api.toggle, "mark"), { silent = true, desc = "toggle document marks list." })
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()
end

return M

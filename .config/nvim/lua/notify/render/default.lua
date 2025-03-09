local Base = vim.__lazy.require("notify.render.base")

return function(bufnr, notif, highlights, config)
  local message_size = #notif.message
  for i = 1, message_size do
    notif.message[i] = " " .. notif.message[i]
  end

  local left_icon = notif.icon .. " "
  local max_message_width = math.max(math.max(unpack(vim.tbl_map(function(line)
    return vim.fn.strchars(line)
  end, notif.message))))
  local right_title = notif.title[2]
  local left_title = notif.title[1]:upper()
  local title_accum = vim.str_utfindex(left_icon) + vim.str_utfindex(right_title) + vim.str_utfindex(left_title)

  local left_buffer = string.rep(" ", math.max(0, max_message_width - title_accum))

  local namespace = Base.namespace()
  vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, { "", "" })
  vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
    virt_text = {
      { " " },
      { left_icon, highlights.icon },
      { left_title .. left_buffer, highlights.title },
    },
    virt_text_win_col = 0,
    priority = 10,
  })
  vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
    virt_text = { { " " }, { right_title, highlights.title }, { " " } },
    virt_text_pos = "right_align",
    priority = 10,
  })
  vim.api.nvim_buf_set_extmark(bufnr, namespace, 1, 0, {
    virt_text = {
      {
        string.rep("-", math.max(vim.str_utfindex(left_buffer) + title_accum + 2, config.minimum_width())),
        highlights.border,
      },
    },
    virt_text_win_col = 0,
    priority = 10,
  })
  vim.api.nvim_buf_set_lines(bufnr, 2, -1, false, notif.message)

  vim.api.nvim_buf_set_extmark(bufnr, namespace, 2, 0, {
    hl_group = highlights.body,
    end_line = 1 + message_size,
    end_col = #notif.message[message_size],
    priority = 50, -- Allow treesitter to override
  })
end

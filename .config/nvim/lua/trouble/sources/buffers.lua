local M = {}

M.config = {
  formatters = {
    buf_info = function(ctx)
      local item = ctx.item

      local bufnr = item.item.bufnr
      local flags = item.item.flags

      local max_buf_width  = item.item.max_buf_width
      local max_flag_width = item.item.max_flag_width

      local form = {}

      if bufnr then
        table.insert(form, {
          text = vim.__str.align(tostring(bufnr), max_buf_width),
          hl = "TroubleBuffersBufnr",
        })
      end

      if flags then
        table.insert(form, {
          text = " "
        })
        table.insert(form, {
          text = vim.__str.align(flags, max_flag_width),
          hl = "TroubleBuffersFlags",
        })
      end

      if next(form) then
        table.insert(form, {
          text = " ",
        })
      end

      return form
    end,
  },
  modes = {
    buffers = {
      title = "{hl:TroubleTitle}Buffers",
      events = {
        { event = "User", pattern = { "TroubleBuffersRefresh" } },
      },
      sort = { "barbar_idx" },
      desc = "Buffers",
      source = "buffers",
      format = "{buf_info}{file}{text:ts}",
    },
  },
}

function M.setup()
  vim.api.nvim_set_hl(0, "TroubleBuffersBufnr", { fg = vim.__color.bright_purple })
  vim.api.nvim_set_hl(0, "TroubleBuffersFlags", { link = "NonText" })

  local emit_statechanged = vim.__bouncer.throttle_trailing(
    100,
    true,
    vim.schedule_wrap(function()
      vim.__autocmd.exec("User", { pattern = "TroubleBuffersRefresh" })
    end)
  )

  local org_set_tabline = require("barbar.ui.render").set_tabline
  vim.__autocmd.on("User", function(args)
    if args.data.mode ~= "buffers" then
      return
    end

    local last_tabline = ""
    require("barbar.ui.render").set_tabline = function(s)
      org_set_tabline(s)

      if last_tabline ~= s then
        last_tabline = s
        emit_statechanged()
      end
    end
  end, { pattern = "TroubleWinMount" })
  vim.__autocmd.on("User", function(args)
    if args.data.mode ~= "buffers" then
      return
    end

    require("barbar.ui.render").set_tabline = org_set_tabline
  end, { pattern = "TroubleWinClose" })
end

function M.get(cb, ctx)
  local Item = require("trouble.item")

  local BarbarState = require("barbar.state")
  BarbarState.get_updated_buffers()

  local current_buf = vim.__buf.current()
  local alternate_buf = vim.fn.bufnr("#")

  local items = {}
  local barbar_idx, max_bufnr, max_flag_width = 0, -1, -1
  for _, bufnr in ipairs(BarbarState.buffers) do
    local bufmark = vim.__buf.mark(bufnr, "\"")
    local bufname = vim.__buf.name(bufnr)
    local bufinfo = vim.__buf.info(bufnr)[1]

    local is_current     = current_buf == bufnr
    local is_alternate   = bufnr == alternate_buf
    local is_pinned      = BarbarState.is_pinned(bufnr)
    local is_readonly    = vim.bo[bufnr].readonly
    local is_hidden      = bufinfo.hidden == 1
    local is_changed     = bufinfo.changed == 1
    local is_attach_wins = #(bufinfo.windows or {}) > 0
    local is_loaded      = vim.__buf.is_loaded(bufnr)

    local flags = {}
    if is_current then
      table.insert(flags, "%")
    elseif is_alternate then
      table.insert(flags, "#")
    end
    if is_hidden then
      table.insert(flags, "h")
    elseif is_attach_wins then
      table.insert(flags, "a")
    end
    if is_readonly then
      table.insert(flags, "=")
    end
    if is_changed then
      table.insert(flags, "+")
    end
    if is_pinned then
      table.insert(flags, "P")
    end

    local pos, line
    if vim.__fs.executable(bufname) then
      pos = { 0, 0 }
      line = ""
    elseif is_loaded then
      pos = { bufinfo.lnum, 0 }
      line = vim.__buf.getline(bufnr, bufinfo.lnum)
    elseif not vim.__util.isempty(bufname) then
      pos = { bufmark[1], 0 }
      line = vim.__fs.getline(bufname, bufmark[1])
    else
      pos = { 1, 0 }
    end
    if line then
      line = vim.trim(line)
    end

    bufname = bufname == "" and "[No Name]" or bufname
    barbar_idx = barbar_idx + 1
    max_bufnr = math.max(bufnr, max_bufnr)
    max_flag_width = math.max(#flags, max_flag_width)

    table.insert(items, Item.new({
      buf = bufnr,
      filename = bufname,
      pos = pos,
      end_pos = pos,
      source = "buffers",
      item = {
        bufnr = bufnr,
        barbar_idx = barbar_idx,
        text = line,
        flags = table.concat(flags),
        is_pinned = BarbarState.is_pinned(bufnr),
      }
    }))
  end

  local max_buf_width = #tostring(max_bufnr)
  for _, i in ipairs(items) do
    i.id = Item.generate_id(i)
    i.item.max_flag_width = max_flag_width
    i.item.max_buf_width = max_buf_width
  end

  cb(items)
end

return M

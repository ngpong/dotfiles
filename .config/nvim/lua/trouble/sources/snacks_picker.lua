local cache_converter = vim.__class.def(function(this)
  local m_converter = setmetatable({}, {
    __index = function(t, k)
      rawset(t, k, {})
      return rawget(t, k)
    end,
  })

  local function new_troubleitem(opts)
    local Item = require("trouble.item")

    opts.source = "snacks_picker"
    if not opts.pos then
      opts.pos = { 1, 0 }
      opts.end_pos = { 1, 0 }
    end

    local item = Item.new(opts)
    item.id = Item.generate_id(item)

    return item
  end

  function this:get(source)
    return rawget(m_converter, source)
  end

  function m_converter.buffers:snacks_2_trouble(i)
    return new_troubleitem({
      buf = i.buf,
      filename = i.file,
      pos = i.pos,
      end_pos = i.pos,
      item = {
        bufnr = i.bufnr,
        text = i.line,
        flags = i.flags,
        max_flag_width = i.max_flag_width,
        max_buf_width = i.max_bufnr_width,
        is_pinned = i.is_pinned,
      }
    })
  end

  function m_converter.diagnostics:snacks_2_trouble(i)
    return new_troubleitem({
      filename = i.file,
      pos = i.pos,
      end_pos = i.end_pos,
      item = {
        code = i.item.code,
        message = i.item.message,
        severity = i.item.severity,
        source = i.item.source,
      }
    })
  end
  function m_converter.diagnostics_buffer:snacks_2_trouble(i)
    return new_troubleitem({
      filename = i.file,
      pos = i.pos,
      end_pos = i.end_pos,
      item = {
        code = i.item.code,
        message = i.item.message,
        severity = i.item.severity,
        source = i.item.source,
      }
    })
  end

  function m_converter.bookmarks:snacks_2_trouble(i)
    return new_troubleitem({
      filename = i.file,
      pos = i.pos,
      end_pos = i.pos,
      item = {
        bmid = i.bmid,
        alias = i.alias,
        text = i.line,
      }
    })
  end

  function m_converter.lines:snacks_2_trouble(i)
    return new_troubleitem({
      filename = vim.__buf.name(i.buf),
      pos = i.pos,
      end_pos = i.pos,
      item = {
        text = i.text,
      }
    })
  end

  function m_converter.files:snacks_2_trouble(i)
    return new_troubleitem({
      filename = i._path,
    })
  end
  function m_converter.files:trouble_2_snacks(i)
    return {
      _path = i.filename,
    }
  end

  function m_converter.grep:snacks_2_trouble(i)
    return new_troubleitem({
      filename = i.file,
      pos = i.pos,
      end_pos = i.end_pos,
      item = {
        text = i.line,
      }
    })
  end
  function m_converter.grep:trouble_2_snacks(i)
    return {
      file = i.filename,
      pos = i.pos,
      end_pos = i.end_pos,
      line = i.item.text
    }
  end
end):new()

local cache_manager = vim.__class.def(function(this)
  local m_datas = {}
  local m_iter = 1

  function this:__init()
    local buffer = require("string.buffer")

    local file = vim.__path.join(
      vim.__path.standard("data"),
      "trouble_snacks_picker",
      vim.__path.cwdsha1()
    )
    vim.__fs.makepath(vim.__path.dirname(file))

    local serialize_data = vim.__fs.read(file)
    if not vim.__util.isempty(serialize_data) then
      ---@diagnostic disable-next-line
      local persist_datas = buffer.decode(serialize_data) or {}
      for i = #persist_datas, 1, -1 do
        local persist_data = persist_datas[i]

        local persist_source = persist_data.source
        local persist_date   = persist_data.date
        local persist_items  = persist_data._

        local cvrt = cache_converter:get(persist_source)

        local data = this:append(persist_source, persist_date)
        local items = data._

        for _, pi in ipairs(persist_items) do
          table.insert(items, cvrt:snacks_2_trouble(pi))
        end
      end
    end

    vim.__autocmd.on("VimLeavePre", function()
      local persist_datas = {}

      for _, data in ipairs(m_datas) do
        local source = data.source
        local date   = data.date

        local cvrt = cache_converter:get(source)
        if cvrt.trouble_2_snacks ~= nil then
          local persist_items = {}
          table.insert(persist_datas, {
            _ = persist_items,
            source = source,
            date = date
          })

          for _, item in ipairs(data._) do
            table.insert(persist_items, cvrt:trouble_2_snacks(item))
          end
        end
      end

      if next(persist_datas) then
        vim.__fs.write(file, buffer.encode(persist_datas))
      end
    end)
  end

  function this:max()
    return 10
  end

  function this:append(source, date)
    local data = {
      _ = {},
      source = source,
      date = date or os.date()
    }

    table.insert(m_datas, 1, data)
    if #m_datas > this:max() then
      m_datas[#m_datas] = nil
    end

    return data
  end

  function this:forward()
    m_iter = m_iter + 1
    if m_iter > #m_datas then m_iter = 1 end
  end

  function this:backward()
    m_iter = m_iter - 1
    if m_iter <= 0 then m_iter = #m_datas end
  end

  function this:move_to(idx)
    m_iter = idx
  end

  function this:get()
    return m_datas[m_iter]
  end

  function this:state()
    local data = m_datas[m_iter]
    return data.source, data.date, m_iter, #m_datas, this:max()
  end
end):new()

local M = {}

function M.setup()
  vim.api.nvim_set_hl(0, "TroublePickerState", { fg = vim.__color.bright_red, bold = true })
  vim.api.nvim_set_hl(0, "TroublePickerTitleDate", { fg = vim.__color.dark3 })

  vim.__autocmd.on("User", function(args)
    local bufnr = args.buf

    if not vim.__trouble:find_view({ mode = "snacks_picker", bufnr = bufnr }) then
      return
    end

    vim.__key.rg("n", "<", function()
      cache_manager:backward()
      vim.__autocmd.exec("User", { pattern = "TroublePickerSwitchSource" })
    end, { buffer = args.buf })

    vim.__key.rg("n", ">", function()
      cache_manager:forward()
      vim.__autocmd.exec("User", { pattern = "TroublePickerSwitchSource" })
    end, { buffer = args.buf })
  end, { pattern = "TroubleWinMount" })
end

function M.open(picker)
  local source = picker.init_opts.source

  local cvrt = cache_converter:get(source)
  if not cvrt then
    return
  end

  local selected = picker:selected()
  if not next(selected) then
    return
  end

  cache_manager:move_to(1)

  local data = cache_manager:append(source, os.date())
  local items = data._
  for _, i in ipairs(selected) do
    table.insert(items, cvrt:snacks_2_trouble(i))
  end

  picker:close()
  vim.schedule(function()
    vim.__trouble:open("snacks_picker")
  end)
end

function M.get(cb, _)
  local data = cache_manager:get()

  local items
  if data then
    items = data._
  else
    items = {}
  end

  cb(items)
end

M.config = {
  formatters = {
    snacks_picker_title = function(_)
      local source, date, iter, count, max = cache_manager:state()
      return {
        {
          text = string.format("Picker: %s ", source),
          hl = "TroubleTitle"
        },
        {
          text = string.format("[%d, %d/%d] ", iter, count, max),
          hl = "TroublePickerState"
        },
        {
          text = string.format("%s", date),
          hl = "TroublePickerTitleDate"
        },
      }
    end,
  },
  modes = {
    snacks_picker = {
      title = "{snacks_picker_title}",
      events = {
        { event = "User", pattern = { "TroublePickerSwitchSource" } },
      },
      source = "snacks_picker",
      format = "{buf_info}{diagnostic_info}{file}{bookmarkinfo}{text:ts}",
    },
  },
}

return M

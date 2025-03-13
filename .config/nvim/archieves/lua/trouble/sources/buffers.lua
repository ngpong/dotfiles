local M = {}

local Item = vim.__lazy.require("trouble.item")

M.config = {
  formatters = {
    buffers_pos = function(ctx)
      if ctx.item.has_pos then
        return {
          text = "[" .. ctx.item.pos[1] .. "," .. (ctx.item.pos[2] + 1) .. "]",
          hl = "TroubleBufferPos",
        }
      else
        return {
          text = "",
        }
      end
    end,
    bufnr = function(ctx)
      local bufnr = tostring(ctx.item.bufnr)

      local text
      if #bufnr < ctx.opts.max_buf_width then
        text = vim.__str.fill_tail(tostring(ctx.item.bufnr), vim.__icons.space, ctx.opts.max_buf_width - #bufnr)
      else
        text = bufnr
      end

      if ctx.item.is_current then
        return {
          text = text,
          hl = "TroubleBufferCurrent",
        }
      else
        return {
          text = text,
          hl = "TroubleBufferInactive",
        }
      end
    end,
    buffer_pinned = function(ctx)
      if not ctx.opts.is_has_pinned then
        return {
          text = "",
        }
      else
        if ctx.item.is_pinned then
          return {
            text = vim.__icons.pinned_3 .. " "
          }
        else
          return {
            text = "   "
          }
        end
      end
    end
  },
  modes = {
    buffers = {
      events = {
        "BufDelete",
        "BufAdd",
        { event = "User", pattern = { "BufferLineStateChange" } },
        { event = "User", pattern = { "NeotreeDeletedFile", "NeotreeMovedFile", "NeotreeRenamedFile" } }
      },
      desc = "Buffers",
      source = "buffers",
      sort = { "idx" },
      format = "{bufnr} {buffer_pinned}{file_icon}{filename}{comma} {text:ts} {buffers_pos}",
    },
  },
}

function M.setup()
  vim.api.nvim_set_hl(0, "TroubleBufferPos", { fg = vim.__color.dark3 })
  vim.api.nvim_set_hl(0, "TroubleBufferCurrent", { fg = vim.__color.bright_yellow })
  vim.api.nvim_set_hl(0, "TroubleBufferInactive", { fg = vim.__color.dark3 })
end

function M.get(cb, ctx)
  local b_api = vim._plugins.bufferline.api

  local items = {}

  local workspace = vim.__path.cwd()
  local current_bufnr = vim.__buf.current()

  local idx, max_bufnr = 0, 0
  for _, _data in ipairs(b_api.get_components() or {}) do
    if not vim.__buf.is_valid(_data.id) then
      goto continue
    end

    max_bufnr = math.max(_data.id, max_bufnr)

    local pos = vim.__g.cursor_pos[vim.__path.relpath(_data.path, workspace)]

    local lnum, col = 1, 0
    if pos then
      lnum = pos.row
      col = pos.col
    end

    local text = vim.__fs.getline(_data.path, lnum)
    if not text then
      lnum = vim.__fs.maxline(_data.path)
      col = 0
    end

    local item = {
      bufnr = tostring(_data.id),
      idx = idx,
      filename = _data.path,
      lnum = lnum,
      col = col,
      text = text,
      is_pinned = b_api.is_pinned(_data.id),
      is_current = _data.id == current_bufnr,
      has_pos = not not pos,
    }

    items[#items + 1] = Item.new({
      buf = vim.fn.bufadd(item.filename),
      max_buf = "aaa",
      pos = { item.lnum, col },
      end_pos = { item.lnum, col },
      text = item.text,
      filename = item.filename,
      item = item,
      source = "buffers",
      is_pinned = item.is_pinned
    })

    idx = idx + 1

    ::continue::
  end
  Item.add_id(items)

  ctx.opts.max_buf_width = #tostring(max_bufnr)
  ctx.opts.is_has_pinned = b_api.is_pinned("all")

  cb(items)
end

return M
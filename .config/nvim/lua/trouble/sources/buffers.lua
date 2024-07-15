-- stylua: ignore start
local Icons   = require('ngpong.utils.icon')
local Lazy    = require('ngpong.utils.lazy')
local libP    = require('ngpong.common.libp')
local Autocmd = require('ngpong.common.autocmd')
local Item    = Lazy.require('trouble.item')

local colors     = Plgs.colorscheme.colors
local bufferline = Plgs.bufferline
-- stylua: ignore end

local M = {}

M.config = {
  formatters = {
    buffers_pos = function(ctx)
      if ctx.item.has_pos then
        return {
          text = '[' .. ctx.item.pos[1] .. ',' .. (ctx.item.pos[2] + 1) .. ']',
          hl = 'GruvboxBg3',
        }
      else
        return {
          text = '',
        }
      end
    end,
    bufnr = function(ctx)
      local max_buf_width = #ctx.item.max_buf
      local bufnr = tostring(ctx.item.bufnr)

      local text
      if #bufnr < max_buf_width then
        text = Helper.sfill_tail(tostring(ctx.item.bufnr), Icons.space, max_buf_width - #bufnr)
      else
        text = bufnr
      end

      if ctx.item.is_current then
        return {
          text = text,
          hl = 'GruvboxYellow',
        }
      else
        return {
          text = text,
          hl = 'GruvboxBg3',
        }
      end
    end,
    buffer_pinned = function(ctx)
      if not ctx.item.is_has_pinned then
        return {
          text = '',
        }
      else
        if ctx.item.is_pinned then
          return {
            text = Icons.pinned_3 .. ' '
          }
        else
          return {
            text = '   '
          }
        end
      end
    end
  },
  modes = {
    buffers = {
      events = { 'BufDelete', 'BufAdd', { event = 'User', pattern = { 'BufferLineStateChange' } } },
      desc = 'Buffers',
      source = 'buffers',
      sort = { 'idx' },
      format = '{bufnr} {buffer_pinned}{file_icon}{filename} {text:ts} {buffers_pos}',
    },
  },
}

function M.fetch_list()
  local results = {}

  local workspace = Tools.get_workspace()
  local bufnr = Helper.get_cur_bufnr()
  local cursor_cache = Variable.get('cursor_presist_native') or {}

  local idx, max_bufnr = 0, 0
  for _, _data in ipairs(Plgs.bufferline.api.get_components() or {}) do
    local rel_path = libP.path:new(_data.path):make_relative(workspace)

    local pos = cursor_cache[rel_path]

    local lnum, col = 0, 0
    if pos then
      lnum = pos.row
      col = pos.col + 1
    end

    max_bufnr = math.max(_data.id, max_bufnr)

    table.insert(results, {
      bufnr = tostring(_data.id),
      idx = idx,
      filename = _data.path,
      lnum = lnum,
      col = col,
      text = Helper.getline(_data.path, lnum),
      is_pinned = bufferline.api.is_pinned(_data.id),
      is_current = _data.id == bufnr,
      has_pos = not not pos,
    })

    idx = idx + 1
  end

  return results, tostring(max_bufnr)
end

function M.get(cb, ctx)
  local items = {}

  local results, max_bufnr, is_has_pinned

  is_has_pinned = bufferline.api.is_pinned('all')
  results, max_bufnr = M.fetch_list()

  for _, _item in ipairs(results or {}) do
    items[#items + 1] = Item.new({
      buf = vim.fn.bufadd(_item.filename),
      max_buf = max_bufnr,
      pos = { _item.lnum, 0 },
      end_pos = { _item.lnum, vim.v.maxcol },
      text = _item.text,
      filename = _item.filename,
      item = _item,
      source = 'buffers',
      is_has_pinned = is_has_pinned,
      is_pinned = _item.is_pinned
    })
  end

  Item.add_id(items)

  cb(items)
end

return M

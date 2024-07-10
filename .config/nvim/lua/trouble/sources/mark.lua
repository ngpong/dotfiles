-- stylua: ignore start
local Icons = require('ngpong.utils.icon')
local Lazy  = require('ngpong.utils.lazy')
local libP  = require('ngpong.common.libp')
local Marks = Lazy.require('marks')
local Item  = Lazy.require('trouble.item')

local colors = Plgs.colorscheme.colors
-- stylua: ignore end

local M = {}

M.config = {
  formatters = {
    mark_icon = function(ctx)
      if ctx.item.tag == 'Uppercase mark' then
        return {
          text = Icons.chars_4,
          hl = 'GruvboxRed',
        }
      else
        return {
          text = Icons.chars_5,
          hl = 'GruvboxAqua',
        }
      end
    end,
    mark_text = function(ctx)
      if ctx.item.tag == 'Uppercase mark' then
        return {
          text = ctx.item.mark,
          hl = 'MarkTextRed',
        }
      else
        return {
          text = ctx.item.mark,
          hl = 'MarkTextAqua',
        }
      end
    end,
  },
  modes = {
    mark = {
      events = { 'BufEnter', 'BufWritePost', { event = 'User', pattern = { 'MarkDeleteUser', 'MarkSetUser' } } },
      source = 'mark',
      groups = {
        { 'filename', format = '{file_icon}{filename} {count}' },
      },
      sort = { { buf = 0 }, 'filename', 'pos' },
      format = '{mark_icon} {mark_text} {text:ts} {pos}',
    },
  },
}

function M.setup()
  vim.api.nvim_set_hl(0, 'MarkTextAqua', { fg = colors.bright_aqua, italic = true })
  vim.api.nvim_set_hl(0, 'MarkTextRed', { fg = colors.bright_red, italic = true })
end

function M.fetch_list(all)
  local results = {}

  local cache = Marks.mark_state.buffers
  if not next(cache) then
    return results
  end

  local bufnr = Helper.get_cur_bufnr()
  for _mark, _data in pairs(cache[bufnr] and cache[bufnr].placed_marks or {}) do
    if Plgs.marks.api.is_lower_mark(_mark) then
      table.insert(results, {
        filename = Helper.get_buf_name(bufnr),
        tag = 'Lowercase mark',
        mark = _mark,
        lnum = _data.line,
        col = vim.v.maxcol,
        text = Helper.getline(bufnr, _data.line),
      })
    end
  end

  if all then
    local workspace = Tools.get_workspace()

    for _, _data in ipairs(vim.fn.getmarklist()) do
      local mark = _data.mark:sub(2, 3)

      if Plgs.marks.api.is_upper_mark(mark) then
        local row = _data.pos[2]
        local col = _data.pos[3]

        local file_path = libP.path:new(_data.file):expand()

        if file_path:match(workspace) then
          table.insert(results, {
            filename = file_path,
            tag = 'Uppercase mark',
            lnum = row,
            mark = mark,
            col = vim.v.maxcol,
            text = Helper.getline(file_path, row),
          })
        end
      end
    end
  end

  return results
end

function M.get(cb, ctx)
  local params = ctx.opts.params or {}

  local items = {}
  for _, _item in ipairs(M.fetch_list(params.all) or {}) do
    items[#items + 1] = Item.new({
      buf = vim.fn.bufadd(_item.filename),
      pos = { _item.lnum, 0 },
      end_pos = { _item.lnum, _item.col },
      text = _item.text,
      filename = _item.filename,
      item = _item,
      source = 'mark',
    })
  end

  cb(items)
end

return M

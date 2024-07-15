-- stylua: ignore start
local Autocmd = require('ngpong.common.autocmd')
local Icons   = require('ngpong.utils.icon')
local Lazy    = require('ngpong.utils.lazy')
local libP    = require('ngpong.common.libp')
local Marks   = Lazy.require('marks')
local Item    = Lazy.require('trouble.item')
local Cache   = Lazy.require("trouble.cache")

local colors = Plgs.colorscheme.colors
-- stylua: ignore end

local M = {}

M.config = {
  formatters = {
    mark_text = function(ctx)
      return {
        text = ctx.item.mark,
        hl = 'MarkSignHL',
      }
    end,
  },
  modes = {
    mark = {
      events = { 'BufEnter', 'BufWritePost', { event = 'User', pattern = { 'MarkChanged' } } },
      source = 'mark',
      desc = 'Marks',
      groups = {
        { 'filename', format = '{file_icon}{filename} {count}' },
      },
      sort = { { buf = 0 }, 'filename', 'pos' },
      format = '{mark_text} {text:ts} {pos}',
    },
  },
}

function M.setup()
  vim.api.nvim_set_hl(0, 'MarkTextAqua', { fg = colors.bright_aqua, italic = true })
  vim.api.nvim_set_hl(0, 'MarkTextRed', { fg = colors.bright_red, italic = true })

  local group = Autocmd.new_augroup('trouble_mark')

  group.on('User', function(_)
    Cache.mark:clear()
  end, 'MarkChanged')

  group.on('BufWritePost', function(_)
    Cache.mark:clear()
  end)
end

function M.fetch_list(global)
  local bufnr = Helper.get_cur_bufnr()

  local items = {}

  if not global then
    local trouble_cache = Cache.mark[bufnr]
    if trouble_cache then
      Tools.array_insert(items, trouble_cache)
    else
      local cache_mark = Marks.mark_state.buffers[bufnr] or {}

      for _mark, _data in pairs(cache_mark and cache_mark.placed_marks or {}) do
        if Plgs.marks.api.is_lower_mark(_mark) then
          local _item = {
            filename = Helper.get_buf_name(bufnr),
            tag = 'Lowercase mark',
            mark = _mark,
            lnum = _data.line,
            col = vim.v.maxcol,
            text = Helper.getline(bufnr, _data.line),
          }

          table.insert(
            items,
            Item.new({
              buf = vim.fn.bufadd(_item.filename),
              pos = { _item.lnum, 0 },
              end_pos = { _item.lnum, _item.col },
              text = _item.text,
              filename = _item.filename,
              item = _item,
              source = 'mark',
            })
          )
        end
      end

      if next(items) then
        Cache.mark[bufnr] = items
      end
    end
  else
    local trouble_cache = Cache.mark['global']
    if trouble_cache then
      Tools.array_insert(items, trouble_cache)
    else
      local workspace = Tools.get_workspace()

      for _, _data in ipairs(vim.fn.getmarklist()) do
        local mark = _data.mark:sub(2, 3)

        if Plgs.marks.api.is_upper_mark(mark) then
          local row = _data.pos[2]
          local col = _data.pos[3]

          local file_path = libP.path:new(_data.file):expand()

          if file_path:match(workspace) then
            local _item = {
              filename = file_path,
              tag = 'Uppercase mark',
              lnum = row,
              mark = mark,
              col = vim.v.maxcol,
              text = Helper.getline(file_path, row),
            }

            table.insert(
              items,
              Item.new({
                buf = vim.fn.bufadd(_item.filename),
                pos = { _item.lnum, 0 },
                end_pos = { _item.lnum, _item.col },
                text = _item.text,
                filename = _item.filename,
                item = _item,
                source = 'mark',
              })
            )
          end
        end
      end

      if next(items) then
        Cache.mark['global'] = items
      end
    end
  end

  return items
end

function M.get(cb, ctx)
  local items = {}

  Tools.array_insert(items, M.fetch_list(false))
  Tools.array_insert(items, M.fetch_list(true))

  Item.add_id(items)

  cb(items)
end

return M

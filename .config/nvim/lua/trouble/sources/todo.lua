-- stylua: ignore start
local Autocmd = require('ngpong.common.autocmd')
local Config  = require('todo-comments.config')
local Search  = require('todo-comments.search')
local Lazy    = require('ngpong.utils.lazy')
local Item    = Lazy.require('trouble.item')
local Cache   = Lazy.require("trouble.cache")
-- stylua: ignore end

local M = {}

M.config = {
  formatters = {
    todo_icon = function(ctx)
      return {
        text = Config.options.keywords[ctx.item.tag].icon,
        hl = 'TodoFg' .. ctx.item.tag,
      }
    end,
  },
  modes = {
    todo = {
      events = { 'BufEnter', 'BufWritePost' },
      source = 'todo',
      groups = {
        { 'filename', format = '{file_icon}{filename} {count}' },
      },
      sort = { { buf = 0 }, 'filename', 'pos', 'message' },
      format = '{todo_icon}{text} {pos}',
    },
  },
}

M.setup = function()
  Autocmd.new_augroup('trouble_todo').on({ 'BufWritePost' }, function(_)
    Cache.todo:clear()
  end)
end

M.get = function(cb, ctx)
  local params = ctx.opts.params or {}

  local target = (params.target == 'workspace' and params.target or Helper.get_cur_bufnr())

  local cache_items = Cache.todo[target]
  if cache_items then
    return cb(cache_items)
  end

  local cwd
  if target == 'workspace' then
    cwd = Tools.get_cwd()
  else
    cwd = Helper.get_buf_name(target)
  end

  Search.search(function(results)
    local items = {}

    for _, item in pairs(results) do
      local row = item.lnum
      local col = item.col - 1
      items[#items + 1] = Item.new({
        buf = vim.fn.bufadd(item.filename),
        pos = { row, col },
        end_pos = { row, vim.v.maxcol },
        text = item.text,
        filename = item.filename,
        item = item,
        source = 'todo',
      })

       -- ::continue::
    end

    if next(items) then
      Item.add_id(items)
      Cache.todo[target] = items
    end

    cb(items)
  end, { cwd = cwd })
end

return M

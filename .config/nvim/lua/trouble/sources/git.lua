-- stylua: ignore start
local Autocmd        = require('ngpong.common.autocmd')
local Icons          = require('ngpong.utils.icon')
local Lazy           = require('ngpong.utils.lazy')
local libP           = require('ngpong.common.libp')
local Item           = Lazy.require('trouble.item')
local Cache          = Lazy.require("trouble.cache")
local GitsignsAsync  = Lazy.require('gitsigns.async')
local GitsignsAttach = Lazy.require('gitsigns.attach')
local GitsignsCache  = Lazy.require('gitsigns.cache')
local GitsignsGit    = Lazy.require('gitsigns.git')
local GitsignsDiff   = Lazy.require('gitsigns.diff')
-- stylua: ignore end

local gitsigns_sleep = GitsignsAsync.wrap(2, function(duration, acb)
  vim.defer_fn(acb, duration)
end)

local M = {}

M.config = {
  formatters = {
    git_text = function(ctx)
      local text, hl = '', ''

      if ctx.item.text_type then
        text = ctx.item.text
        hl = 'Diff' .. ctx.item.text_type
      elseif ctx.item.head_type then
        text = Icons['git_' .. ctx.item.head_type] .. Icons.space .. ctx.item.text
        hl = 'GitSigns' .. string.upper(string.sub(ctx.item.head_type, 1, 1)) .. string.sub(ctx.item.head_type, 2)
      end

      return {
        text = text,
        hl = hl,
      }
    end,
    git_head = function(ctx)
      local type = ctx.item.type

      local hl = 'GitSigns' .. string.upper(string.sub(type, 1, 1)) .. string.sub(type, 2)
      local icon = Icons['git_' .. type] .. Icons.space .. ctx.item.head

      return {
        text = icon,
        hl = hl,
      }
    end,
  },
  modes = {
    git = {
      events = { 'BufEnter', 'BufWritePost' }, -- { event = 'User', pattern = { 'GitSignsChanged', 'GitSignsUpdate' } }
      source = 'git',
      format = '{git_text}',
      win = { size = 0.4 },
      sort = { { buf = 0 }, 'idx' },
      icons = {
        indent = {
          last = '  ',
          middle = '  ',
          top = '',
        },
      },
    },
  },
}

local function set_item(filename, hunk, items, idx)
  local _set_item = function(sources, text_type)
    idx = idx + 1

    local texts = {}

    local prefix = (text_type == 'Add' and '+' or '-')

    for _, value in ipairs(sources) do
      table.insert(texts, prefix .. value)
    end

    local _item = {
      filename = filename,
      lnum = hunk.added.start,
      col = vim.v.maxcol,
      text = table.concat(texts, '\n'),
      text_type = text_type,
      vend = hunk.vend,
      idx = idx,
    }

    table.insert(items, Item.new({
      buf = vim.fn.bufadd(_item.filename),
      pos = { _item.lnum, 0 },
      end_pos = { _item.vend, _item.col },
      text = _item.text,
      filename = _item.filename,
      item = _item,
      source = 'git',
    }))
  end

  local _item = {
    filename = filename,
    lnum = hunk.added.start,
    col = vim.v.maxcol,
    text = hunk.head,
    head_type = hunk.type,
    vend = hunk.vend,
    idx = idx,
  }

  table.insert(items, Item.new({
    buf = vim.fn.bufadd(_item.filename),
    pos = { _item.lnum, 0 },
    end_pos = { _item.vend, _item.col },
    text = _item.text,
    filename = _item.filename,
    item = _item,
    source = 'git',
  }))

  if hunk.removed and hunk.removed.count > 0 then
    _set_item(hunk.removed.lines, 'Delete')
  end

  if hunk.added and hunk.added.count > 0 then
    _set_item(hunk.added.lines, 'Add')
  end

  return idx + 1
end

M.setup = function()
  Autocmd.new_augroup('trouble_git').on({ 'BufWritePost' }, function(state)
    Cache.git:clear()
  end)
end

M.get = GitsignsAsync.create(2, function(cb, ctx)
  local params = ctx.opts.params or {}

  local items = {}

  local target = params.target or Helper.get_cur_bufnr()

  local cache_items = Cache.git[target]
  if cache_items then
    return cb(cache_items)
  end

  local idx = 0

  if type(target) == 'number' then
    local bufnr = target
    local bufname = Helper.get_buf_name(bufnr)

    local cache_hunks = GitsignsCache.cache[bufnr]

    if not cache_hunks then
      GitsignsAttach.attach(bufnr)

      -- wait for attach complete
      while not cache_hunks or not cache_hunks.hunks do
        gitsigns_sleep(50)
        cache_hunks = GitsignsCache.cache[bufnr]
      end
    end

    for _, hunk in ipairs(cache_hunks.hunks or {}) do
      idx = set_item(bufname, hunk, items, idx)
    end
  elseif target == 'all' then
    local cache_hunks = GitsignsCache.cache

    local repos = {}

    for _, bcache in pairs(cache_hunks) do
      local repo = bcache.git_obj.repo
      if not repos[repo.gitdir] then
        repos[repo.gitdir] = repo
      end
    end

    local repo = GitsignsGit.Repo.get(assert(vim.loop.cwd()))
    if repo and not repos[repo.gitdir] then
      repos[repo.gitdir] = repo
    end

    for _, r in pairs(repos) do
      for _, f in ipairs(r:files_changed()) do
        local f_abs = r.toplevel .. '/' .. f
        local stat = vim.loop.fs_stat(f_abs)
        if stat and stat.type == 'file' then
          local a = r:get_show_text(':0:' .. f)

          GitsignsAsync.scheduler()

          local hunks = GitsignsDiff(a, libP.path:new(f_abs):readlines())

          GitsignsAsync.scheduler()

          for _, hunk in ipairs(hunks) do
            idx = set_item(f_abs, hunk, items, idx)
          end
        end
      end
    end
  end

  if next(items) then
    Item.add_id(items)
    Cache.git[target] = items
  end

  cb(items)
end)

return M

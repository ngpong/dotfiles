-- stylua: ignore start
local libP           = require('ngpong.common.libp')
local Icons          = require('ngpong.utils.icon')
local Lazy           = require('ngpong.utils.lazy')
local Item           = Lazy.require('trouble.item')
local Gitsigns_async = Lazy.require('gitsigns.async')
local Gitsigns_cache = Lazy.require('gitsigns.cache')
local Gitsigns_git   = Lazy.require('gitsigns.git')
local Gitsigns_diff  = Lazy.require('gitsigns.diff')

local colors   = Plgs.colorscheme.colors
-- stylua: ignore end

local M = {}

M.config = {
  modes = {
    git = {
      events = { 'BufEnter', 'BufWritePost', { event = 'User', pattern = { 'GitSignsChanged', 'GitSignsUpdate' } } },
      source = 'git',
      groups = {
        { 'filename', format = '{file_icon}{filename} {count}' },
      },
      sort = { { buf = 0 }, 'filename', 'pos' },
      format = '{text:ts} {pos}',
    },
  },
}

M.get = Gitsigns_async.create(2, function(cb, ctx)
  local params = ctx.opts.params or {}

  local target = params.target or Helper.get_cur_bufnr()

  local items = {}

  if type(target) == 'number' then
    local cache = Gitsigns_cache.cache[target] or {}

    for _, hunk in ipairs(cache.hunks) do
      local _item = {
        filename = Helper.get_buf_name(target),
        lnum = hunk.added.start,
        col = vim.v.maxcol,
        text = string.format('%d ~ %d', hunk.added.start, hunk.vend),
        type = hunk.type,
        vend = hunk.vend
      }

      items[#items+1] = Item.new({
        buf = vim.fn.bufadd(_item.filename),
        pos = { _item.lnum , 0 },
        end_pos = { _item.vend, _item.col },
        text = _item.text,
        filename = _item.filename,
        item = _item,
        source = 'git',
      })
    end
  elseif target == 'all' then
    local cache = Gitsigns_cache.cache

    local repos = {}

    for _, bcache in pairs(cache) do
      local repo = bcache.git_obj.repo
      if not repos[repo.gitdir] then
        repos[repo.gitdir] = repo
      end
    end

    local repo = Gitsigns_git.Repo.new(assert(vim.loop.cwd()))
    if not repos[repo.gitdir] then
      repos[repo.gitdir] = repo
    end

    for _, r in pairs(repos) do
      for _, f in ipairs(r:files_changed()) do
        local f_abs = r.toplevel .. '/' .. f
        local stat = vim.loop.fs_stat(f_abs)
        if stat and stat.type == 'file' then
          local a = r:get_show_text(':0:' .. f)

          Gitsigns_async.scheduler()

          local hunks = Gitsigns_diff(a, libP.path:new(f_abs):readlines())

          Gitsigns_async.scheduler()

          for _, hunk in ipairs(hunks) do
            local _item = {
              filename = f_abs,
              lnum = hunk.added.start,
              col = 1000,
              text = string.format('%d ~ %d', hunk.added.start, hunk.vend),
              type = hunk.type,
              vend = hunk.vend
            }

            items[#items+1] = Item.new({
              buf = vim.fn.bufadd(_item.filename),
              pos = { _item.lnum , 0 },
              end_pos = { _item.vend, _item.col },
              text = _item.text,
              filename = _item.filename,
              item = _item,
              source = 'git',
            })
          end
        end
      end
    end
  end

  cb(items)
end)

return M

-- stylua: ignore start
local Icons          = require('ngpong.utils.icon')
local Lazy           = require('ngpong.utils.lazy')
local libP           = require('ngpong.common.libp')
local Item           = Lazy.require('trouble.item')
local GitsignsAsync  = Lazy.require('gitsigns.async')
local GitsignsAttach = Lazy.require('gitsigns.attach')
local GitsignsCache  = Lazy.require('gitsigns.cache')
local GitsignsGit    = Lazy.require('gitsigns.git')
local GitsignsDiff   = Lazy.require('gitsigns.diff')

local colors   = Plgs.colorscheme.colors
-- stylua: ignore end

local gitsigns_sleep = GitsignsAsync.wrap(2, function(duration, acb)
  vim.defer_fn(acb, duration)
end)

local M = {}

M.config = {
  formatters = {
    git_info = function(ctx)
      local type = ctx.item.type

      local hl = 'GitSigns' .. string.upper(string.sub(type, 1, 1)) .. string.sub(type, 2)
      local icon = Icons['git_' .. type]

      return {
        text = icon .. ' ' .. ctx.item.text,
        hl = hl,
      }
    end,
    git_pos = function(ctx)
      return ctx.item.text
    end,
  },
  modes = {
    git = {
      events = { 'BufEnter', 'BufWritePost' }, -- , { event = 'User', pattern = { 'GitSignsChanged', 'GitSignsUpdate' } }
      source = 'git',
      groups = {
        { 'directory', format = '{directory_icon}{directory} {count}' },
      },
      sort = { { buf = 0 }, 'pos' },
      format = '{file_icon}{basename} {git_info}',
    },
  },
}

M.get = GitsignsAsync.create(2, function(cb, ctx)
  local params = ctx.opts.params or {}

  local target = params.target or Helper.get_cur_bufnr()

  local items = {}

  if type(target) == 'number' then
    local cache = GitsignsCache.cache[target]

    if not cache then
      GitsignsAttach.attach(target)

      -- wait for attach complete
      while not cache or not cache.hunks do
        gitsigns_sleep(50)
        cache = GitsignsCache.cache[target]
      end
    end

    for _, hunk in ipairs(cache.hunks or {}) do
      local _item = {
        filename = Helper.get_buf_name(target),
        lnum = hunk.added.start,
        col = vim.v.maxcol,
        text = string.format('%d,%d', hunk.added.start, hunk.vend),
        type = hunk.type,
        vend = hunk.vend,
      }

      items[#items + 1] = Item.new({
        buf = vim.fn.bufadd(_item.filename),
        pos = { _item.lnum, 0 },
        end_pos = { _item.vend, _item.col },
        text = _item.text,
        filename = _item.filename,
        item = _item,
        source = 'git',
      })
    end
  elseif target == 'all' then
    local cache = GitsignsCache.cache

    local repos = {}

    for _, bcache in pairs(cache) do
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
            local _item = {
              filename = f_abs,
              lnum = hunk.added.start,
              col = vim.v.maxcol,
              text = string.format('%d,%d', hunk.added.start, hunk.vend),
              type = hunk.type,
              vend = hunk.vend,
            }

            items[#items + 1] = Item.new({
              buf = vim.fn.bufadd(_item.filename),
              pos = { _item.lnum, 0 },
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

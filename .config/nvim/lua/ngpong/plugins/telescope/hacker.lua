local M = {}

local Icons        = require('ngpong.utils.icon')
local Lazy         = require('ngpong.utils.lazy')
local libP         = require('ngpong.common.libp')
local Utils        = Lazy.require('telescope.utils')
local MakeEntry    = Lazy.require('telescope.make_entry')
local EntryDisplay = Lazy.require('telescope.pickers.entry_display')

local bufferline = Plgs.bufferline

local hack_buffers_entrymaker = function()
  MakeEntry.gen_from_buffer = function(opts)
    opts = opts or {}

    local disable_devicons = opts.disable_devicons

    local icon_width = 0
    if not disable_devicons then
      local icon, _ = Utils.get_devicons('fname', disable_devicons)
      icon_width = libP.strings.strdisplaywidth(icon)
    end

    local displayer
    if opts.is_have_pinned then
      displayer = EntryDisplay.create({
        separator = ' ',
        items = {
          { width = opts.bufnr_width },
          { width = 4 },
          { width = 2 },
          { width = icon_width },
          { remaining = true },
        },
      })
    else
      displayer = EntryDisplay.create({
        separator = ' ',
        items = {
          { width = opts.bufnr_width },
          { width = 4 },
          { width = icon_width },
          { remaining = true },
        },
      })
    end

    local cwd = vim.fn.expand(opts.cwd or vim.loop.cwd())

    local make_display = function(entry)
      -- bufnr_width + modes + icon + 3 spaces + : + lnum
      opts.__prefix = opts.bufnr_width + 4 + icon_width + 3 + 1 + #tostring(entry.lnum)
      local display_bufname = Utils.transform_path(opts, entry.filename)
      local icon, hl_group = Utils.get_devicons(entry.filename, disable_devicons)

      if opts.is_have_pinned then
        return displayer({
          { entry.bufnr, 'TelescopeResultsNumber' },
          { entry.indicator, 'TelescopeResultsComment' },
          bufferline.api.is_pinned(entry.bufnr) and Icons.pinned_3 or Icons.space,
          { icon, hl_group },
          display_bufname .. ':' .. entry.lnum,
        })
      else
        return displayer({
          { entry.bufnr, 'TelescopeResultsNumber' },
          { entry.indicator, 'TelescopeResultsComment' },
          { icon, hl_group },
          display_bufname .. ':' .. entry.lnum,
        })
      end
    end

    return function(entry)
      local bufname = entry.info.name ~= '' and entry.info.name or '[No Name]'
      -- if bufname is inside the cwd, trim that part of the string
      bufname = libP.path:new(bufname):normalize(cwd)

      local hidden = entry.info.hidden == 1 and 'h' or 'a'
      local readonly = vim.api.nvim_buf_get_option(entry.bufnr, 'readonly') and '=' or ' '
      local changed = entry.info.changed == 1 and '+' or ' '
      local indicator = entry.flag .. hidden .. readonly .. changed
      local lnum = 1

      -- account for potentially stale lnum as getbufinfo might not be updated or from resuming buffers picker
      if entry.info.lnum ~= 0 then
        -- but make sure the buffer is loaded, otherwise line_count is 0
        if vim.api.nvim_buf_is_loaded(entry.bufnr) then
          local line_count = vim.api.nvim_buf_line_count(entry.bufnr)
          lnum = math.max(math.min(entry.info.lnum, line_count), 1)
        else
          lnum = entry.info.lnum
        end
      end

      return {
        value = bufname,
        ordinal = entry.bufnr .. ' : ' .. bufname,
        display = make_display,

        bufnr = entry.bufnr,
        filename = bufname,
        lnum = lnum,
        indicator = indicator,
      }
    end
  end
end

local function hack_gitstatus_entrymaker()
  MakeEntry.gen_from_git_status = function(opts)
    opts = opts or {}

    local col_width = ((opts.git_icons and opts.git_icons.added) and opts.git_icons.added:len()) or 2
    local displayer = EntryDisplay.create({
      separator = '',
      items = {
        { width = col_width },
        { width = col_width },
        { remaining = true },
      },
    })

    local icons = opts.git_icons

    local git_abbrev = {
      ['A'] = { icon = icons.added, hl = 'TelescopeResultsDiffAdd' },
      ['U'] = { icon = icons.unmerged, hl = 'TelescopeResultsDiffAdd' },
      ['M'] = { icon = icons.changed, hl = 'TelescopeResultsDiffChange' },
      ['C'] = { icon = icons.copied, hl = 'TelescopeResultsDiffChange' },
      ['R'] = { icon = icons.renamed, hl = 'TelescopeResultsDiffChange' },
      ['D'] = { icon = icons.deleted, hl = 'TelescopeResultsDiffDelete' },
      ['?'] = { icon = icons.untracked, hl = 'TelescopeResultsDiffUntracked' },
    }

    local make_display = function(entry)
      local x = string.sub(entry.status, 1, 1)
      local y = string.sub(entry.status, -1)
      local status_x = git_abbrev[x] or {}
      local status_y = git_abbrev[y] or {}

      local display_path, path_style = Utils.transform_path(opts, entry.path)

      local empty_space = ' '
      return displayer({
        { status_x.icon or empty_space, status_x.hl },
        { status_y.icon or empty_space, status_y.hl },
        {
          display_path,
          function()
            return path_style
          end,
        },
      })
    end

    return function(entry)
      if entry == '' then
        return nil
      end

      local mod, file = entry:match('^(..) (.+)$')
      -- Ignore entries that are the PATH in XY ORIG_PATH PATH
      -- (renamed or copied files)
      if not mod then
        return nil
      end

      return setmetatable({
        value = file,
        status = mod,
        ordinal = entry,
        display = make_display,
        path = libP.path:new({ opts.cwd, file }):absolute(),
      }, opts)
    end
  end
end

M.setup = function()
  hack_buffers_entrymaker()
  hack_gitstatus_entrymaker()
end

return M

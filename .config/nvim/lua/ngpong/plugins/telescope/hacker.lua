local M = {}

local icons         = require('ngpong.utils.icon')
local lazy          = require('ngpong.utils.lazy')
local utils         = lazy.require('telescope.utils')
local make_entry    = lazy.require('telescope.make_entry')
local entry_display = lazy.require('telescope.pickers.entry_display')
local strings       = lazy.require('plenary.strings')
local Path          = lazy.require('plenary.path')

local bufferline = PLGS.bufferline

local hack_buffers_entrymaker = function()
  local path = Path.__get()

  make_entry.gen_from_buffer = function(opts)
    opts = opts or {}

    local disable_devicons = opts.disable_devicons

    local icon_width = 0
    if not disable_devicons then
      local icon, _ = utils.get_devicons("fname", disable_devicons)
      icon_width = strings.strdisplaywidth(icon)
    end

    local displayer
    if opts.is_have_pinned then
      displayer = entry_display.create {
        separator = " ",
        items = {
          { width = opts.bufnr_width },
          { width = 4 },
          { width = 2 },
          { width = icon_width },
          { remaining = true },
        },
      }
    else
      displayer = entry_display.create {
        separator = " ",
        items = {
          { width = opts.bufnr_width },
          { width = 4 },
          { width = icon_width },
          { remaining = true },
        },
      }
    end

    local cwd = vim.fn.expand(opts.cwd or vim.loop.cwd())

    local make_display = function(entry)
      -- bufnr_width + modes + icon + 3 spaces + : + lnum
      opts.__prefix = opts.bufnr_width + 4 + icon_width + 3 + 1 + #tostring(entry.lnum)
      local display_bufname = utils.transform_path(opts, entry.filename)
      local icon, hl_group = utils.get_devicons(entry.filename, disable_devicons)

      if opts.is_have_pinned then
        return displayer {
          { entry.bufnr, "TelescopeResultsNumber" },
          { entry.indicator, "TelescopeResultsComment" },
          bufferline.api.is_pinned(entry.bufnr) and icons.pinned_3 or icons.space,
          { icon, hl_group },
          display_bufname .. ":" .. entry.lnum,
        }
      else
        return displayer {
          { entry.bufnr, "TelescopeResultsNumber" },
          { entry.indicator, "TelescopeResultsComment" },
          { icon, hl_group },
          display_bufname .. ":" .. entry.lnum,
        }
      end
    end

    return function(entry)
      local bufname = entry.info.name ~= "" and entry.info.name or "[No Name]"
      -- if bufname is inside the cwd, trim that part of the string
      bufname = path:new(bufname):normalize(cwd)

      local hidden = entry.info.hidden == 1 and "h" or "a"
      local readonly = vim.api.nvim_buf_get_option(entry.bufnr, "readonly") and "=" or " "
      local changed = entry.info.changed == 1 and "+" or " "
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
        ordinal = entry.bufnr .. " : " .. bufname,
        display = make_display,

        bufnr = entry.bufnr,
        filename = bufname,
        lnum = lnum,
        indicator = indicator,
      }
    end
  end
end

M.setup = function()
  hack_buffers_entrymaker()
end

return M

local M = {}

-- stylua: ignore start
local Icons        = require('ngpong.utils.icon')
local Git          = require('ngpong.utils.git')
local Lazy         = require('ngpong.utils.lazy')
local libP         = require('ngpong.common.libp')
local Utils        = Lazy.require('telescope.utils')
local MakeEntry    = Lazy.require('telescope.make_entry')
local Internal     = Lazy.require('telescope.builtin.__internal')
local EntryDisplay = Lazy.require('telescope.pickers.entry_display')
local Pickers      = Lazy.require('telescope.pickers')
local finders      = Lazy.require('telescope.finders')
local Config       = Lazy.require("telescope.config")
-- stylua: ignore end

local bufferline = Plgs.bufferline

local pos_hl = 'GruvboxBg3'
local comma_hl = 'GruvboxYellow'

local function buffers_entrymaker()
  local workspace = Tools.get_workspace()

  MakeEntry.gen_from_buffer = function(opts)
    opts = opts or {}

    local disable_devicons = opts.disable_devicons

    local fname_icon, _ = Utils.get_devicons('fname', disable_devicons)
    local fname_icon_width = libP.strings.strdisplaywidth(fname_icon)

    local displayer
    if opts.is_have_pinned then
      displayer = EntryDisplay.create({
        separator = '',
        items = {
          { width = opts.bufnr_width + 1 },
          { width = 1 },
          { width = fname_icon_width + 2 },
          { width = 2 },
          { remaining = true },
          { remaining = true },
          { remaining = true },
          { remaining = true },
        },
      })
    else
      displayer = EntryDisplay.create({
        separator = '',
        items = {
          { width = opts.bufnr_width + 1 },
          { width = 2 },
          { width = 2 },
          { remaining = true },
          { remaining = true },
          { remaining = true },
          { remaining = true },
        },
      })
    end

    local make_display = function(entry)
      local icon, hl_group = Utils.get_devicons(entry.filename, disable_devicons)

      local bufnr, bufnr_hl = entry.bufnr, (entry.is_current and 'GruvboxYellow' or 'GruvboxGray')
      local spector, spector_hl = '│', 'LineNr'
      local filename = entry.filename
      local pos = (entry.has_pos and '[' .. entry.lnum .. ',' .. entry.col .. ']' or '')
      local comma = (entry.has_pos and ': ' or '')
      local text = Helper.strim(Helper.getline(entry.bufnr, entry.lnum)) .. ' '

      if opts.is_have_pinned then
        return displayer({
          { bufnr, bufnr_hl },
          { spector, spector_hl },
          { bufferline.api.is_pinned(entry.bufnr) and Icons.pinned_3 or Icons.space },
          { icon, hl_group },
          { filename },
          { comma, comma_hl },
          { text },
          { pos, pos_hl },
        })
      else
        return displayer({
          { bufnr, bufnr_hl },
          { spector, spector_hl },
          { icon, hl_group },
          { filename },
          { comma, comma_hl },
          { text },
          { pos, pos_hl },
        })
      end
    end

    return function(entry)
      local bufname = libP.path:new(entry.info.name):make_relative(workspace)

      local cursor_cache = Variable.get('cursor_presist_native') or {}

      local has_pos = false

      local lnum, col = 0, 0
      local pos = cursor_cache[bufname]
      if pos then
        lnum = pos.row
        col = pos.col + 1
        has_pos = true
      end

      return {
        value = bufname,
        ordinal = ('%s %s'):format(entry.bufnr, bufname),
        display = make_display,
        bufnr = entry.bufnr,
        filename = bufname,
        lnum = lnum,
        col = col,
        is_current = opts.bufnr == entry.bufnr,
        has_pos = has_pos,
      }
    end
  end
end

local function gitstatus_entrymaker()
  local git_workspace = Git.get_repository_root()
  local file_workspace = Tools.get_workspace()

  MakeEntry.gen_from_git_status = function(opts)
    opts = opts or {}

    local displayer = EntryDisplay.create({
      separator = '',
      items = {
        { width = 2 },
        { width = 2 },
        { width = 2 },
        { width = 2 },
        { remaining = true },
      },
    })

    local git_abbrev = {
      ['A'] = { icon = opts.git_icons.added, hl = 'TelescopeResultsDiffAdd' },
      ['U'] = { icon = opts.git_icons.unmerged, hl = 'TelescopeResultsDiffAdd' },
      ['M'] = { icon = opts.git_icons.changed, hl = 'TelescopeResultsDiffChange' },
      ['C'] = { icon = opts.git_icons.copied, hl = 'TelescopeResultsDiffChange' },
      ['R'] = { icon = opts.git_icons.renamed, hl = 'TelescopeResultsDiffChange' },
      ['D'] = { icon = opts.git_icons.deleted, hl = 'TelescopeResultsDiffDelete' },
      ['?'] = { icon = opts.git_icons.untracked, hl = 'TelescopeResultsDiffUntracked' },
    }

    local make_display = function(entry)
      local x = string.sub(entry.status, 1, 1)
      local y = string.sub(entry.status, -1)
      local status_x = git_abbrev[x] or {}
      local status_y = git_abbrev[y] or {}

      local rel_path = libP.path:new(entry.path):make_relative(file_workspace)

      local icon, hl_group = Utils.get_devicons(rel_path)

      return displayer({
        { status_x.icon or Icons.space, status_x.hl },
        { status_y.icon or Icons.space, status_y.hl },
        { '│', 'LineNr' },
        { icon, hl_group },
        { rel_path },
      })
    end

    return function(entry)
      if not entry or entry == '' then
        return nil
      end

      local mod, file = entry:match('^(..) (.+)$')
      -- Ignore entries that are the PATH in XY ORIG_PATH PATH
      -- (renamed or copied files)
      if not mod then
        return nil
      end

      file = libP.path:new(git_workspace):joinpath(file).filename

      return setmetatable({
        value = file,
        status = mod,
        ordinal = entry,
        display = make_display,
        path = file,
      }, opts)
    end
  end
end

local function marks_entrymaker()
  local workspace = Tools.get_workspace()

  MakeEntry.gen_from_marks = function(opts)
    local displayer = EntryDisplay.create({
      separator = '',
      items = {
        { width = 2 },
        { width = 2 },
        { width = 2 },
        { remaining = true },
        { remaining = true },
        { remaining = true },
        { remaining = true },
      },
    })

    local make_display = function(entry)
      local rel_path = libP.path:new(entry.filename):make_relative(workspace)

      local icon, hl_group = Utils.get_devicons(rel_path)
      local comma = ': '
      local spector, spector_hl = '│', 'LineNr'
      local pos = '[' .. entry.lnum .. ',' .. entry.col .. ']'
      local text = Helper.strim(entry.value) .. ' '

      return displayer({
        { entry.mark, 'MarkSignHL' },
        { spector, spector_hl },
        { icon, hl_group },
        { rel_path },
        { comma, comma_hl },
        { text },
        { pos, pos_hl },
      })
    end

    return function(entry)
      return MakeEntry.set_default_entry_mt({
        value = entry.value,
        ordinal = ('%s %s'):format(entry.mark, entry.relative_file),
        mark = entry.mark,
        display = make_display,
        lnum = entry.lnum,
        col = entry.col,
        filename = entry.filename,
        relative_file = entry.relative_file,
      }, opts)
    end
  end
end

local function document_symbols_entrymaker()
  MakeEntry.gen_from_lsp_symbols = function(opts)
    opts = opts or {}

    local display_items = {
      { width = 2 },
      { width = 9 },
      { width = 2 },
      { width = 26 },
      { width = 2 },
      { remaining = true },
      { remaining = true },
    }

    local displayer = EntryDisplay.create({
      separator = '',
      items = display_items,
    })

    local make_display = function(entry)
      local symbol_icon = opts.symbol_kinds[entry.symbol_type].val
      local symbol_hl = opts.symbol_kinds[entry.symbol_type].hl_link

      local spector, spector_hl = '│', 'LineNr'
      local pos = '[' .. entry.lnum .. ',' .. entry.col .. ']'
      local text = Helper.strim(Helper.getline(opts.bufnr, entry.lnum)) .. ' '

      return displayer({
        { symbol_icon, symbol_hl },
        { entry.symbol_type, symbol_hl },
        { spector, spector_hl },
        { entry.symbol_name },
        { spector, spector_hl },
        { text },
        { pos, pos_hl }
      })
    end

    return function(entry)
      local symbol_msg = entry.text
      local symbol_type, symbol_name = symbol_msg:match('%[(.+)%]%s+(.*)')

      return MakeEntry.set_default_entry_mt({
        value = entry,
        ordinal = ('%s %s'):format(symbol_name, symbol_type or 'unknown'),
        display = make_display,
        filename = entry.filename,
        lnum = entry.lnum,
        col = entry.col,
        symbol_name = symbol_name,
        symbol_type = symbol_type,
        start = entry.start,
        finish = entry.finish,
      }, opts)
    end
  end
end

local function buffer_lines_entrymaker()
  MakeEntry.gen_from_buffer_lines = function(opts)
    local displayer_items = {
      { width = 2 },
      { remaining = true },
    }

    local line_count = vim.api.nvim_buf_line_count(opts.bufnr)

    local inc_width = 1
    while line_count >= 10 do
      line_count = math.floor(line_count / 10)
      inc_width = inc_width + 1
    end

    table.insert(displayer_items, 1, { width = inc_width, right_justify = true })

    local displayer = EntryDisplay.create({
      separator = '',
      items = displayer_items,
    })

    local make_display = function(entry)
      return displayer({
        { tostring(entry.lnum), opts.lnum_highlight_group or 'TelescopeResultsSpecialComment' },
        { '│', 'LineNr' },
        {
          entry.text,
          function()
            if not opts.line_highlights then
              return {}
            end

            local line_hl = opts.line_highlights[entry.lnum] or {}
            local result = {}

            for col, hl in pairs(line_hl) do
              table.insert(result, { { col, col + 1 }, hl })
            end

            return result
          end,
        },
      })
    end

    return function(entry)
      if opts.skip_empty_lines and string.match(entry.text, '^$') then
        return
      end

      return MakeEntry.set_default_entry_mt({
        ordinal = entry.text,
        display = make_display,
        filename = entry.filename,
        lnum = entry.lnum,
        text = entry.text,
      }, opts)
    end
  end
end

local function diagnostics_entrymaker()
  local workspace = Tools.get_workspace()

  MakeEntry.gen_from_diagnostics = function(opts)
    opts = opts or {}

    local type_diagnostic = vim.diagnostic.severity

    local errlist_type_map = {
      [type_diagnostic.ERROR] = 'E',
      [type_diagnostic.WARN] = 'W',
      [type_diagnostic.INFO] = 'I',
      [type_diagnostic.HINT] = 'N',
    }

    local signs = (function()
      if opts.no_sign then
        return
      end
      local signs = {}
      for _, severity in ipairs(type_diagnostic) do
        local status, sign = pcall(function()
          return vim.trim(vim.fn.sign_getdefined('DiagnosticSign' .. severity:lower():gsub('^%l', string.upper))[1].text)
        end)
        if not status then
          sign = severity:sub(1, 1)
        end
        signs[severity] = sign
      end
      return signs
    end)()

    local displayer = EntryDisplay.create({
      separator = '',
      items = {
        { width = 2 },
        { width = 2 },
        { remaining = true },
        { remaining = true },
        { remaining = true },
        { remaining = true },
        { remaining = true },
      },
    })

    local make_display = function(entry)
      local rel_path = libP.path:new(entry.filename):make_relative(workspace)

      local icon, hl_group = Utils.get_devicons(entry.filename)

      return displayer({
        { signs[entry.type], 'DiagnosticSign' .. entry.type },
        { '│', 'LineNr' },
        { icon .. Icons.space, hl_group },
        rel_path,
        { ': ', comma_hl },
        { entry.text, 'DiagnosticSign' .. entry.type },
        { ' [' .. entry.lnum .. ',' .. entry.col .. ']', pos_hl },
      })
    end

    return function(entry)
      return MakeEntry.set_default_entry_mt({
        value = entry,
        ordinal = ('%s %s'):format(entry.filename, entry.text),
        display = make_display,
        filename = entry.filename,
        type = entry.type,
        lnum = entry.lnum,
        col = entry.col,
        text = entry.text,
        qf_type = errlist_type_map[type_diagnostic[entry.type]],
      }, opts)
    end
  end
end

local function vimgrep_entrymaker()
  local workspace = Tools.get_workspace()

  local org = MakeEntry.gen_from_vimgrep
  MakeEntry.gen_from_vimgrep = function(opts)
    return function(line)
      local ret = org(opts)(line)

      ret.display = function(entry)
        local rel_path = libP.path:new(entry.filename):make_relative(workspace)
        local coordinates = string.format('[%s,%s]', entry.lnum, entry.col)
        local text = Helper.strim(entry.text)

        local display, hl_group, icon = Utils.transform_devicons(
          entry.filename,
          string.format("%s%s%s%s", rel_path, ': ', Helper.strim(entry.text) .. ' ', coordinates)
        )

        local style = {}
        style = Utils.merge_styles(style, { { { 0, #icon }, hl_group } }, 0)
        style = Utils.merge_styles(style, { { { 0, 2 }, comma_hl } }, #icon + 1 + #rel_path)
        style = Utils.merge_styles(style, { { { 0, #coordinates + 1 }, pos_hl } }, #icon + 3 + #rel_path + #text)
        return display, style
      end

      return ret
    end
  end
end

M.setup = function()
  buffers_entrymaker()
  gitstatus_entrymaker()
  marks_entrymaker()
  document_symbols_entrymaker()
  buffer_lines_entrymaker()
  diagnostics_entrymaker()
  vimgrep_entrymaker()
end

return M

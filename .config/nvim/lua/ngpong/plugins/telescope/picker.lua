local M = {}

-- stylua: ignore start
local Icons     = require('ngpong.utils.icon')
local Lazy      = require('ngpong.utils.lazy')
local libP      = require('ngpong.common.libp')
local Utils     = Lazy.require('telescope.utils')
local Pickers   = Lazy.require('telescope.pickers')
local finders   = Lazy.require('telescope.finders')
local Config    = Lazy.require('telescope.config')
local MakeEntry = Lazy.require('telescope.make_entry')
local Builtin   = Lazy.require('telescope.builtin')
-- stylua: ignore end

M.marks = function()
  local opts = {
    bufnr = Helper.get_cur_bufnr(),
    winnr = Helper.get_cur_winid(),
  }

  local bufname = Helper.get_buf_name(opts.bufnr)
  local workspace = Tools.get_workspace()

  local res = {}
  for _, _data in ipairs(vim.fn.extend(vim.fn.getmarklist(opts.bufnr), vim.fn.getmarklist())) do
    local mark = _data.mark:sub(2, 3)

    if Plgs.marks.api.is_char_mark(mark) then
      local row = _data.pos[2]
      local col = _data.pos[3]

      local file_path = libP.path:new(_data.file or bufname):expand()

      if file_path:match(workspace) then
        local item = {
          value = Helper.getline(file_path, row),
          mark = mark,
          lnum = row,
          col = col,
          filename = file_path,
        }

        table.insert(res, item)
      end
    end
  end

  if #res > 0 then
    Pickers.new(opts, {
      prompt_title = 'Marks',
      finder = finders.new_table({
        results = res,
        entry_maker = MakeEntry.gen_from_marks(opts),
      }),
      previewer = Config.values.grep_previewer(opts),
      sorter = Config.values.generic_sorter(opts),
      push_cursor_on_edit = true,
      push_tagstack_on_edit = true,
    }):find()
  else
    Helper.notify_warn('Not found any marks.')
  end
end

M.todo = function(opts)
  local config = require('todo-comments.config')
  local highlight = require('todo-comments.highlight')

  local function keywords_filter(opts_keywords)
    assert(not opts_keywords or type(opts_keywords) == 'string', '\'keywords\' must be a comma separated string or nil')
    local all_keywords = vim.tbl_keys(config.keywords)
    if not opts_keywords then
      return all_keywords
    end
    local filters = vim.split(opts_keywords, ',')
    return vim.tbl_filter(function(kw)
      return vim.tbl_contains(filters, kw)
    end, all_keywords)
  end

  opts = opts or {}
  opts.vimgrep_arguments = { config.options.search.command }
  vim.list_extend(opts.vimgrep_arguments, config.options.search.args)

  opts.search = config.search_regex(keywords_filter(opts.keywords))
  opts.prompt_title = 'Find Todo'
  opts.use_regex = true
  local entry_maker = MakeEntry.gen_from_vimgrep(opts)
  opts.entry_maker = function(line)
    local ret = entry_maker(line)
    ret.display = function(entry)
      local rel_path = entry.filename
      local text = entry.text
      local start, finish, kw = highlight.match(text)

      local hl = {}
      local display = ''

      if start then
        kw = config.keywords[kw] or kw

        local pos = '[' .. entry.lnum .. ',' .. entry.col .. ']'
        local icon = config.options.keywords[kw].icon or ''
        local speactor = '│ '
        local file_icon, icon_hl = Utils.get_devicons(entry.filename)

        display = icon .. speactor .. file_icon .. ' ' .. rel_path .. pos .. ': ' .. vim.trim(text:sub(start))

        hl = Utils.merge_styles(hl, { { { 0, #icon }, 'TodoFg' .. kw } }, 0)
        hl = Utils.merge_styles(hl, { { { 0, #speactor }, 'LineNr' } }, #icon)
        hl = Utils.merge_styles(hl, { { { 0, #file_icon }, icon_hl } }, #icon + #speactor)
        hl = Utils.merge_styles(hl, { { { 0, #pos }, 'GruvboxBg3' } }, #icon + #speactor + #file_icon + #rel_path + 1)
      end

      return display, hl
    end
    return ret
  end

  Builtin.grep_string(opts)
end

return M

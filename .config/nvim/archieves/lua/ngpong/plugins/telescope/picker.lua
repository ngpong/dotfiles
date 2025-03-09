local M = {}

local Utils     = vim.__lazy.require("telescope.utils")
local Pickers   = vim.__lazy.require("telescope.pickers")
local finders   = vim.__lazy.require("telescope.finders")
local Config    = vim.__lazy.require("telescope.config")
local MakeEntry = vim.__lazy.require("telescope.make_entry")
local Builtin   = vim.__lazy.require("telescope.builtin")

local m_api = vim._plugins.marks.api

vim.api.nvim_set_hl(0, "TelescopePickerComma", { fg = vim.__color.bright_yellow })
vim.api.nvim_set_hl(0, "TelescopePickerPos", { fg = vim.__color.gray })

M.marks = function()
  local opts = {
    bufnr = vim.__buf.current(),
    winnr = vim.__win.current(),
  }

  local bufname = vim.__buf.name(opts.bufnr)
  local workspace = vim.__path.cwd()

  local res = {}
  for _, _data in ipairs(vim.fn.extend(vim.fn.getmarklist(opts.bufnr), vim.fn.getmarklist())) do
    local mark = _data.mark:sub(2, 3)

    if m_api.is_char_mark(mark) then
      local row = _data.pos[2]
      local col = _data.pos[3]

      local filename = vim.__path.expanduser(_data.file or bufname)

      local text = vim.__fs.getline(filename, row)

      if filename:match(workspace) and text then
        local item = {
          value = text,
          mark = mark,
          lnum = row,
          col = col,
          filename = filename,
        }

        res[#res+1] = item
      else
        m_api.del(mark)
      end
    end
  end

  if #res > 0 then
    Pickers.new(opts, {
      prompt_title = "Marks",
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
    vim.__notifier.warn("Not found any marks.")
  end
end

M.todo = function(opts)
  local config = require("todo-comments.config")
  local highlight = require("todo-comments.highlight")

  local function keywords_filter(opts_keywords)
    assert(not opts_keywords or type(opts_keywords) == "string", "\"keywords\" must be a comma separated string or nil")
    local all_keywords = vim.__tbl.keys(config.keywords)
    if not opts_keywords then
      return all_keywords
    end
    local filters = vim.split(opts_keywords, ",")
    return vim.tbl_filter(function(kw)
      return vim.__tbl.contains(filters, kw)
    end, all_keywords)
  end

  opts = opts or {}
  opts.vimgrep_arguments = { config.options.search.command }
  vim.list_extend(opts.vimgrep_arguments, config.options.search.args)

  opts.search = config.search_regex(keywords_filter(opts.keywords))
  opts.prompt_title = "Find Todo"
  opts.use_regex = true
  local entry_maker = MakeEntry.gen_from_vimgrep(opts)
  opts.entry_maker = function(line)
    local ret = entry_maker(line)
    ret.display = function(entry)
      local rel_path = entry.filename
      local start, _, kw = highlight.match(entry.text)

      local hl = {}
      local display = ""

      if start then
        kw = config.keywords[kw] or kw

        local pos = "[" .. entry.lnum .. "," .. entry.col .. "]"
        local icon = config.options.keywords[kw].icon or ""
        local speactor = "│ "
        local file_icon, icon_hl = Utils.get_devicons(entry.filename)
        local text = vim.trim(entry.text:sub(start))

        display = icon .. speactor .. file_icon .. " " .. rel_path .. ": " .. text .. " " .. pos

        hl = Utils.merge_styles(hl, { { { 0, #icon }, "TodoFg" .. kw } }, 0)
        hl = Utils.merge_styles(hl, { { { 0, #speactor }, "LineNr" } }, #icon)
        hl = Utils.merge_styles(hl, { { { 0, #file_icon }, icon_hl } }, #icon + #speactor)
        hl = Utils.merge_styles(hl, { { { 0, 1 }, "TelescopePickerComma" } }, #icon + #speactor + #file_icon + #rel_path + 1)
        hl = Utils.merge_styles(hl, { { { 0, #pos }, "TelescopePickerPos" } }, #icon + #speactor + #file_icon + #rel_path + #text + 4)
      end

      return display, hl
    end
    return ret
  end

  Builtin.grep_string(opts)
end

return M

local M = {}

-- stylua: ignore start
local Lazy          = require('ngpong.utils.lazy')
local State         = Lazy.require('telescope.state')
local Builtin       = Lazy.require('telescope.builtin')
local Actions       = Lazy.require('telescope.actions')
local ActionsSet    = Lazy.require('telescope.actions.set')
local ActionsState  = Lazy.require('telescope.actions.state')
local ActionsLayout = Lazy.require('telescope.actions.layout')
local Resolver      = Lazy.require('telescope.config.resolve')
local Multiselect   = Lazy.require('telescope.pickers.multi')

local trouble = Plgs.trouble
-- stylua: ignore end

M.actions = setmetatable({}, {
  __index = function(t, k)
    return Lazy.access('telescope.actions', k)
  end,
})

M.get_current_picker = function(bufnr)
  return ActionsState.get_current_picker(bufnr)
end

M.append_to_history = function(bufnr)
  local picker = ActionsState.get_current_picker(bufnr)
  if picker == nil then
    return
  end

  local line = ActionsState.get_current_line()
  if Tools.isempty(line) then
    return
  end

  ActionsState.get_current_history():append(line, picker)
end

M.close_telescope = function(bufnr)
  M.append_to_history(bufnr)
  Actions.close(bufnr)
end

M.is_previewing = function(bufnr)
  if not M.is_prompt_buf(bufnr) then
    return false
  end

  local picker = M.get_current_picker(bufnr)
  local status = State.get_status(picker.prompt_bufnr)

  local preview_winid = status.layout.preview and status.layout.preview.winid

  return picker.previewer and preview_winid
end

M.toggle_preview = function(bufnr)
  ActionsLayout.toggle_preview(bufnr)
  Plgs.lualine.api.refresh()
end

M.delete_entries = function(bufnr)
  -- copy from telescope.picker.delete_selection

  local picker = M.get_current_picker(bufnr)
  if not picker then
    return
  end

  local original_selection_strategy = picker.selection_strategy
  picker.selection_strategy = 'row'

  local delete_selections = picker._multi:get()
  local used_multi_select = true
  if vim.tbl_isempty(delete_selections) then
    table.insert(delete_selections, picker:get_selection())
    used_multi_select = false
  end

  local selection_index = {}
  for result_index, result_entry in ipairs(picker.finder.results) do
    if vim.tbl_contains(delete_selections, result_entry) then
      table.insert(selection_index, result_index)
    end
  end

  -- Sort in reverse order as removing an entry from the table shifts down the
  -- other elements to close the hole.
  table.sort(selection_index, function(x, y)
    return x > y
  end)
  for _, index in ipairs(selection_index) do
    local delete_bufnr = picker.finder.results[index].bufnr

    if Helper.delete_buffer(delete_bufnr, false, function()
      return not Plgs.bufferline.api.is_pinned(delete_bufnr)
    end) then
      table.remove(picker.finder.results, index)
    end
  end

  if used_multi_select then
    picker._multi = Multiselect:new()
  end

  picker:refresh()
  vim.defer_fn(function()
    picker.selection_strategy = original_selection_strategy
  end, 50)
end

M.select_entries = function(bufnr)
  local picker = ActionsState.get_current_picker(bufnr)
  if not picker then
    return
  end

  if next(picker:get_multi_selection()) ~= nil then
    M.open_multselected_trouble(picker, bufnr)
    M.append_to_history(bufnr)
  else
    Actions.select_default(bufnr)
    vim.schedule(Helper.keep_screen_center)
  end
end

M.open_multselected_trouble = function(picker, bufnr)
  M.___last_open_type = M.___last_open_type or nil

  if not picker then
    if M.___last_open_type == 'Find Files' then
      trouble.api.toggle('telescope_multi_selected_files')
    elseif M.___last_open_type == 'Live Grep (Args)' then
      trouble.api.toggle('telescope_multi_selected_lines')
    elseif M.___last_open_type ~= nil then
      trouble.api.toggle('telescope_multi_selected_files')
    else
      Helper.notify_warn('No results for telescope_multi_selected')
      return
    end
  else
    if picker.prompt_title == 'Find Files' then
      require('trouble.sources.telescope').open(bufnr, { mode = 'telescope_multi_selected_files' })
    elseif picker.prompt_title == 'Live Grep (Args)' then
      require('trouble.sources.telescope').open(bufnr, { mode = 'telescope_multi_selected_lines' })
    else
      require('trouble.sources.telescope').open(bufnr, { mode = 'telescope_multi_selected_files' })
    end

    M.___last_open_type = picker.prompt_title
  end
end

M.get_prompt_init_pos = function()
  return 1, 5
end

M.reset_prompt_pos = function()
  Helper.set_cursor(M.get_prompt_init_pos())
end

M.keep_cursor_outof_range = function(key)
  local _, col = M.get_prompt_init_pos()

  return function(...)
    local _, cur = Helper.get_cursor()

    if cur == col then
      return
    else
      if key ~= nil then
        Helper.feedkeys(key)
      else
        M.reset_prompt_pos()
      end
    end
  end
end

M.scroll_result = function(direction, speed)
  -- REF: telescope.nvim/lua/telescope/actions/set.lua::scroll_results
  return function(bufnr)
    local status = State.get_status(bufnr)

    local input = direction > 0 and [[]] or [[]]

    vim.api.nvim_win_call(status.layout.results.winid, function()
      vim.cmd([[normal! ]] .. math.floor(speed) .. input)
    end)

    ActionsSet.shift_selection(bufnr, math.floor(speed) * direction)
  end
end

M.scroll_preview = function(direction, speed)
  -- REF: telescope.nvim/lua/telescope/actions/set.lua::scroll_previewer
  return function(bufnr)
    local previewer = ActionsState.get_current_picker(bufnr).previewer
    local status = State.get_status(bufnr)

    local preview_winid = status.layout.preview and status.layout.preview.winid
    if type(previewer) ~= 'table' or previewer.scroll_fn == nil or preview_winid == nil then
      return
    end

    previewer:scroll_fn(math.floor(speed * direction))
  end
end

M.resolve_width = function(val)
  return Resolver.resolve_width(val)
end

M.resolve_height = function(val)
  return Resolver.resolve_height(val)
end

M.is_prompt_buf = function(bufnr)
  if not Helper.is_buf_valid(bufnr) then
    return false
  end

  -- require "telescope.state".get_existing_prompt_bufnrs()
  return vim.api.nvim_buf_get_option(bufnr, 'filetype') == 'TelescopePrompt'
end

M.builtin_picker = function(picker, opts)
  local f = Builtin[picker]
  if f ~= nil and type(f) == 'function' then
    f(opts)
  end
end

return M

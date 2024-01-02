local M = {}

local lazy           = require('ngpong.utils.lazy')
local state          = lazy.require('telescope.state')
local actions        = lazy.require('telescope.actions')
local actions_set    = lazy.require('telescope.actions.set')
local actions_state  = lazy.require('telescope.actions.state')
local actions_layout = lazy.require('telescope.actions.layout')
local resolver       = lazy.require('telescope.config.resolve')

M.actions = setmetatable({}, {
  __index = function(t, k)
    return lazy.access('telescope.actions', k)
  end
})

M.toggle_preview = function(bufnr)
  actions_layout.toggle_preview(bufnr)
end

M.select_entries = function(bufnr)
  local picker = actions_state.get_current_picker(bufnr)
  if not picker then
    return
  end

  if next(picker:get_multi_selection()) ~= nil then
    local wrap = TOOLS.wrap_f

    local handler = wrap(HELPER.clear_loclst, picker.original_win_id) +
                    wrap(actions.send_selected_to_loclist) +
                    wrap(PLGS.trouble.api.open, 'loclist', 'Telescope entries selected')
    if not handler then
      return
    end

    handler(bufnr)
  else
    actions.select_default(bufnr)
  end
end

M.get_prompt_init_pos = function()
  return 1, 5
end

M.reset_prompt_pos = function()
  HELPER.set_cursor(M.get_prompt_init_pos())
end

M.keep_cursor_outof_range = function(key)
  local _, col = M.get_prompt_init_pos()

  return function(...)
    local _, cur = HELPER.get_cursor()

    if cur == col then
      return
    else
      if key ~= nil then
        HELPER.feedkeys(key)
      else
        M.reset_prompt_pos()
      end
    end
  end
end

M.scroll_result = function(direction, speed)
  -- REF: telescope.nvim/lua/telescope/actions/set.lua::scroll_results
  return function(bufnr)
    local status = state.get_status(bufnr)

    local input = direction > 0 and [[]] or [[]]

    vim.api.nvim_win_call(status.layout.results.winid, function()
      vim.cmd([[normal! ]] .. math.floor(speed) .. input)
    end)

    actions_set.shift_selection(bufnr, math.floor(speed) * direction)
  end
end

M.scroll_preview = function(direction, speed)
  -- REF: telescope.nvim/lua/telescope/actions/set.lua::scroll_previewer
  return function(bufnr)
    local previewer = actions_state.get_current_picker(bufnr).previewer
    local status = state.get_status(bufnr)

    local preview_winid = status.layout.preview and status.layout.preview.winid
    if type(previewer) ~= "table" or previewer.scroll_fn == nil or preview_winid == nil then
      return
    end

    previewer:scroll_fn(math.floor(speed * direction))
  end
end

M.resolve_width = function(val)
  return resolver.resolve_width(val)
end

M.resolve_height = function(val)
  return resolver.resolve_height(val)
end

M.is_prompt_buf = function(bufnr)
  -- require "telescope.state".get_existing_prompt_bufnrs()
  return vim.api.nvim_buf_get_option(bufnr, 'filetype') == 'TelescopePrompt'
end

return M
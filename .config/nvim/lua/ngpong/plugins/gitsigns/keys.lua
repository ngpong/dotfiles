local M = {}

local keymap   = require('ngpong.common.keybinder')
local events   = require('ngpong.common.events')
local lazy     = require('ngpong.utils.lazy')
local gitsigns = lazy.require('gitsigns')

local this = PLGS.gitsigns
local e_mode = keymap.e_mode
local e_events = events.e_name

local set_native_keymaps = function()
  keymap.register(e_mode.NORMAL, 'gg', TOOLS.wrap_f(this.api.toggle_gitsymbols_list, 'cur'), { silent = true, remap = false, desc = 'toggle current buffer gitsigns list.' })
  keymap.register(e_mode.NORMAL, 'gG', TOOLS.wrap_f(this.api.toggle_gitsymbols_list, 'all'), { silent = true, remap = false, desc = 'toggle workspace buffer gitsigns list.' })
end

local del_buffer_keymaps = function(bufnr)
  bufnr = bufnr or true
end

local set_buffer_extra_keymaps = function(bufnr)
  bufnr = bufnr or true

  keymap.register(e_mode.NORMAL, 'gd', this.api.toggle_diffthis, { buffer = bufnr, desc = 'toggle current file changed.' })
end

local set_buffer_keymaps = function(bufnr)
  set_buffer_extra_keymaps(bufnr)

  keymap.register(e_mode.NORMAL, 'g,', gitsigns.prev_hunk, { buffer = bufnr, desc = 'jump to prev hunk.' })
  keymap.register(e_mode.NORMAL, 'g.', gitsigns.next_hunk, { buffer = bufnr, desc = 'jump to next hunk.' })
  keymap.register(e_mode.NORMAL, 'ghs', gitsigns.select_hunk, { buffer = bufnr, desc = 'select current hunk.' })
  keymap.register(e_mode.NORMAL, 'gha', gitsigns.stage_hunk, { buffer = bufnr, desc = 'staged current hunk.' })
  keymap.register(e_mode.NORMAL, 'ghr', gitsigns.reset_hunk, { buffer = bufnr, desc = 'restore current hunk.' })
  keymap.register(e_mode.NORMAL, 'gr', gitsigns.reset_buffer, { buffer = bufnr, desc = 'restore current file.' })
  keymap.register(e_mode.NORMAL, 'gu', gitsigns.reset_buffer_index, { buffer = bufnr, desc = 'unstage current file.' })
  keymap.register(e_mode.NORMAL, 'ga', gitsigns.stage_buffer, { buffer = bufnr, desc = 'stage current file.' })
  keymap.register(e_mode.NORMAL, 'gb', TOOLS.wrap_f(this.api.blame_line), { buffer = bufnr, desc = 'show blame line for current hunk.' })
  keymap.register(e_mode.NORMAL, 'gp', TOOLS.wrap_f(this.api.preview_hunk), { buffer = bufnr, desc = 'preview current hunk changed.' })
end

M.setup = function()
  set_native_keymaps()

  events.rg(e_events.GITSIGNS_OPEN_DIFFTHIS, function(state)
    set_buffer_extra_keymaps(state.bufnr)
  end)

  events.rg(e_events.ATTACH_GITSIGNS, function(state)
    del_buffer_keymaps(state.bufnr)
    set_buffer_keymaps(state.bufnr)
  end)
end

return M

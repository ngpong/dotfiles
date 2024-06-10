local M = {}

local Keymap   = require('ngpong.common.keybinder')
local Events   = require('ngpong.common.events')
local Lazy     = require('ngpong.utils.lazy')
local Gitsigns = Lazy.require('gitsigns')

local this      = Plgs.gitsigns
local telescope = Plgs.telescope

local e_mode = Keymap.e_mode
local e_name = Events.e_name

local set_native_keymaps = function()
  Keymap.register(e_mode.NORMAL, 'gg', Tools.wrap_f(telescope.api.builtin_picker, 'git_status'), { silent = true, remap = false, desc = 'toggle current buffer gitsigns list.' })
end

local del_buffer_keymaps = function(bufnr)
  bufnr = bufnr or true
end

local set_buffer_diffthis_keymaps = function(bufnr)
  bufnr = bufnr or true

  Keymap.register(e_mode.NORMAL, 'gd', this.api.toggle_diffthis, { buffer = bufnr, desc = 'toggle current file changed.' })
end

local set_buffer_popup_keymaps = function(bufnr)
  bufnr = bufnr or true

  local maparg = Keymap.get_keymap(e_mode.NORMAL, 'q')
  if maparg then
    Keymap.register(e_mode.NORMAL, 'q', maparg.callback, { buffer = bufnr, desc = maparg.desc, silent = maparg.silent, remap = not maparg.noremap })
  end
end

local set_buffer_keymaps = function(bufnr)
  set_buffer_diffthis_keymaps(bufnr)

  Keymap.register(e_mode.NORMAL, 'g,', Tools.wrap_f(Gitsigns.prev_hunk, { wrap = false }), { buffer = bufnr, desc = 'jump to prev hunk.' })
  Keymap.register(e_mode.NORMAL, 'g.', Tools.wrap_f(Gitsigns.next_hunk, { wrap = false }), { buffer = bufnr, desc = 'jump to next hunk.' })
  Keymap.register(e_mode.NORMAL, 'ghs', Gitsigns.select_hunk, { buffer = bufnr, desc = 'select current hunk.' })
  Keymap.register(e_mode.NORMAL, 'gha', Gitsigns.stage_hunk, { buffer = bufnr, desc = 'staged current hunk.' })
  Keymap.register(e_mode.NORMAL, 'ghr', Gitsigns.reset_hunk, { buffer = bufnr, desc = 'restore current hunk.' })
  Keymap.register(e_mode.NORMAL, 'gr', Gitsigns.reset_buffer, { buffer = bufnr, desc = 'restore current file.' })
  Keymap.register(e_mode.NORMAL, 'gu', Gitsigns.reset_buffer_index, { buffer = bufnr, desc = 'unstage current file.' })
  Keymap.register(e_mode.NORMAL, 'ga', Gitsigns.stage_buffer, { buffer = bufnr, desc = 'stage current file.' })
  Keymap.register(e_mode.NORMAL, 'gb', Tools.wrap_f(this.api.blame_line), { buffer = bufnr, desc = 'show blame line for current hunk.' })
  Keymap.register(e_mode.NORMAL, 'gp', Tools.wrap_f(this.api.preview_hunk), { buffer = bufnr, desc = 'preview current hunk changed.' })
end

M.setup = function()
  set_native_keymaps()

  Events.rg(e_name.GITSIGNS_OPEN_DIFFTHIS, function(state)
    set_buffer_diffthis_keymaps(state.bufnr)
  end)

  Events.rg(e_name.GITSIGNS_OPEN_POPUP, function(state)
    set_buffer_popup_keymaps(state.bufnr)
  end)

  Events.rg(e_name.ATTACH_GITSIGNS, function(state)
    del_buffer_keymaps(state.bufnr)
    set_buffer_keymaps(state.bufnr)
  end)
end

return M

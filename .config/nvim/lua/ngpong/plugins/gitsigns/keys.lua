local M = {}

local Events = require('ngpong.common.events')
local Git = require('ngpong.utils.git')
local Keymap = require('ngpong.common.keybinder')
local Lazy = require('ngpong.utils.lazy')
local libP = require('ngpong.common.libp')
local Gitsigns = Lazy.require('gitsigns')

local this = Plgs.gitsigns
local telescope = Plgs.telescope
local trouble = Plgs.trouble
local dressing = Plgs.dressing

local e_mode = Keymap.e_mode
local e_name = Events.e_name

local set_native_keymaps = function()
  Keymap.register(e_mode.NORMAL, 'gg', Tools.wrap_f(trouble.api.toggle, 'document_git'), { silent = true, remap = false, desc = 'toggle current buffer gitsigns list.' })
  Keymap.register(e_mode.NORMAL, 'gG', Tools.wrap_f(trouble.api.toggle, 'workspace_git'), { silent = true, remap = false, desc = 'toggle workspace buffer gitsigns list.' })
end

local set_git_buffer_diffthis_keymaps = function(bufnr)
  bufnr = bufnr or true

  Keymap.register(e_mode.NORMAL, 'gd', this.api.toggle_diffthis, { buffer = bufnr, desc = 'toggle current file changed.' })
end

local set_git_buffer_popup_keymaps = function(bufnr)
  bufnr = bufnr or true

  local maparg = Keymap.get_keymap(e_mode.NORMAL, 'q')
  if maparg then
    Keymap.register(e_mode.NORMAL, 'q', maparg.callback, { buffer = bufnr, desc = maparg.desc, silent = maparg.silent, remap = not maparg.noremap })
  end
end

local set_git_buffer_keymaps = function(bufnr)
  bufnr = bufnr or true

  set_git_buffer_diffthis_keymaps(bufnr)

  Keymap.register(e_mode.NORMAL, 'g[', Tools.wrap_f(Gitsigns.prev_hunk, { wrap = false }), { remap = false, buffer = bufnr, nowait = true, desc = 'jump to prev hunk.' })
  Keymap.register(e_mode.NORMAL, 'g]', Tools.wrap_f(Gitsigns.next_hunk, { wrap = false }), { remap = false, buffer = bufnr, nowait = true, desc = 'jump to next hunk.' })
  Keymap.register(e_mode.NORMAL, 'ghs', Gitsigns.select_hunk, { remap = false, buffer = bufnr, nowait = true, desc = 'select current hunk.' })
  -- Keymap.register(e_mode.NORMAL, 'gha', Gitsigns.stage_hunk, { remap = false, buffer = bufnr, nowait = true, desc = 'staged current hunk.' })
  Keymap.register(e_mode.NORMAL, 'ghr', Gitsigns.reset_hunk, { remap = false, buffer = bufnr, nowait = true, desc = 'restore current hunk.' })
  Keymap.register(e_mode.NORMAL, 'gr', function()
    dressing.config.scope_set({ input = { relative = 'editor' } }, function()
      vim.ui.input({ prompt = 'This operation will restore the entire file, yes(y) or no(n,...)?', default = '' }, function(res)
        if res ~= 'y' then
          return
        end

        Gitsigns.reset_buffer()
      end)
    end)
  end, { remap = false, buffer = bufnr, nowait = true, desc = 'restore current file.' })
  -- Keymap.register(e_mode.NORMAL, 'gu', Gitsigns.reset_buffer_index, { remap = false, buffer = bufnr, nowait = true, desc = 'unstage current file.' })
  -- Keymap.register(e_mode.NORMAL, 'ga', Gitsigns.stage_buffer, { remap = false, buffer = bufnr, nowait = true, desc = 'stage current file.' })
  Keymap.register(e_mode.NORMAL, 'gb', Tools.wrap_f(this.api.blame_line), { remap = false, buffer = bufnr, nowait = true, desc = 'show blame line for current hunk.' })
  Keymap.register(e_mode.NORMAL, 'gp', Tools.wrap_f(this.api.preview_hunk), { remap = false, buffer = bufnr, nowait = true, desc = 'preview current hunk changed.' })
end

local set_buffer_keymaps = function(bufnr)
  Keymap.register(e_mode.NORMAL, 'gc', function()
    if Git.get_repository_root('.') then
      telescope.api.builtin_picker('git_commits')
    end
  end, { remap = false, buffer = bufnr, nowait = true, desc = 'show git commits list.' })
end

M.setup = function()
  set_native_keymaps()

  Events.rg(e_name.BUFFER_ENTER_ONCE, function(state)
    set_buffer_keymaps(state.buf)
  end)

  Events.rg(e_name.GITSIGNS_OPEN_DIFFTHIS, function(state)
    set_git_buffer_diffthis_keymaps(state.bufnr)
  end)

  Events.rg(e_name.GITSIGNS_OPEN_POPUP, function(state)
    set_git_buffer_popup_keymaps(state.bufnr)
  end)

  Events.rg(e_name.ATTACH_GITSIGNS, function(state)
    set_git_buffer_keymaps(state.bufnr)
  end)
end

return M

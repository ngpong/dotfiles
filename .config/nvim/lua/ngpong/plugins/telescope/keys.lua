local M = {}

local keymap = require('ngpong.common.keybinder')
local events = require('ngpong.common.events')

local this = PLGS.telescope
local e_mode   = keymap.e_mode
local e_events = events.e_name

local wrap_keymap = function(handler, opts)
  local final_opts = {
    remap = true,
    silent = true,
    nowait = true,
  }
  TOOLS.tbl_r_extend(final_opts, opts or {})

  local final_handler = nil
  if type(handler) == 'string' then
    final_handler = handler
  elseif type(handler) == 'table' or type(handler) == 'function' then
    final_handler = function()
      handler(HELPER.get_cur_bufnr())
    end
  end

  return {
    final_handler,
    type = 'command',
    opts = final_opts,
  }
end

local set_plugin_keymaps = function()
  return {
    n = {
      -----------------------------disable keymap-----------------------------
      ['P'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      [':'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<C-:>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<C-S-P>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['s'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['S'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['/'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['?'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['b'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['bC'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['b>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['b<'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['b.'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['b,'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['bb'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['bp'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['bs'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['bc'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['bo'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['B'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['BC'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['B<'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['B>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['t'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['to'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['tc'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['ts'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['t.'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['t,'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['r'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['ro'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['rc'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['r;'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['rl'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['r\''] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['rp'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['rh'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['rv'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['r='] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['r-'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['rs'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['rsh'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['rsv'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['m'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['m,'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['m.'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['md'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['md<leader>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['md<CR>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['me'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['ms'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['ms<leader>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['mm'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['f'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['ff'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['f<leader>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['fs'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['fb'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<leader>e'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<leader>l'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<leader>q'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<leader>f'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<leader>c'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<leader>p'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<leader>P'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<leader>j'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<leader>J'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<HOME>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<END>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['d'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['d.'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['d,'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['dd'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['dD'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['g'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['gg'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<BS>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e,'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e.'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e;'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['ep'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['eP'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e:'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['eh'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['ef'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['ec'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['ef.'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['ef,'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['ec.'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['ec,'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['et'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['eg'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ----------------------------------------------------------------------

      -----------------------------remap keymap-----------------------------
      ['<ESC>'] = wrap_keymap(this.api.close_telescope(), { desc = 'which_key_ignore' }),

      ['['] = wrap_keymap(this.api.keep_cursor_outof_range(), { desc = 'MONTION: move cursor to end of line.' }),
      ['l'] = wrap_keymap(this.api.keep_cursor_outof_range('h'), { desc = 'MONTION: left.' }),
      ['q'] = wrap_keymap(this.api.keep_cursor_outof_range('b'), { desc = 'MONTION: cursor world backward.' }),

      -- history
      ['p'] = wrap_keymap(this.api.actions.cycle_history_prev, { desc = 'TELESCOPE: cycle previouse history.' }),
      [';'] = wrap_keymap(this.api.actions.cycle_history_next, { desc = 'TELESCOPE: cycle next history.' }),

      -- preview
      ['<C-p>'] = wrap_keymap(this.api.scroll_preview(-1, 5), { desc = 'TELESCOPE: scrolling pageup preview window.' }),
      ['<C-;>'] = wrap_keymap(this.api.scroll_preview(1, 5), { desc = 'TELESCOPE: scrolling pagedown preview window.' }),
      -- ['L'] = wrap_keymap(this.api.actions.preview_scrolling_left, { desc = 'TELESCOPE: scrolling left (horizontal)preview window.' }),
      -- ['"'] = wrap_keymap(this.api.actions.preview_scrolling_right, { desc = 'TELESCOPE: scrolling right (horizontal)preview window.' }),

      -- result
      -- NOTE: Open muilt files at onces is in roadmap. https://github.com/nvim-telescope/telescope.nvim/issues/1048
      ['<CR>'] = wrap_keymap(this.api.select_entries, { desc = 'TELESCOPE: select entries.' }),
      ['<C-s>'] = wrap_keymap(this.api.toggle_preview, { desc = 'TELESCOPE: toggle file preview(seek).' }),
      ['<Tab>'] = wrap_keymap(this.api.actions.toggle_selection, { desc = 'TELESCOPE: Toggle selection.' }),
      [','] = wrap_keymap(this.api.actions.move_selection_previous, { desc = 'TELESCOPE: move to prev selection.' }),
      ['.'] = wrap_keymap(this.api.actions.move_selection_next, { desc = 'TELESCOPE: move to next selection.' }),
      ['<C-,>'] = wrap_keymap(this.api.scroll_result(-1, 3), { desc = 'TELESCOPE: scrolling pageup result entries.' }),
      ['<C-.>'] = wrap_keymap(this.api.scroll_result(1, 3), { desc = 'TELESCOPE: scrolling pagedown result entries.' }),
      -- ['<nop>'] = wrap_keymap(this.api.scroll_result(-1, 3), { desc = 'TELESCOPE: scrolling up result entries.' }),
      -- ['<nop>'] = wrap_keymap(this.api.scroll_result(1, 3), { desc = 'TELESCOPE: scrolling down result entries.' }),
      -- ['<nop>'] = wrap_keymap(this.api.actions.move_to_top, { desc = 'result entries head.' }),
      -- ['<nop>'] = wrap_keymap(this.api.actions.move_to_bottom, { desc = 'result entries tail.' }),
      ----------------------------------------------------------------------
    },
    i = {
      ['<ESC>'] = wrap_keymap(function() HELPER.feedkeys('<ESC>l') end, { desc = 'which_key_ignore' }),
    }
  }
end

local del_native_keymaps = function()
end

local set_native_keymaps = function()
  keymap.register(e_mode.NORMAL, 'f<leader>', '<CMD>Telescope<CR>', { remap = false, silent = true, desc = 'find builtin.' })
  keymap.register(e_mode.NORMAL, 'ff', '<CMD>Telescope find_files<CR>', { remap = false, silent = true, desc = 'find files.' })
  keymap.register(e_mode.NORMAL, 'fb', '<CMD>Telescope current_buffer_fuzzy_find results_ts_highlight=true<CR>', { remap = false, silent = true, desc = 'find string in local(current) buffer.' })
  keymap.register(e_mode.NORMAL, 'fs', '<CMD>lua require("telescope").extensions.live_grep_args.live_grep_args()<CR>', { remap = false, silent = true, desc = 'find string with live grep mode.' })
  keymap.register(e_mode.VISUAL, 'fs', '<CMD>lua require("telescope").extensions.live_grep_args.live_grep_args({ default_text = HELPER.get_visual_selected() })<cr>', { silent = true, desc = 'which_key_ignore' })
  -- keymap.register(e_mode.VISUAL, 'fs', '<CMD>lua require("telescope-live-grep-args.shortcuts").grep_visual_selection()<cr>', { silent = true, desc = 'which_key_ignore' })
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()

  events.rg(e_events.SETUP_TELESCOPE, function(cfg)
    TOOLS.tbl_r_extend(cfg, {
      defaults = {
        -- completely remove all default mappings
        default_mappings = set_plugin_keymaps(),
      },
    })
  end)
end

return M

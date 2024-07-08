local M = {}

local Events = require('ngpong.common.events')
local Keymap = require('ngpong.common.keybinder')

local this = Plgs.telescope

local e_mode = Keymap.e_mode
local e_name = Events.e_name

local wrap_handler = function(handler, wrap_normal)
  local final_handler = nil
  if wrap_normal then
    final_handler = function()
      handler()
    end
  elseif type(handler) == 'string' then
    final_handler = handler
  elseif type(handler) == 'table' or type(handler) == 'function' then
    final_handler = function()
      handler(Helper.get_cur_bufnr())
    end
  end

  return final_handler
end

local wrap_keymap = function(handler, opts, wrap_normal)
  local final_opts = {
    remap = true,
    silent = true,
    nowait = true,
  }
  Tools.tbl_r_extend(final_opts, opts or {})

  return {
    wrap_handler(handler, wrap_normal),
    type = 'command',
    opts = final_opts,
  }
end

local set_plugin_keymaps = function()
  return {
    n = {
      -----------------------------disable keymap-----------------------------
      ['<C-S-l>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<C-S-o>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<C-v>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<C-o>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<C-l>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
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
      ['<leader>h'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
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
      ['e1'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e2'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e3'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e4'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e5'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e1.'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e1,'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e2.'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e2,'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e3.'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e3,'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e4.'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e4,'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e5.'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['e5,'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['et'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['eg'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['n'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['n,'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['n.'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['nn'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<A-p>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<C-s>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<C-S>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<A-[>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<A-]>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ----------------------------------------------------------------------

      -----------------------------remap keymap-----------------------------
      ['-'] = wrap_keymap(this.api.keep_cursor_outof_range(), { desc = 'MONTION: move cursor to end of line.' }),
      ['k'] = wrap_keymap(this.api.keep_cursor_outof_range('h'), { desc = 'MONTION: left.' }),
      ['q'] = wrap_keymap(this.api.keep_cursor_outof_range('b'), { desc = 'MONTION: cursor world backward.' }),

      -- history
      ['<C-[>'] = wrap_keymap(this.api.actions.cycle_history_prev, { desc = 'TELESCOPE: cycle previouse history.' }),
      ['<C-]>'] = wrap_keymap(this.api.actions.cycle_history_next, { desc = 'TELESCOPE: cycle next history.' }),

      -- preview
      ['O'] = wrap_keymap(this.api.scroll_preview(-1, 5), { desc = 'TELESCOPE: scrolling preview window pageup.' }),
      ['L'] = wrap_keymap(this.api.scroll_preview(1, 5), { desc = 'TELESCOPE: scrolling preview window pagedown.' }),
      -- [':'] = wrap_keymap(this.api.actions.preview_scrolling_left, { desc = 'TELESCOPE: scrolling left (horizontal)preview window.' }),
      -- ['K'] = wrap_keymap(this.api.actions.preview_scrolling_right, { desc = 'TELESCOPE: scrolling right (horizontal)preview window.' }),

      -- result
      -- NOTE: Open muilt files at onces is in roadmap. https://github.com/nvim-telescope/telescope.nvim/issues/1048
      ['<CR>'] = wrap_keymap(this.api.select_entries, { desc = 'TELESCOPE: select entries.' }),
      ['<C-p>'] = wrap_keymap(this.api.toggle_preview, { desc = 'TELESCOPE: toggle file preview.' }),
      ['<Tab>'] = wrap_keymap(this.api.actions.toggle_selection, { desc = 'TELESCOPE: Toggle selection.' }),
      ['<S-Tab>'] = wrap_keymap(this.api.actions.toggle_all, { desc = 'TELESCOPE: Toggle all selection.' }),
      ['['] = wrap_keymap(this.api.actions.move_selection_previous, { desc = 'TELESCOPE: move to prev selection.' }),
      [']'] = wrap_keymap(this.api.actions.move_selection_next, { desc = 'TELESCOPE: move to next selection.' }),
      -- ['<C-[>'] = wrap_keymap(this.api.scroll_result(-1, 3), { desc = 'TELESCOPE: scrolling result entries pageup.' }),
      -- ['<C-]>'] = wrap_keymap(this.api.scroll_result(1, 3), { desc = 'TELESCOPE: scrolling result entries pagedown.' }),
      -- ['<nop>'] = wrap_keymap(this.api.scroll_result(-1, 3), { desc = 'TELESCOPE: scrolling up result entries.' }),
      -- ['<nop>'] = wrap_keymap(this.api.scroll_result(1, 3), { desc = 'TELESCOPE: scrolling down result entries.' }),
      -- ['<nop>'] = wrap_keymap(this.api.actions.move_to_top, { desc = 'result entries head.' }),
      -- ['<nop>'] = wrap_keymap(this.api.actions.move_to_bottom, { desc = 'result entries tail.' }),
      ----------------------------------------------------------------------
    },
    i = {
      ['<CR>'] = wrap_keymap(this.api.actions.nop, { desc = 'which_key_ignore' }),
      ['<ESC>'] = wrap_keymap(Tools.wrap_f(Helper.feedkeys, '<ESC>l'), { desc = 'which_key_ignore' }, true),
    },
  }
end

local del_native_keymaps = function() end

local set_native_keymaps = function()
  Keymap.register(e_mode.NORMAL, 'f<leader>', '<CMD>Telescope<CR>', { remap = false, silent = true, desc = 'find builtin.' })
  Keymap.register(e_mode.NORMAL, 'ff', '<CMD>Telescope find_files<CR>', { remap = false, silent = true, desc = 'find files.' })
  Keymap.register(e_mode.NORMAL, 'fb', '<CMD>Telescope current_buffer_fuzzy_find results_ts_highlight=true<CR>', { remap = false, silent = true, desc = 'find string in local(current) buffer.' })
  Keymap.register(e_mode.NORMAL, 'fs', '<CMD>lua require("telescope").extensions.live_grep_args.live_grep_args()<CR>', { remap = false, silent = true, desc = 'find string with live grep mode.' })
  Keymap.register(e_mode.VISUAL, 'fs', '<CMD>lua require("telescope").extensions.live_grep_args.live_grep_args({ default_text = Helper.get_visual_selected() })<cr>', { silent = true, desc = 'which_key_ignore' })
  Keymap.register(e_mode.NORMAL, 'f<CR>', this.api.open_multselected_trouble, { silent = true, desc = 'open last multi-selected trouble list.' })
end

local set_buffer_keymaps = function(state)
  Keymap.register(e_mode.NORMAL, '<ESC>', Tools.wrap_f(this.api.close_telescope, state.bufnr), { remap = false, buffer = state.bufnr, desc = 'which_key_ignore' })

  if state.picker.prompt_title == 'Buffers' then
    Keymap.register(e_mode.NORMAL, '<C-CR>', Tools.wrap_f(this.api.delete_entries, state.bufnr), { remap = false, buffer = state.bufnr, desc = 'TELESCOPE: delete entries.' })
    Keymap.unregister(e_mode.NORMAL, '<M-d>', { buffer = state.bufnr })
  end

  if state.picker.prompt_title == 'Git Commits' then
    Keymap.unregister(e_mode.NORMAL, '<Tab>', { buffer = state.bufnr })
    Keymap.unregister(e_mode.NORMAL, '<CR>', { buffer = state.bufnr })
  end
end

local set_config_keymaps = function(cfg)
  Tools.tbl_r_extend(cfg, {
    defaults = {
      -- completely remove all default mappings
      default_mappings = set_plugin_keymaps(),
    },
    -- 下面的配置无法显示 desc，参考这篇：https://github.com/nvim-telescope/telescope.nvim/issues/2981
    -- pickers = {
    --   buffers = {
    --     attach_mappings = function(_, map)
    --       -- map('n', '<C-CR>', function() this.api.delete_entries(Helper.get_cur_bufnr()) end, { desc = 'TELESCOPE: delete entries.' })
    --
    --       return true
    --     end,
    --   },
    -- },
  })
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()

  Events.rg(e_name.SETUP_TELESCOPE, function(cfg)
    set_config_keymaps(cfg)
  end)

  Events.rg(e_name.TELESCOPE_LOAD, function(state)
    set_buffer_keymaps(state)
  end)
end

return M

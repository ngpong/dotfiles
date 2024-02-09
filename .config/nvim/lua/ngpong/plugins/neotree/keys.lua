local M = {}

local keymap            = require('ngpong.common.keybinder')
local events            = require('ngpong.common.events')
local lazy              = require('ngpong.utils.lazy')
local neotree           = lazy.require('neo-tree')
local source_commands   = lazy.require('neo-tree.sources.common.commands')
local filesys_commands  = lazy.require('neo-tree.sources.filesystem.commands')
local common_preview    = lazy.require('neo-tree.sources.common.preview')
local neotree_events    = lazy.require('neo-tree.events')
local neotree_ui_inputs = lazy.require('neo-tree.ui.inputs')

local this = PLGS.neotree
local e_mode = keymap.e_mode
local e_events = events.e_name

local set_global_commands = function (...)
  return {
    ngpong_nop_map = function (_)
    end,
    ngpong_nop_map_nv = function (_)
    end,
    ngpong_nop_map_nv_visual = function (_)
    end,
    ngpong_select_node = function(state)
      source_commands.open_with_window_picker(state, nil)
    end,
    ngpong_open_diff = function(state)
      local node = state.tree:get_node()

      if node.type == 'directory' or node.path == nil then
        return
      end

      HELPER.notify_info('toggleterm + lazygit TODO')
    end,
    ngpong_open_history = function(state)
      local node = state.tree:get_node()

      if node.type == 'directory' or node.path == nil then
        return
      end

      HELPER.notify_info('toggleterm + lazygit TODO')
    end,
    ngpong_esc = function(state)
      -- 0x1: 重置 file filter
      if state.name == 'filesystem' and state.search_pattern ~= nil then
        filesys_commands.clear_filter(state)
      end

      -- 0x2: 重置 preview
      if common_preview.is_active() ~= nil then
        source_commands.toggle_preview(state)
      end

      -- 0x3: 重置 copy/cut node
      if state.name ~= 'buffers' and state.clipboard ~= nil then
        local is_remove = false
        for _idx, _item in pairs(state.clipboard) do
          if _item.action == 'copy' or _item.action == 'cut' then
            is_remove = true
            state.clipboard[_idx] = nil
          end
        end

        if not next(state.clipboard) then
          state.clipboard = nil
        end

        if is_remove then
          this.api.redraw(state)
        end
      end
    end,
    ngpong_git_revert_file = function(state)
      local node = state.tree:get_node()
      if node.type == "message" then
        return
      end

      local path = node:get_id()
      local cmd = { "git", "checkout", "HEAD", "--", path }
      local msg = string.format("Are you sure you want to revert %s?", node.name)
      neotree_ui_inputs.confirm(msg, function(yes)
        if not yes then
          return
        end

        vim.fn.system(cmd)
        neotree_events.fire_event(neotree_events.GIT_EVENT)

        if HELPER.reload_file_if_shown(path) then
          this.api.refresh(state)
        end
      end)
    end
  }
end

local set_filesys_commands = function(...)
  return {
    ngpong_cd = function(state)
      if state.tree:get_node().level == 0 then
        filesys_commands.navigate_up(state)
      else
        filesys_commands.set_root(state)
      end
      this.api.refresh(state)
    end,
    ngpong_select_node = function (state)
      filesys_commands.open_with_window_picker(state)
    end,
  }
end

local set_gitstaus_commands = function(...)
  return {
  }
end

local mapping_opts = function(...)
  return {
    silent = true,
    noremap = true,
    nowait = true,
  }
end

local set_global_keymaps = function(...)
  return {
    ['x']          = { command = 'ngpong_nop_map_nv', desc = 'which_key_ignore' },
    ['X']          = { command = 'ngpong_nop_map_nv', desc = 'which_key_ignore' },
    ['c']          = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['C']          = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['z']          = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['Z']          = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['a']          = { command = 'ngpong_nop_map_nv', desc = 'which_key_ignore' },
    ['u']          = { command = 'ngpong_nop_map_nv', desc = 'which_key_ignore' },
    ['U']          = { command = 'ngpong_nop_map_nv', desc = 'which_key_ignore' },
    ['b']          = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['b.']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['b,']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['bs']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['bp']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['bc']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['bo']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['B']          = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['BC']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['B<']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['B>']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['bC']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['b<']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['b>']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['rv']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['rh']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['rc']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['ro']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['ts']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['m']          = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['m,']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['m.']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['md']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['md<leader>'] = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['md<CR>']     = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['me']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['ms']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['ms<leader>'] = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['mm']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['d']          = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['dd']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['dD']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['d,']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['d.']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['e.']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['e,']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['ff']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['f<leader>']  = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['fb']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['fl']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['fs']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['<leader>l']  = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['<leader>q']  = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['<leader>c']  = { command = 'ngpong_nop_map_nv', desc = 'which_key_ignore' },
    ['<leader>u']  = { command = 'ngpong_nop_map_nv', desc = 'which_key_ignore' },
    ['<leader>U']  = { command = 'ngpong_nop_map_nv', desc = 'which_key_ignore' },
    ['<leader>f']  = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['<leader>j']  = { command = 'ngpong_nop_map_nv', desc = 'which_key_ignore' },
    ['<leader>J']  = { command = 'ngpong_nop_map_nv', desc = 'which_key_ignore' },
    ['ef']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['ec']         = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['ef.']        = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['ef,']        = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['ec,']        = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },
    ['ec.']        = { command = 'ngpong_nop_map', desc = 'which_key_ignore' },

    -- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/940
    -- https://www.reddit.com/r/vim/comments/4ofv82/the_normal_command_is_really_cool/
    ['<ESC>']      = { command = 'ngpong_esc', desc = 'which_key_ignore' },
    ['<CR>']       = { command = 'ngpong_select_node', desc = 'NEOTREE: open selected node.' },
    ['<C-CR>']     = { command = 'toggle_node', desc = 'NEOTREE: toggle selected node.', config = { use_float = true } },
    ['<C-s>']      = { command = 'toggle_preview', desc = 'NEOTREE: preview(seek) selected node.', config = { use_float = true } },
    ['<C-S-s>']    = { command = 'focus_preview', desc = 'NEOTREE: focus preview(seek) window.', config = { use_float = true } },
    -- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/942
    ['<']          = { command = 'prev_source', desc = 'NEOTREE: switch to previous source.' },
    ['>']          = { command = 'next_source' , desc = 'NEOTREE: switch to next source.'},
    ['R']          = { command = 'refresh' , desc = 'NEOTREE: refresh neotree.'},
  }
end

local set_filesys_keymaps = function(...)
  return {
    ['f<CR>'] = { command = 'ngpong_cd', desc = 'change director or root.' },
    ['ff']    = { command = 'filter_on_submit', desc = 'open file filter.' },
    ['fh']    = { command = 'toggle_hidden', desc = 'toggle file hidden mode.' },
    ['fa']    = { command = 'add', desc = 'add file.' },
    ['fd']    = { command = 'delete', desc = 'delete file.' },
    ['fn']    = { command = 'rename', desc = 'rename file.' },
    ['fi']    = { command = 'show_file_details', desc = 'open file info.' },
    ['fm']    = { command = 'move', desc = 'move file.' },
    ['fy']    = { command = 'copy_to_clipboard', desc = 'copy file.' },
    ['fu']    = { command = 'paste_from_clipboard', desc = 'paste file.' },
    ['fx']    = { command = 'cut_to_clipboard', desc = 'cut file.' },
    ['fe']    = { command = 'expand_all_nodes', desc = 'expand all directories.' },
    ['fE']    = { command = 'close_all_nodes', desc = 'closepand all directories.' },
    ['frv']   = { command = 'split_with_window_picker', desc = 'vertically.' },
    ['frh']   = { command = 'vsplit_with_window_picker', desc = 'horizontally' },
    ['ft']    = { command = 'open_tabnew', desc = 'tabpage split selected node.' },
    ['gu']    = { command = 'git_unstage_file', desc = 'unstage the selected node.' },
    ['ga']    = { command = 'git_add_file', desc = 'stage the selected node.' },
    ['gr']    = { command = 'ngpong_git_revert_file', desc = 'restore this selected node.' },
    ['g,']    = { command = 'prev_git_modified', desc = 'jump to previous git modified node.' },
    ['g.']    = { command = 'next_git_modified', desc = 'jump to next git modified node.' },
  }
end

local set_gitstaus_keymaps = function(...)
  return {
    ['fa']  = { command = 'add', desc = 'add file.' },
    ['fd']  = { command = 'delete', desc = 'delete file.' },
    ['fn']  = { command = 'rename', desc = 'rename file.' },
    ['fi']  = { command = 'show_file_details', desc = 'open file info.' },
    ['fm']  = { command = 'move', desc = 'move file.' },
    ['fy']  = { command = 'copy_to_clipboard', desc = 'copy file.' },
    ['fu']  = { command = 'paste_from_clipboard', desc = 'paste file.' },
    ['fx']  = { command = 'cut_to_clipboard', desc = 'cut file.' },
    ['frv'] = { command = 'split_with_window_picker', desc = 'vertically.' },
    ['frh'] = { command = 'vsplit_with_window_picker', desc = 'horizontally' },
    ['ft']  = { command = 'open_tabnew', desc = 'tabpage split selected node.' },
    ['gu']  = { command = 'git_unstage_file', desc = 'unstage the selected node.' },
    ['ga']  = { command = 'git_add_file', desc = 'stage the selected node.' },
    ['gr']  = { command = 'ngpong_git_revert_file', desc = 'restore this selected node.' },
  }
end

local del_native_keymaps = function()
end

local set_native_keymaps = function()
  keymap.register(e_mode.NORMAL, '<leader>e', this.api.open_tree, { remap = false, silent = true, desc = 'open file explore.' })
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()

  events.rg(e_events.SETUP_NEOTREE, function(cfg)
    TOOLS.tbl_r_extend(cfg, {
      commands = set_global_commands(),
      window = {
        mapping_options = mapping_opts(),
        mappings = set_global_keymaps(),
      },
      filesystem = {
        commands = set_filesys_commands(),
        window = {
          mapping_options = mapping_opts(),
          mappings = set_filesys_keymaps(),
        }
      },
      git_status = {
        commands = set_gitstaus_commands(),
        window = {
          mapping_options = mapping_opts(),
          mappings = set_gitstaus_keymaps(),
        }
      },
    })
  end)
end

return M

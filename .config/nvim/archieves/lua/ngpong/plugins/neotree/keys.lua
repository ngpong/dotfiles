local M = {}

local Neotree         = vim.__lazy.require("neo-tree")
local SourceCommands  = vim.__lazy.require("neo-tree.sources.common.commands")
local FilesysCommands = vim.__lazy.require("neo-tree.sources.filesystem.commands")
local NeotreeEvents   = vim.__lazy.require("neo-tree.events")
local NeotreeUIInputs = vim.__lazy.require("neo-tree.ui.inputs")

local n_api = vim._plugins.neotree.api

local kmodes = vim.__key.e_mode
local etypes = vim.__event.types

local set_global_commands = function (...)
  return {
    ngpong_nop_map = function (_)
    end,
    ngpong_nop_map_nv = function (_)
    end,
    ngpong_nop_map_nv_visual = function (_)
    end,
    ngpong_select_node = function(state)
      SourceCommands.open_with_window_picker(state, nil)
    end,
    ngpong_open_diff = function(state)
      local node = state.tree:get_node()

      if node.type == "directory" or node.path == nil then
        return
      end

      vim.__notifier.info("toggleterm + lazygit TODO")
    end,
    ngpong_open_history = function(state)
      local node = state.tree:get_node()

      if node.type == "directory" or node.path == nil then
        return
      end

      vim.__notifier.info("toggleterm + lazygit TODO")
    end,
    ngpong_toggle_preview = function (state)
      n_api.toggle_preview(state)
    end,
    ngpong_esc = function(state)
      -- 0x1: 重置 file filter
      if state.name == "filesystem" and state.search_pattern ~= nil then
        FilesysCommands.clear_filter(state)
      end

      -- 0x2: 重置 copy/cut node
      if state.name ~= "buffers" and state.clipboard ~= nil then
        local is_remove = false
        for _idx, _item in pairs(state.clipboard) do
          if _item.action == "copy" or _item.action == "cut" then
            is_remove = true
            state.clipboard[_idx] = nil
          end
        end

        if not next(state.clipboard) then
          state.clipboard = nil
        end

        if is_remove then
          n_api.redraw(state)
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
      NeotreeUIInputs.confirm(msg, function(yes)
        if not yes then
          return
        end

        vim.fn.system(cmd)
        NeotreeEvents.fire_event(NeotreeEvents.GIT_EVENT)

        if vim.__helper.reload_file_if_shown(path) then
          n_api.refresh(state)
        end
      end)
    end
  }
end

local set_filesys_commands = function(...)
  return {
    ngpong_cd = function(state)
      if state.tree:get_node().level == 0 then
        FilesysCommands.navigate_up(state)
      else
        FilesysCommands.set_root(state)
      end
      n_api.refresh(state)
    end,
    ngpong_select_node = function (state)
      FilesysCommands.open_with_window_picker(state)
    end,
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
    ["x"]          = { command = "ngpong_nop_map_nv", desc = "which_key_ignore" },
    ["X"]          = { command = "ngpong_nop_map_nv", desc = "which_key_ignore" },
    ["c"]          = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["C"]          = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["a"]          = { command = "ngpong_nop_map_nv", desc = "which_key_ignore" },
    ["u"]          = { command = "ngpong_nop_map_nv", desc = "which_key_ignore" },
    ["U"]          = { command = "ngpong_nop_map_nv", desc = "which_key_ignore" },
    ["b"]          = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["b."]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["b,"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["bs"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["bp"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["bc"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["bo"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["B"]          = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["BC"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["B<"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["B>"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["b<"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["b>"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["rv"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["rh"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["rc"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["ts"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["m"]          = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["m,"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["m."]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["md"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["md<leader>"] = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["md<CR>"]     = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["me"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["ms"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["ms<leader>"] = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["mm"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["d"]          = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["dd"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["dD"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["d,"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["d."]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["e."]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["e,"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["ff"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["f<leader>"]  = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["fb"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["fl"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["fs"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["fw"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["fg"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["fn"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["fm"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["<leader>l"]  = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["<leader>q"]  = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["<leader>c"]  = { command = "ngpong_nop_map_nv", desc = "which_key_ignore" },
    ["<leader>u"]  = { command = "ngpong_nop_map_nv", desc = "which_key_ignore" },
    ["<leader>U"]  = { command = "ngpong_nop_map_nv", desc = "which_key_ignore" },
    ["<leader>f"]  = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["<leader>j"]  = { command = "ngpong_nop_map_nv", desc = "which_key_ignore" },
    ["<leader>J"]  = { command = "ngpong_nop_map_nv", desc = "which_key_ignore" },
    ["e1"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["e2"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["e3"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["e4"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["e5"]         = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["e1."]        = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["e1,"]        = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["e2,"]        = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["e2."]        = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["e3,"]        = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["e3."]        = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["e4,"]        = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["e4."]        = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["e5,"]        = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["e5."]        = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["n"]        = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["n,"]        = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["n."]        = { command = "ngpong_nop_map", desc = "which_key_ignore" },
    ["nn"]        = { command = "ngpong_nop_map", desc = "which_key_ignore" },

    -- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/940
    -- https://www.reddit.com/r/vim/comments/4ofv82/the_normal_command_is_really_cool/
    ["<ESC>"]      = { command = "ngpong_esc", desc = "which_key_ignore" },
    ["<CR>"]       = { command = "ngpong_select_node", desc = "NEOTREE: open selected node." },
    ["z"]          = { command = "toggle_node", desc = "NEOTREE: toggle selected node." },
    ["<C-z>"]      = { command = "close_all_nodes", desc = "NEOTREE: close all nodes." },
    ["Z"]          = { command = "expand_all_nodes", desc = "NEOTREE: expand all nodes." },
    ["<C-p>"]      = { command = "ngpong_toggle_preview", desc = "NEOTREE: preview selected node.", config = { use_float = false } },
    ["O"]          = { command = "scroll_preview", desc = "NEOTREE: scroll up preview window.", config = { direction = 5 } },
    ["L"]          = { command = "scroll_preview", desc = "NEOTREE: scroll down preview window.", config = { direction = -5 } },
    ["R"]          = { command = "refresh" , desc = "NEOTREE: refresh neotree."},
  }
end

local set_filesys_keymaps = function(...)
  return {
    ["f<CR>"] = { command = "ngpong_cd", desc = "change director or root." },
    ["ff"]    = { command = "filter_on_submit", desc = "open file filter." },
    ["fh"]    = { command = "toggle_hidden", desc = "toggle file hidden mode." },
    ["fa"]    = { command = "add", desc = "add file." },
    ["fd"]    = { command = "delete", desc = "delete file." },
    ["fn"]    = { command = "rename", desc = "rename file." },
    ["fi"]    = { command = "show_file_details", desc = "open file info." },
    ["fm"]    = { command = "move", desc = "move file." },
    ["fy"]    = { command = "copy_to_clipboard", desc = "copy file." },
    ["fu"]    = { command = "paste_from_clipboard", desc = "paste file." },
    ["fx"]    = { command = "cut_to_clipboard", desc = "cut file." },
    ["fe"]    = { command = "expand_all_nodes", desc = "expand all directories." },
    ["fE"]    = { command = "close_all_nodes", desc = "closepand all directories." },
    ["ft"]    = { command = "open_tabnew", desc = "tabpage split selected node." },
    ["gu"]    = { command = "git_unstage_file", desc = "unstage the selected node." },
    ["ga"]    = { command = "git_add_file", desc = "stage the selected node." },
    ["gr"]    = { command = "ngpong_git_revert_file", desc = "restore this selected node." },
    ["g,"]    = { command = "prev_git_modified", desc = "jump to previous git modified node." },
    ["g."]    = { command = "next_git_modified", desc = "jump to next git modified node." },
  }
end

local del_native_keymaps = function()
end

local set_native_keymaps = function()
  vim.__key.rg(kmodes.N, "<leader>e", n_api.open_tree)
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()

  vim.__event.rg(etypes.SETUP_NEOTREE, function(cfg)
    cfg.commands = set_global_commands()
    cfg.window.mapping_options = mapping_opts()
    cfg.window.mappings = set_global_keymaps()
    cfg.filesystem.commands = set_filesys_commands()
    cfg.filesystem.window.mapping_options = mapping_opts()
    cfg.filesystem.window.mappings = set_filesys_keymaps()
  end)
end

return M

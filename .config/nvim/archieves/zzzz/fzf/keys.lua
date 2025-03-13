local M = {}

local Fzflua        = vim.__lazy.require("fzf-lua")
local FzfluaActions = vim.__lazy.require("fzf-lua.actions")

local kmodes = vim.__key.e_mode
local etypes = vim.__event.types

local set_global_keymaps = function()
  return {
    -- Below are the default binds, setting any value in these tables will override
    -- the defaults, to inherit from the defaults change [1] from `false` to `true`
    builtin = {
      false,          -- do not inherit from defaults
      -- neovim `:tmap` mappings for the fzf win
      ["<M-Esc>"]    = false, -- "hide",     -- hide fzf-lua, `:FzfLua resume` to continue
      ["<F1>"]       = "toggle-help", -- "toggle-help",
      ["<F2>"]       = false, -- "toggle-fullscreen",
      -- Only valid with the 'builtin' previewer
      ["<F3>"]       = false, -- "toggle-preview-wrap",
      ["<F4>"]       = "toggle-preview", -- "toggle-preview",
      -- Rotate preview clockwise/counter-clockwise
      ["<F5>"]       = false, -- "toggle-preview-ccw",
      ["<F6>"]       = false, -- "toggle-preview-cw",
      ["<S-down>"]   = false, -- "preview-page-down",
      ["<S-up>"]     = false, -- "preview-page-up",
      ["<M-S-down>"] = false, -- "preview-down",
      ["<M-S-up>"]   = false, -- "preview-up",
    },
    fzf = {
      false,          -- do not inherit from defaults
      -- fzf '--bind=' options
      ["ctrl-z"]     = "abort", -- "abort",
      ["ctrl-u"]     = false, -- "unix-line-discard",
      ["ctrl-f"]     = false, -- "half-page-down",
      ["ctrl-b"]     = false, -- "half-page-up",
      ["ctrl-a"]     = false, -- "beginning-of-line",
      ["ctrl-e"]     = false, -- "end-of-line",
      ["alt-b"]      = false, -- "toggle-all",
      ["alt-g"]      = false, -- "last",
      ["alt-G"]      = false, -- "first",
      -- Only valid with fzf previewers (bat/cat/git/etc)
      ["f3"]         = false, -- "toggle-preview-wrap",
      ["f4"]         = false, -- "toggle-preview",
      ["shift-down"] = false, -- "preview-page-down",
      ["shift-up"]   = false, -- "preview-page-up",
      ["ctrl-w"]     = "toggle-preview-wrap",
      -- ["ctrl-p"]     = "toggle-preview",
    },
  }
end

local set_global_actions = function()
  return {
    --  Below are the default actions, setting any value in these tables will override
    -- the defaults, to inherit from the defaults change [1] from `false` to `true`
    files = {
      false, -- do not inherit from defaults
      -- Pickers inheriting these actions:
      --   files, git_files, git_status, grep, lsp, oldfiles, quickfix, loclist,
      --   tags, btags, args, buffers, tabs, lines, blines
      -- `file_edit_or_qf` opens a single selection or sends multiple selection to quickfix
      -- replace `enter` with `file_edit` to open all files/bufs whether single or multiple
      -- replace `enter` with `file_switch_or_edit` to attempt a switch in current tab first
      ["enter"]  = FzfluaActions.file_edit_or_qf,
      ["ctrl-s"] = false, -- FzfluaActions.file_split
      ["ctrl-v"] = false, -- FzfluaActions.file_vsplit
      ["ctrl-t"] = false, -- FzfluaActions.file_tabedit
      ["alt-q"]  = false, -- FzfluaActions.file_sel_to_qf
      ["alt-Q"]  = false, -- FzfluaActions.file_sel_to_ll
    },
  }
end

local set_providers_files_actions = function()
  return {
    -- inherits from 'actions.files', here we can override
    -- or set bind to 'false' to disable a default action
    -- action to toggle `--no-ignore`, requires fd or rg installed
    ["ctrl-g"]      = false, -- FzfluaActions.toggle_ignore
    -- uncomment to override `actions.file_edit_or_qf`
    --   ["enter"]  = actions.file_edit,
    -- custom actions are available too
    --   ["ctrl-y"] = function(selected) print(selected[1]) end,
  }
end

local set_providers_gitstatus_actions = function()
  return {
    -- actions inherit from 'actions.files' and merge
    ["right"]  = { fn = FzfluaActions.git_unstage, reload = true },
    ["left"]   = { fn = FzfluaActions.git_stage, reload = true },
    ["ctrl-x"] = { fn = FzfluaActions.git_reset, reload = true },

    -- If you wish to use a single stage|unstage toggle instead
    -- using 'ctrl-s' modify the table as shown below
    -- 
    --   ["right"]   = false,
    --   ["left"]    = false,
    --   ["ctrl-x"]  = { fn = actions.git_reset, reload = true },
    --   ["ctrl-s"]  = { fn = actions.git_stage_unstage, reload = true },
  }
end

local set_providers_gitcommits_actions = function()
  return {
    ["enter"]  = FzfluaActions.git_checkout,
    -- remove `exec_silent` or set to `false` to exit after yank
    ["ctrl-y"] = { fn = FzfluaActions.git_yank_commit, exec_silent = true },
  }
end

local set_providers_gitbcommits_actions = function()
  return {
    ["enter"]  = FzfluaActions.git_buf_edit,
    ["ctrl-s"] = FzfluaActions.git_buf_split,
    ["ctrl-v"] = FzfluaActions.git_buf_vsplit,
    ["ctrl-t"] = FzfluaActions.git_buf_tabedit,
    ["ctrl-y"] = { fn = FzfluaActions.git_yank_commit, exec_silent = true },
  }
end

local set_providers_gitbranches_actions = function()
  return {
    ["enter"]  = FzfluaActions.git_switch,
    ["ctrl-x"] = { fn = FzfluaActions.git_branch_del, reload = true },
    ["ctrl-a"] = { fn = FzfluaActions.git_branch_add, field_index = "{q}", reload = true },
  }
end

local set_providers_gittags_actions = function()
  return {
    ["enter"] = FzfluaActions.git_checkout
  }
end

local set_providers_gitstash_actions = function()
  return {
    ["enter"]  = FzfluaActions.git_stash_apply,
    ["ctrl-x"] = { fn = FzfluaActions.git_stash_drop, reload = true },
  }
end

local set_providers_grep_actions = function()
  return {
    -- actions inherit from 'actions.files' and merge
    -- this action toggles between 'grep' and 'live_grep'
    ["ctrl-g"]    = { FzfluaActions.grep_lgrep }
    -- uncomment to enable '.gitignore' toggle for grep
    -- ["ctrl-r"] = { actions.toggle_ignore }
  }
end

local set_providers_args_actions = function()
  return {
    -- actions inherit from 'actions.files' and merge
    ["ctrl-x"] = { fn = FzfluaActions.arg_del, reload = true }
  }
end

local set_providers_buffers_actions = function()
  return {
    -- actions inherit from 'actions.files' and merge
    -- by supplying a table of functions we're telling
    -- fzf-lua to not close the fzf window, this way we
    -- can resume the buffers picker on the same window
    -- eliminating an otherwise unaesthetic win "flash"
    ["ctrl-x"] = { fn = FzfluaActions.buf_del, reload = true },
  }
end

local set_providers_tabs_actions = function()
  return {
    -- actions inherit from 'actions.files' and merge
    ["enter"]  = FzfluaActions.buf_switch,
    ["ctrl-x"] = { fn = FzfluaActions.buf_del, reload = true },
  }
end

local set_providers_lines_actions = function()
  return {
    -- actions inherit from 'actions.files' and merge
    ["enter"] = FzfluaActions.buf_edit_or_qf,
    ["alt-q"] = FzfluaActions.buf_sel_to_qf,
    ["alt-l"] = FzfluaActions.buf_sel_to_ll
  }
end

local set_providers_blines_actions = function()
  return {
    -- actions inherit from 'actions.files' and merge
    ["enter"]  = FzfluaActions.buf_edit_or_qf,
    ["alt-q"]  = FzfluaActions.buf_sel_to_qf,
    ["alt-l"]  = FzfluaActions.buf_sel_to_ll
  }
end

local set_providers_tags_actions = function()
  return {
    -- actions inherit from 'actions.files' and merge
    -- this action toggles between 'grep' and 'live_grep'
    ["ctrl-g"] = { FzfluaActions.grep_lgrep }
  }
end

local set_providers_awesome_colorschemes_actions = function()
  return {
    ["enter"]  = FzfluaActions.colorscheme,
    ["ctrl-g"] = { fn = FzfluaActions.toggle_bg, exec_silent = true },
    ["ctrl-r"] = { fn = FzfluaActions.cs_update, reload = true },
    ["ctrl-x"] = { fn = FzfluaActions.cs_delete, reload = true },
  }
end

local set_providers_colorschemes_actions = function()
  return {
    ["enter"] = FzfluaActions.colorscheme
  }
end

local set_providers_keymaps_actions = function()
  return {
    ["enter"]  = FzfluaActions.keymap_apply,
    ["ctrl-s"] = FzfluaActions.keymap_split,
    ["ctrl-v"] = FzfluaActions.keymap_vsplit,
    ["ctrl-t"] = FzfluaActions.keymap_tabedit,
  }
end

local set_providers_complete_file_actions = function()
  return {
    -- actions inherit from 'actions.files' and merge
    ["enter"] = FzfluaActions.complete
  }
end

local set_providers_complete_path_actions = function()
  return {
    ["enter"] = FzfluaActions.complete
  }
end

local set_native_keymaps = function()
end

local set_buffer_keymaps = function(state)
  vim.__key.rg(kmodes.T, "<C-[>", "<C-p>", { buffer = state.bufnr })
  vim.__key.rg(kmodes.T, "<C-]>", "<C-n>", { buffer = state.bufnr })
  vim.__key.rg(kmodes.T, "<A-[>", "<UP>", { buffer = state.bufnr })
  vim.__key.rg(kmodes.T, "<A-]>", "<DOWN>", { buffer = state.bufnr })
  vim.__key.rg(kmodes.T, "<A-o>", "<nop>", { buffer = state.bufnr })
  vim.__key.rg(kmodes.T, "<A-l>", "<nop>", { buffer = state.bufnr })
  vim.__key.rg(kmodes.T, "<A-k>", "<LEFT>", { buffer = state.bufnr })
  vim.__key.rg(kmodes.T, "<A-;>", "<RIGHT>", { buffer = state.bufnr })
  vim.__key.rg(kmodes.T, "<A-q>", "<C-LEFT>", { buffer = state.bufnr })
  vim.__key.rg(kmodes.T, "<A-w>", "<C-RIGHT>", { buffer = state.bufnr })
end

local set_config_keymaps = function(cfg)
  cfg.keymap = set_global_keymaps()
  cfg.actions = set_global_actions()
  cfg.files.actions = set_providers_files_actions()
  cfg.git.status.actions = set_providers_gitstatus_actions()
  cfg.git.commits.actions = set_providers_gitcommits_actions()
  cfg.git.bcommits.actions = set_providers_gitbcommits_actions()
  cfg.git.branches.actions = set_providers_gitbranches_actions()
  cfg.git.tags.actions = set_providers_gittags_actions()
  cfg.git.stash.actions = set_providers_gitstash_actions()
  cfg.grep.actions = set_providers_grep_actions()
  cfg.args.actions = set_providers_args_actions()
  cfg.buffers.actions = set_providers_buffers_actions()
  cfg.tabs.actions = set_providers_tabs_actions()
  cfg.lines.actions = set_providers_lines_actions()
  cfg.blines.actions = set_providers_blines_actions()
  cfg.tags.actions = set_providers_tags_actions()
  cfg.colorschemes.actions = set_providers_colorschemes_actions()
  cfg.awesome_colorschemes.actions = set_providers_awesome_colorschemes_actions()
  cfg.keymaps.actions = set_providers_keymaps_actions()
  cfg.complete_path.complete = set_providers_complete_path_actions()
  cfg.complete_file.actions = set_providers_complete_file_actions()
end

M.setup = function()
  set_native_keymaps()

  vim.__event.rg(etypes.SETUP_FZFLUA, function(cfg)
    set_config_keymaps(cfg)
  end)

  vim.__event.rg(etypes.FZFLUA_LOAD, function(state)
    set_buffer_keymaps(state)
  end)
end

return M

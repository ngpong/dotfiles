local M = {}

local Telescope = vim.__lazy.require("telescope")

local t_api = vim._plugins.telescope.api
local t_picker = vim._plugins.telescope.picker
local t_sorter = vim._plugins.telescope.sorter

local tu_api = vim._plugins.trouble.api
local bl_api = vim._plugins.bufferline.api

local kmodes = vim.__key.e_mode
local etypes = vim.__event.types

local wrap_handler = function(handler, wrap_normal)
  local final_handler = nil
  if wrap_normal then
    final_handler = function()
      handler()
    end
  elseif type(handler) == "string" then
    final_handler = handler
  elseif type(handler) == "table" or type(handler) == "function" then
    final_handler = function()
      handler(vim.__buf.current())
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
  vim.__tbl.r_extend(final_opts, opts or {})

  return {
    wrap_handler(handler, wrap_normal),
    type = "command",
    opts = final_opts,
  }
end

local set_plugin_keymaps = function()
  return {
    n = {
      -----------------------------disable keymap-----------------------------
      ["<C-v>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<C-S-l>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<C-S-o>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<C-o>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<C-l>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["s"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["S"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["/"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["?"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["b"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["b["] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["b]"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["b."] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["b,"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["bb"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["bp"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["bs"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["bc"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["bo"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["B"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["BC"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["B<"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["B>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["t"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["to"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["tc"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["ts"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["t."] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["t,"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["r"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["rc"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["r;"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["rl"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["r\""] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["rp"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["rh"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["rv"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["r="] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["r-"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["rs"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["rsh"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["rsv"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["m"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["m,"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["m."] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["md"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["md<leader>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["md<CR>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["me"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["ms"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["ms<leader>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["mm"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["f"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["ff"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["f<leader>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["fs"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["fb"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["fw"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["fg"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["fn"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["fd"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["fm"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<leader>e"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<leader>l"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<leader>q"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<leader>f"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<leader>c"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<leader>p"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<leader>P"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<leader>j"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<leader>J"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<leader>h"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<HOME>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<END>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["d"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["d."] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["d,"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["dd"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["dD"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["g"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["gg"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<BS>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e,"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e."] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e;"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["ep"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["eP"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e:"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["eh"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e1"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e2"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e3"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e4"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e5"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e1."] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e1,"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e2."] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e2,"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e3."] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e3,"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e4."] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e4,"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e5."] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["e5,"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["et"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["eg"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["n"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["n,"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["n."] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["nn"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<A-p>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<C-s>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<C-S>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<A-[>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<A-]>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ----------------------------------------------------------------------

      -----------------------------remap keymap-----------------------------
      -- history
      ["<C-[>"] = wrap_keymap(t_api.actions.cycle_history_prev, { desc = "TELESCOPE: cycle previouse history." }),
      ["<C-]>"] = wrap_keymap(t_api.actions.cycle_history_next, { desc = "TELESCOPE: cycle next history." }),

      -- preview
      ["O"] = wrap_keymap(t_api.scroll_preview(-1, 5), { desc = "TELESCOPE: scrolling preview window pageup." }),
      ["L"] = wrap_keymap(t_api.scroll_preview(1, 5), { desc = "TELESCOPE: scrolling preview window pagedown." }),
      -- [":"] = wrap_keymap(t_api.actions.preview_scrolling_left, { desc = "TELESCOPE: scrolling left (horizontal)preview window." }),
      -- ["K"] = wrap_keymap(t_api.actions.preview_scrolling_right, { desc = "TELESCOPE: scrolling right (horizontal)preview window." }),

      -- result
      -- NOTE: Open muilt files at onces is in roadmap. https://github.com/nvim-telescope/telescope.nvim/issues/1048
      ["<CR>"] = wrap_keymap(t_api.select_entries, { desc = "TELESCOPE: select entries." }),
      ["<C-p>"] = wrap_keymap(t_api.toggle_preview, { desc = "TELESCOPE: toggle file preview." }),
      ["<Tab>"] = wrap_keymap(t_api.actions.toggle_selection, { desc = "TELESCOPE: Toggle selection." }),
      ["<S-Tab>"] = wrap_keymap(t_api.actions.toggle_all, { desc = "TELESCOPE: Toggle all selection." }),
      ["["] = wrap_keymap(t_api.actions.move_selection_previous, { desc = "TELESCOPE: move to prev selection." }),
      ["]"] = wrap_keymap(t_api.actions.move_selection_next, { desc = "TELESCOPE: move to next selection." }),
      -- ["<C-[>"] = wrap_keymap(t_api.scroll_result(-1, 3), { desc = "TELESCOPE: scrolling result entries pageup." }),
      -- ["<C-]>"] = wrap_keymap(t_api.scroll_result(1, 3), { desc = "TELESCOPE: scrolling result entries pagedown." }),
      -- ["<nop>"] = wrap_keymap(t_api.scroll_result(-1, 3), { desc = "TELESCOPE: scrolling up result entries." }),
      -- ["<nop>"] = wrap_keymap(t_api.scroll_result(1, 3), { desc = "TELESCOPE: scrolling down result entries." }),
      -- ["<nop>"] = wrap_keymap(t_api.actions.move_to_top, { desc = "result entries head." }),
      -- ["<nop>"] = wrap_keymap(t_api.actions.move_to_bottom, { desc = "result entries tail." }),
      ----------------------------------------------------------------------
    },
    i = {
      ["<CR>"] = wrap_keymap(t_api.actions.nop, { desc = "which_key_ignore" }),
      ["<ESC>"] = wrap_keymap(vim.__util.wrap_f(vim.__key.feed, vim.__key, "<ESC>l"), { desc = "which_key_ignore" }, true),
    },
  }
end

local del_native_keymaps = function() end

local set_native_keymaps = function()
  vim.__key.rg(kmodes.N, "f<leader>", "<CMD>Telescope<CR>", { silent = true, desc = "open builtin pickers." })
  vim.__key.rg(kmodes.N, "ff", "<CMD>Telescope find_files<CR>", { silent = true, desc = "find files." })
  vim.__key.rg(kmodes.N, "fF", vim.__util.wrap_f(tu_api.toggle, "telescope_multi_selected_files", { append_cache = false }), { silent = true, desc = "open find files selected." })
  vim.__key.rg(kmodes.N, "fd", "<CMD>Telescope diagnostics<CR>", { desc = "find workspace diagnostics." })
  vim.__key.rg(kmodes.N, "fm", vim.__util.wrap_f(t_picker.marks), { desc = "find workspace marks." })
  vim.__key.rg(kmodes.N, "fs", function()
    local args = {
      only_sort_text = true,
      custom_sorter = t_sorter.native_vim_grep()
    }

    Telescope.extensions.live_grep_args.live_grep_args(args)
  end, { silent = true, desc = "find string with live grep mode." })
  vim.__key.rg(kmodes.N, "fS", vim.__util.wrap_f(tu_api.toggle, "telescope_multi_selected_lines", { append_cache = false }), { silent = true, desc = "open live grep selected." })
  vim.__key.rg(kmodes.VS, "fs", function ()
    local selected_text = vim.__helper.get_selected()

    vim.fn.setreg("*", selected_text)

    local args = {
      default_text = selected_text,
      custom_sorter = t_sorter.native_vim_grep()
    }

    Telescope.extensions.live_grep_args.live_grep_args(args)
  end, { silent = true, desc = "which_key_ignore" })
  vim.__key.rg(kmodes.N, "fw", function()
    local opts = { show_line = true }
    t_api.builtin_picker("lsp_document_symbols", opts)
  end, { silent = true, desc = "find document symbols in the current buffer." })
  vim.__key.rg(kmodes.N, "fn", function()
    t_picker.todo()
  end, { silent = true, desc = "find workspace todo comment list." })
  vim.__key.rg(kmodes.N, "fb", function()
    local is_pinned  = bl_api.is_pinned("all")
    local components = bl_api.get_components()

    local sorted_cache = {}
    for i = 1, #components do
      sorted_cache[components[i]:as_element().id] = i
    end

    t_api.builtin_picker("buffers", {
      is_have_pinned = is_pinned,
      sort_buffers = function(l, r)
        return sorted_cache[l] < sorted_cache[r]
      end
    })
  end, { silent = true, desc = "find active buffers." })

  if vim.__git.valid() then
    vim.__key.rg(kmodes.N, "fg", function()
      -- NOTE:
      -- 为了避免在没有 diff 的情况下打开 status 会出现闪烁的情况，这里
      -- 又加了一层判断。
      --
      -- 按道理来说应当使用异步逻辑，但是这里使用异步逻辑会出现一些问题
      if vim.__git.if_has_diff_sync() then
        t_api.builtin_picker("git_status")
      else
        vim.__notifier.warn("No result from git_status")
      end
    end, { silent = true, desc = "find git status list." })
  end
end

local set_buffer_keymaps = function(state)
  vim.__key.rg(kmodes.N, "<ESC>", vim.__util.wrap_f(t_api.close_telescope, state.bufnr), { buffer = state.bufnr, desc = "which_key_ignore" })

  if state.picker.prompt_title == "Buffers" then
    vim.__key.rg(kmodes.N, "<C-CR>", vim.__util.wrap_f(t_api.delete_entries, state.bufnr), { buffer = state.bufnr, desc = "TELESCOPE: delete entries." })
    vim.__key.unrg(kmodes.N, "<M-d>", { buffer = state.bufnr })
  end

  if state.picker.prompt_title == "Git Commits" then
    vim.__key.unrg(kmodes.N, "<Tab>", { buffer = state.bufnr })
    vim.__key.unrg(kmodes.N, "<CR>", { buffer = state.bufnr })
  end
end

local set_config_keymaps = function(cfg)
  -- completely remove all default mappings
  cfg.defaults.default_mappings = set_plugin_keymaps()

  -- -- 下面的配置无法显示 desc，参考这篇：https://github.com/nvim-telescope/telescope.nvim/issues/2981
  -- cfg.pickers.buffers.attach_mappings = function(_, map)
  --   -- map("n", "<C-CR>", function() t_api.delete_entries(vim.__buf.current()) end, { desc = "TELESCOPE: delete entries." })
  --   return true
  -- end
end

M.setup = function()
  del_native_keymaps()
  set_native_keymaps()

  vim.__event.rg(etypes.SETUP_TELESCOPE, function(cfg)
    set_config_keymaps(cfg)
  end)

  vim.__event.rg(etypes.TELESCOPE_LOAD, function(state)
    set_buffer_keymaps(state)
  end)
end

return M

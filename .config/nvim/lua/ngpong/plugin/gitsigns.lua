local Gitsigns = vim.__lazy.require("gitsigns")

local Module = vim.__class.def(function(this)
  function this:is_attach(bufnr)
    return require("gitsigns.cache").cache[bufnr] ~= nil
  end

  function this:is_diffthis(cb)
    for _, _winid in pairs(vim.__win.all()) do
      local bufnr   = vim.__buf.number(_winid)

      if vim.__buf.name(bufnr):match("^gitsigns:") then
        if cb then cb(bufnr, _winid) end
        return true
      end
    end

    return false
  end
end)

return {
  "lewis6991/gitsigns.nvim",
  lazy = true,
  event = "LazyFile",
  highlights = {
    { "GitSignsUntrackedNr", fg = vim.__color.bright_blue },
    { "GitSignsUntracked", fg = vim.__color.bright_blue },
    { "GitSignsChange", fg = vim.__color.bright_yellow },
    { "GitSignsChangeNr", fg = vim.__color.bright_yellow },
  },
  keys = {
    { "<leader>hd", function()
      if vim.__win.close_diff() then
        return
      end

      local path = vim.__buf.name(vim.__buf.current())
      vim.__git.if_has_diff_or_untracked(path, function() Gitsigns.diffthis() end)
    end },
    { "[h"        , function() Gitsigns.prev_hunk({ wrap = false, navigation_message = true }) end, mode = vim.__key.e_mode.NVSO },
    { "]h"        , function() Gitsigns.next_hunk({ wrap = false, navigation_message = true }) end, mode = vim.__key.e_mode.NVSO },
    { "ih"        , function() Gitsigns.select_hunk() end, mode = { vim.__key.e_mode.O, vim.__key.e_mode.VS } },
    { "<leader>hr", function() Gitsigns.reset_hunk() end },
    { "<leader>hR", function()
      local bufnr = vim.__buf.current()
      if not vim.__gitsigns:is_attach(bufnr) then
        return
      end

      vim.__ui.input({ prompt = "This operation will restore the entire file, yes(y) or no(n,...)?", relative = "editor" }, function(res)
        if res ~= "y" then
          return
        end
        Gitsigns.reset_buffer()
      end)
    end },
    { "<leader>hb", function() Gitsigns.blame_line() end },
    { "<leader>hP", function() Gitsigns.preview_hunk_inline() end },
    { "<leader>hp", function() Gitsigns.preview_hunk() end },
  },
  opts = {
    signs = {
      -- ┃ ▕ ┋
      -- add          = { text = "┃" },
      -- change       = { text = "┃" },
      -- delete       = { text = "┋" },
      -- topdelete    = { text = "┋" },
      changedelete = { text = "┃" },
      untracked    = { text = "┋" },
    },
    debug_mode = false,
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    signs_staged_enable = false,
    watch_gitdir = {
      enable = true,
      follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
      delay = 700,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%R>  <summary>",
    current_line_blame_formatter_nc = "<author>, <author_time:%R>",
    sign_priority = 100,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    trouble = true,
    preview_config = {
      border = vim.__icons.border.no,
      style = "minimal",
      relative = "cursor",
      -- anchor = "SW",
      row = 1,
      col = 0
    },
    on_attach = function(bufnr)
      vim.__autocmd.exec("User", { pattern = "GitSignsAttached", data = bufnr })
      vim.__stl.redraw(true)

      vim.__autocmd.on("User", function()
        vim.__stl.redraw(true)
      end, { pattern = "GitSignsUpdate", once = true })
    end
  },
  config = function(p, opts)
    vim.__gitsigns = Module:new()
    require("gitsigns").setup(opts)
  end
}
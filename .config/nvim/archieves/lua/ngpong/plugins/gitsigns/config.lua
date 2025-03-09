local M = {}

local etypes = vim.__event.types

M.setup = function()
  require("gitsigns").setup {
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
      -- Options passed to nvim_open_win
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1
    },
    on_attach = function(bufnr)
      vim.__event.emit(etypes.ATTACH_GITSIGNS, { bufnr = bufnr })
    end
  }
end

return M

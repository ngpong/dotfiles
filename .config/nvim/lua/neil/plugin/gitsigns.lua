return {
  "lewis6991/gitsigns.nvim",
  main = "gitsigns",
  lazy = true,
  event = "LazyFile",
  dispatchs = {
    {
      "gitsigns",
      function(this)
        function this:is_attach(bufnr)
          return require("gitsigns.cache").cache[bufnr] ~= nil
        end

        function this:is_diffthis(cb)
          for _, _winid in pairs(vim.__win.all()) do
            local bufnr = vim.__buf.number(_winid)

            if vim.__buf.name(bufnr):match("^gitsigns:") then
              if cb then cb(bufnr, _winid) end
              return true
            end
          end

          return false
        end
      end,
    }
  },
  highlights = {
    { "GitSignsUntrackedNr", fg = vim.__color.bright_blue },
    { "GitSignsUntracked", fg = vim.__color.bright_blue },
    { "GitSignsChange", fg = vim.__color.bright_yellow },
    { "GitSignsChangeNr", fg = vim.__color.bright_yellow },
  },
  autocmds = {
    {
      "User",
      function(args)
        for _, wininfo in ipairs(args.data.wininfos) do
          if wininfo.variables.gitsigns_preview ~= nil then
            vim.__win.close(wininfo.winid)
          end
        end
      end,
      pattern = "UserPress_CTRLC"
    },
    {
      "User",
      function(args)
        for _, wininfo in ipairs(args.data.wininfos) do
          if wininfo.variables.gitsigns_preview ~= nil then
            return vim.api.nvim_win_call(wininfo.winid, function()
              vim.cmd(string.format("normal! %s", vim.__key.kcode("<C-y>")))
            end)
          end
        end
      end,
      pattern = "UserPress_CTRLY"
    },
    {
      "User",
      function(args)
        for _, wininfo in ipairs(args.data.wininfos) do
          if wininfo.variables.gitsigns_preview ~= nil then
            return vim.api.nvim_win_call(wininfo.winid, function()
              vim.cmd(string.format("normal! %s", vim.__key.kcode("<C-e>")))
            end)
          end
        end
      end,
      pattern = "UserPress_CTRLE"
    }
  },
  keys = {
    { "<leader>hd", function()
      if vim.__win.close_diff() then
        return
      end

      local path = vim.__buf.name(vim.__buf.current())
      vim.__git.if_has_diff_or_untracked(path, function() require("gitsigns").diffthis() end)
    end },
    { "[h"        , function() require("gitsigns").prev_hunk({ wrap = false, navigation_message = true }) end, mode = { "n", "v" } },
    { "]h"        , function() require("gitsigns").next_hunk({ wrap = false, navigation_message = true }) end, mode = { "n", "v" } },
    { "ih"        , function() require("gitsigns").select_hunk() end, mode = { "o", "v" } },
    { "<leader>hr", function() require("gitsigns").reset_hunk() end },
    { "<leader>hR", function()
      local bufnr = vim.__buf.current()
      if not vim.__gitsigns:is_attach(bufnr) then
        return
      end

      vim.ui.input({ prompt = "restore entire file, y/N: ", }, function(ip)
        if string.lower(ip) ~= "y" then
          return
        end
        require("gitsigns").reset_buffer()
      end)
    end },
    {
      "<leader>hb",
      function()
        for _, winid in ipairs(vim.__win.all()) do
          if vim.w[winid].gitsigns_preview == "blame" then
            return vim.__win.close(winid)
          end
        end

        require("gitsigns").blame_line()
      end
    },
    { "<leader>hi", function() require("gitsigns").preview_hunk_inline() end },
    {
      "<leader>hp",
      function()
        for _, winid in ipairs(vim.__win.all()) do
          if vim.w[winid].gitsigns_preview == "hunk" then
            return vim.__win.close(winid)
          end
        end

        require("gitsigns").preview_hunk()
      end
    },
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
      vim.__stl.redraw()

      vim.__autocmd.on("User", function()
        vim.__stl.redraw()
      end, { pattern = "GitSignsUpdate", once = true })
    end
  }
}

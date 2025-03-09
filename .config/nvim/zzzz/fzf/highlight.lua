local M = {}

local etypes = vim.__event.types

local setup = function()
  vim.api.nvim_set_hl(0, "FzfLuaNormal", { link = "Normal" })
  vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "Normal" })
  vim.api.nvim_set_hl(0, "FzfLuaTitle", { bg = vim.__color.bright_aqua, fg = vim.__color.dark0_soft, italic = true })
  vim.api.nvim_set_hl(0, "FzfLuaBackdrop", { link = "Normal" })

  vim.api.nvim_set_hl(0, "FzfLuaPreviewNormal", { link = "Normal" })
  vim.api.nvim_set_hl(0, "FzfLuaPreviewBorder", { link = "Normal" })
  vim.api.nvim_set_hl(0, "FzfLuaPreviewTitle", { bg = vim.__color.bright_yellow, fg = vim.__color.dark0_soft, italic = true })

  vim.api.nvim_set_hl(0, "FzfLuaFzfCursorLine", { bg = vim.__color.dark2 })
  vim.api.nvim_set_hl(0, "FzfLuaFzfBorder", { bg = vim.__color.dark1 })
  vim.api.nvim_set_hl(0, "FzfLuaFzfScrollbar", { bg = vim.__color.dark4 })
  vim.api.nvim_set_hl(0, "FzfLuaFzfPointer", { bg = vim.__color.bright_red })
  vim.api.nvim_set_hl(0, "FzfLuaFzfPrompt", { bg = vim.__color.dark2 })
  vim.api.nvim_set_hl(0, "FzfLuaFzfInfo", { bg = vim.__color.dark2 })
  vim.api.nvim_set_hl(0, "FzfLuaFzfSpinner", { bg = vim.__color.dark2 })
  vim.api.nvim_set_hl(0, "FzfLuaFzfMarker", { bg = vim.__color.bright_red })
  vim.api.nvim_set_hl(0, "FzfLuaFzfHeader", { bg = vim.__color.bright_aqua })
  vim.api.nvim_set_hl(0, "FzfLuaFzfHlPlus", { bg = vim.__color.bright_red })
  vim.api.nvim_set_hl(0, "FzfLuaFzfHl", { bg = vim.__color.bright_red })
  vim.api.nvim_set_hl(0, "FzfLuaFzfBorder", { bg = vim.__color.dark1 })

  -- Set fzf's terminal colorscheme (optional)
  --
  -- Set to `true` to automatically generate an fzf's colorscheme from
  -- Neovim's current colorscheme:
  -- fzf_colors       = true,
  -- 
  -- Building a custom colorscheme, has the below specifications:
  -- If rhs is of type "string" rhs will be passed raw, e.g.:
  --   `["fg"] = "underline"` will be translated to `--color fg:underline`
  -- If rhs is of type "table", the following convention is used:
  --   [1] "what" field to extract from the hlgroup, i.e "fg", "bg", etc.
  --   [2] Neovim highlight group(s), can be either "string" or "table"
  --       when type is "table" the first existing highlight group is used
  --   [3+] any additional fields are passed raw to fzf's command line args
  -- Example of a "fully loaded" color option:
  --   `["fg"] = { "fg", { "NonExistentHl", "Comment" }, "underline", "bold" }`
  -- Assuming `Comment.fg=#010101` the resulting fzf command line will be:
  --   `--color fg:#010101:underline:bold`
  -- NOTE: to pass raw arguments `fzf_opts["--color"]` or `fzf_args`
  vim.__event.rg(etypes.SETUP_FZFLUA, function (cfg)
    cfg.fzf_colors = {
      ["border"]    = { "fg", "FzfLuaFzfBorder" },
      ["scrollbar"] = { "fg", "FzfLuaFzfScrollbar" },
      ["pointer"]   = { "fg", "FzfLuaFzfPointer" },
      ["prompt"]    = { "fg", "FzfLuaFzfPrompt" },
      ["info"]      = { "fg", "FzfLuaFzfInfo" },
      ["spinner"]   = { "fg", "FzfLuaFzfSpinner" },
      ["gutter"]    = "-1",
      ["marker"]    = { "fg", "FzfLuaFzfMarker" },
      ["header"]    = { "fg", "FzfLuaFzfHeader" },
      ["hl+"]       = { "fg", { "FzfLuaFzfHlPlus" }, "bold", "italic", "underline" }, -- Match 
      ["hl"]        = { "fg", { "FzfLuaFzfHl" }, "bold", "italic" },
      ["fg+"]       = { "fg", "Normal" }, -- CursorLine fg
      ["bg+"]       = { "bg", "FzfLuaFzfCursorLine" }, -- CursorLine bg
      ["fg"]        = -1, -- Normal fg,
      ["bg"]        = -1, -- Normal bg
    }
  end)
end

M.setup = setup

return M

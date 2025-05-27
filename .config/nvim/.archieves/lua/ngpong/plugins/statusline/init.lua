return {
  "rebelot/heirline.nvim",
  enabled = false,
  init = function ()
    -- 提示信息相关的设置
    vim.opt.shortmess = nil
    vim.opt.shortmess = vim.opt.shortmess + "S" -- S	do not show search count message when searching, e.g.	"[1/5]"
    vim.opt.shortmess = vim.opt.shortmess + "o" -- o	overwrite message for writing a file with subsequent message for reading a file (useful for ":wn" or when "autowrite" on)
    vim.opt.shortmess = vim.opt.shortmess + "O" -- O	message for reading a file overwrites any previous message; also for quickfix message (e.g., ":cn")
    vim.opt.shortmess = vim.opt.shortmess + "s" -- s	don"t give "search hit BOTTOM, continuing at TOP" or "search hit TOP, continuing at BOTTOM" messages; when using the search count do not show "W" after the count message (see S below)
    vim.opt.shortmess = vim.opt.shortmess + "c" -- c	don"t give ins-completion-menu messages; for example, "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found", "Back at original", etc.
    vim.opt.shortmess = vim.opt.shortmess + "F" -- F	don"t give the file info when editing a file, like :silent was used for the command

    -- 不显示当前的输入模式(左下角)
    vim.go.showmode = false

    -- 控制状态行显示位置；2：全部，3：当前
    vim.go.laststatus = 3

    -- 不显示当前输入的命令(右下角)
    -- 暂时禁用它，不然在移动(从下往上一直按p移动)的时候会有一些鼠标乱飘的bug
    vim.go.showcmd = true

    -- 控制命令行的高度(最后一行)
    vim.go.cmdheight = 1
  end,
  opts = function()
    local components = require("ngpong.plugins.statusline.components")

    vim.api.nvim_set_hl(0, "StatusLine", { bg = vim.__color.dark1 })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = vim.__color.dark1 })
    vim.api.nvim_set_hl(0, "StatusLineTermNC", { bg = vim.__color.dark1 })

    return {
      opts = {
        colors = {
          bright_bg = vim.__color.dark1,
          bright_fg = vim.__color.light1,
          red = vim.__color.bright_red,
          green = vim.__color.bright_green,
          blue = vim.__color.bright_blue,
          gray = vim.__color.gray,
          orange = vim.__color.bright_orange,
          purple = vim.__color.bright_purple,
          cyan = vim.__color.bright_aqua,
          diag_warn = require("heirline.utils").get_highlight("DiagnosticWarn").fg,
          diag_error = require("heirline.utils").get_highlight("DiagnosticError").fg,
          diag_hint = require("heirline.utils").get_highlight("DiagnosticHint").fg,
          diag_info = require("heirline.utils").get_highlight("DiagnosticInfo").fg,
          git_del = require("heirline.utils").get_highlight("GitSignsDelete").fg,
          git_add = require("heirline.utils").get_highlight("GitSignsAdd").fg,
          git_change = require("heirline.utils").get_highlight("GitSignsChange").fg,
        },
      },
      statusline = {
        components.mode,
        components.git_branch,
        components.lsp,
        components.git_diff,
        components.diagnostics,
        components.fill,
        components.search,
        components.os,
        components.encoding,
        components.filetype,
        components.location,
      },
    }
  end,
}
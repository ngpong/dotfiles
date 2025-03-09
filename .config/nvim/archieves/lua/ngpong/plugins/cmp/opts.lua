local M = {}

M.setup = function()
  -- 完成菜单相关的设置
  -- menu      Use a popup menu to show the possible completions. The menu is only shown when there is more than one match and sufficient colors are available.  ins-completion-menu
  -- menuone   Use the popup menu also when there is only one match. Useful when there is additional information about the match, e.g., what file it comes from.
  -- longest   Only insert the longest common text of the matches. If the menu is displayed you can use CTRL-L to add more characters. Whether case is ignored depends on the kind of completion.  For buffer text the "ignorecase" option is used.
  -- preview   Show extra information about the currently selected completion in the preview window.  Only works in combination with "menu" or "menuone".
  -- noinsert  Do not insert any text for a match until the user selects a match from the menu. Only works in combination with "menu" or "menuone". No effect if "longest" is present.
  -- noselect  Do not select a match in the menu, force the user to select one from the menu. Only works in combination with "menu" or "menuone".
  vim.opt.completeopt = "" -- 部分插件的集成与 nvim-cmp 并不好，比如 dressing.nvim。这些插件还是使用的 omifunc 来完成补全
  -- vim.opt.completeopt = vim.opt.completeopt + "menu"
  -- vim.opt.completeopt = vim.opt.completeopt + "menuone"
  -- vim.opt.completeopt = vim.opt.completeopt + "noinsert"
  -- vim.opt.completeopt = vim.opt.completeopt + "preview"
  -- vim.opt.completeopt = vim.opt.completeopt + "noselect"

  -- 代码补全体验增强
  -- REF: https://neovim.io/doc/user/options.html#"wildmenu"
  vim.go.wildmenu = false

  -- 设置补全窗口的最大高度为 10 项
  vim.go.pumheight = 10
end

return M

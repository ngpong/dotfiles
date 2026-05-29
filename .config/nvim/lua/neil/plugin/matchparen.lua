return {
  "monkoose/matchparen.nvim",
  main = "matchparen",
  lazy = true,
  event = "VeryLazy",
  -- init = function()
  --   vim.opt.matchpairs = vim.opt.matchpairs + "<:>"
  -- end,
  opts = {
    enabled = true,
    hl_group = 'MatchParen',
    debounce_time = 60,
    skip_folds = true,
  }
}

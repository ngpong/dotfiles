return {
  "NGPONG/matchparen.nvim",
  lazy = true,
  event = "VeryLazy",
  -- init = function()
  --   vim.opt.matchpairs = vim.opt.matchpairs + "<:>"
  -- end,
  opts = {
    on_startup = true,
    hl_group = "MatchParen",
    augroup_name = "matchparen",
    debounce_time = 100,
  }
}
return {
  "numToStr/Comment.nvim",
  lazy = true,
  keys = {
    { "fc", "<Plug>(comment_toggle_linewise)" },
    { "fc", "<Plug>(comment_toggle_linewise_visual)", mode = vim.__key.e_mode.VS },
    { "fb", "<Plug>(comment_toggle_blockwise)" },
    { "fb", "<Plug>(comment_toggle_blockwise_visual)", mode = vim.__key.e_mode.VS },
    { "fcc", function() return vim.api.nvim_get_vvar('count') == 0 and '<Plug>(comment_toggle_linewise_current)' or '<Plug>(comment_toggle_linewise_count)' end, expr = true },
    { "fbb", function() return vim.api.nvim_get_vvar('count') == 0 and '<Plug>(comment_toggle_blockwise_current)' or '<Plug>(comment_toggle_blockwise_count)' end, expr = true },
  },
  opts = {
    toggler = {
      line = 'fcc',
      block = 'fbb',
    },
    extra = {
      above = 'fcO',
      below = 'fco',
      eol = 'fcA',
    },
    opleader = {
      line = 'fc',
      block = 'fb',
    },
    mappings = {
      basic = true,
      extra = true,
    },
  },
}
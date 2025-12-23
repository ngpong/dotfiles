return {
  clear = function()
    vim.cmd("clearjumps")
  end,
  add = function()
    vim.cmd[[normal! m']]
  end
}

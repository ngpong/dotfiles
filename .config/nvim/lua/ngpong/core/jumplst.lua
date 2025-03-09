return {
  clear = function()
    vim.cmd("clearjumps")
  end,
  add = function()
    vim.__key.press("m\"")
  end
}
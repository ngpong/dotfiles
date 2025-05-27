-- preserved position after yank
vim.__autocmd.on("VimEnter", function()
  local ylnum, ycol
  vim.__autocmd.on("ModeChanged", function()
    if vim.v.operator == "y" then
      ylnum, ycol = vim.__cursor.get()
    end
  end, { pattern = "n:no" })
  vim.__autocmd.on("TextYankPost", function()
    if vim.__helper.get_mode() ~= "no" or vim.v.event.operator ~= "y" then
      return
    end

    if not vim.b.visual_multi then
      vim.highlight.on_yank{ higroup = "Visual", timeout = 75 }
    end

    if ylnum and ycol then
      vim.__cursor.set(ylnum, ycol)
    end
  end)
end)

-- clear jump list && search pattern
vim.__autocmd.on("VimEnter", function()
  vim.__jumplst.clear()
  vim.__helper.clear_searchpattern()
end)


local M = {}

local tmp_guicursor = ""

function M.ishide()
  if vim.o.guicursor == "a:NGPONGHiddenCursor" then
    return true
  else
    return false
  end
end

local isset_hidden_hl = false
function M.hide()
  if not isset_hidden_hl then
    vim.api.nvim_set_hl(0, "NGPONGHiddenCursor", { reverse = true, blend = 100 })
    isset_hidden_hl = true
  end

  if not M.ishide() then
    if vim.o.termguicolors and vim.o.guicursor ~= "" then
      tmp_guicursor = vim.o.guicursor
      vim.o.guicursor = "a:NGPONGHiddenCursor"
    end
  end
end

function M.unhide()
  if M.ishide() then
    vim.o.guicursor = tmp_guicursor
  end
end

function M.get(winid)
  return vim.__tbl.unpack(vim.api.nvim_win_get_cursor(winid or 0))
end

function M.norm_get(winid)
  return vim.api.nvim_win_get_cursor(winid or 0)
end

function M.set(row, col, winid)
  pcall(vim.api.nvim_win_set_cursor, winid or 0, { row, col })
end

return M
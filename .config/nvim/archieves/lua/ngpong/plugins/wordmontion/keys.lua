local M = {}

local kmodes = vim.__key.e_mode

M.setup = function()
  local montion = vim.__lazy.access("spider", "motion")

  local montion_e = vim.__util.wrap_f(montion, "e")
  local montion_b = vim.__util.wrap_f(montion, "b")

  vim.__key.rg({ kmodes.N, kmodes.VS }, "w", function()
    montion_e()
  end, { desc = "MONTION: cursor world forward." })
  vim.__key.rg({ kmodes.N, kmodes.VS }, "q", function()
    montion_b()
  end, { desc = "MONTION: cursor world backward." })
  vim.__key.rg(kmodes.I, "<A-w>", function()
    montion_e()
  end, { desc = "which_key_ignore" })
  vim.__key.rg(kmodes.I, "<A-q>", function()
    montion_b()
  end, { desc = "which_key_ignore" })
end

return M

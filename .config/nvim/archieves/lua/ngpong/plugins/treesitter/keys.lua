local M = {}

local kmodes = vim.__key.e_mode

local set_native_keymaps = function()
  -- vim.__key.rg({ kmodes.N, kmodes.VS }, "e2]", function()
  --   require("nvim-treesitter.textobjects.move").goto_next("@function.outer", "textobjects")
  -- end, { desc = "next @function.outer" })

  -- vim.__key.rg({ kmodes.N, kmodes.VS }, "e2[", function()
  --   require("nvim-treesitter.textobjects.move").goto_previous("@function.outer", "textobjects")
  -- end, { desc = "next @function.outer" })

  -- vim.__key.rg({ kmodes.N, kmodes.VS }, "e3]", function()
  --   require("nvim-treesitter.textobjects.move").goto_next("@class.outer", "textobjects")
  -- end, { desc = "prev @class.outer" })

  -- vim.__key.rg({ kmodes.N, kmodes.VS }, "e3[", function()
  --   require("nvim-treesitter.textobjects.move").goto_previous("@class.outer", "textobjects")
  -- end, { desc = "prev @class.outer" })

  -- vim.__key.rg({ kmodes.N, kmodes.VS }, "e4[", function()
  --   require("nvim-treesitter.textobjects.move").goto_previous("@loop.outer", "textobjects")
  -- end, { desc = "prev @loop" })

  -- vim.__key.rg({ kmodes.N, kmodes.VS }, "e4]", function()
  --   require("nvim-treesitter.textobjects.move").goto_next("@loop.outer", "textobjects")
  -- end, { desc = "prev @loop" })

  -- vim.__key.rg({ kmodes.N, kmodes.VS }, "e5[", function()
  --   require("nvim-treesitter.textobjects.move").goto_previous("@conditional.outer", "textobjects")
  -- end, { desc = "prev @conditional" })

  -- vim.__key.rg({ kmodes.N, kmodes.VS }, "e5]", function()
  --   require("nvim-treesitter.textobjects.move").goto_next("@conditional.outer", "textobjects")
  -- end, { desc = "prev @conditional" })
end

M.setup = function()
  set_native_keymaps()
end

return M

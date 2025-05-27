local M = {}

local WK = vim.__lazy.require("which-key")

local kmodes = vim.__key.e_mode
local etypes = vim.__event.types

local fix_keymap_native = vim.__async.void(function()
  vim.__async.scheduler()
  WK.register({
    ["h"] = { "MONTION: left." },
    ["j"] = { "MONTION: down." },
    ["k"] = { "MONTION: top." },
    ["l"] = { "MONTION: right." },
    ["v"] = { "COMMON: enter visual mode." },
    ["V"] = { "COMMON: enter line-visual mode." },
    [":"] = { "COMMON: enter command mode." },

    ["f"] = {
      name = "FIND:"
    },

    ["e"] = {
      name = "JUMPTO:",
      ["1"] = { name = "INDENT" },
      ["2"] = { name = "FUNCTION" },
      ["3"] = { name = "CLASS" },
      ["4"] = { name = "LOOP" },
      ["5"] = { name = "CONDITIONAL" },
    },

    ["d"] = {
      name = "CODEING:",
    },

    ["r"] = {
      name = "WINDOW:",
      ["s"] = {
        name = "SPLIT RESIZE SETTING:",
      },
    },

    ["t"] = {
      name = "TABPAGE:",
    },

    ["n"] = {
      name = "TODO:"
    },

    ["m"] = {
      name = "MARKS",
      ["e"] = {
        name = "JUMPTO",
      },
      ["d"] = {
        name = "DEL",
      },
      ["s"] = {
        name = "SET",
      }
    },

    ["b"] = {
      name = "BUFFER:",
    },

    ["g"] = {
      name = "GIT:",
    },

    ["<LEADER>"] = {
      name = "PREFIX:",
      ["t"] = {
        name = "TROUBLE LIST:",
      },
    },
  })

  vim.__async.scheduler()
  WK.register({
    ["e"] = {
      name = "JUMPTO:",
      ["1"] = { name = "INDENT" },
      ["2"] = { name = "FUNCTION" },
      ["3"] = { name = "CLASS" },
      ["4"] = { name = "LOOP" },
      ["5"] = { name = "CONDITIONAL" },
    },
  }, { mode = "v", })
end)

local fix_keymap_gitsigns = vim.__async.void(function(bufnr)
  vim.__async.scheduler()
  WK.register({
    ["g"] = {
      name = "GIT:",
      ["h"] = {
        name = "HUNK:",
      },
    },
  }, { buffer = bufnr })
end)

local set_native_keymaps = function()
  vim.__key.rg(kmodes.N, "<leader>k", "<CMD>WhichKey<CR>", { silent = true, desc = "open keymap config." })
end

local setup = function()
  set_native_keymaps()

  vim.__event.rg(etypes.SETUP_WHICHKEY, function()
    fix_keymap_native()
  end)

  vim.__event.rg(etypes.ATTACH_GITSIGNS, function(state)
    fix_keymap_gitsigns(state.bufnr)
  end)
end

M.setup = setup

return M

local M = {}

local mc            = vim.__lazy.require("multicursors")
local mc_n          = vim.__lazy.require("multicursors.normal_mode")
local mc_i          = vim.__lazy.require("multicursors.insert_mode")
local mc_e          = vim.__lazy.require("multicursors.extend_mode")
local mc_utils      = vim.__lazy.require("multicursors.utils")
local mc_selections = vim.__lazy.require("multicursors.selections")

local kmodes = vim.__key.e_mode
local etypes = vim.__event.types

local set_native_keymaps = function()
  vim.__key.rg({ kmodes.N, kmodes.VS }, "<leader>c", function()
    mc.start()
  end, { desc = "enter multi cursor mode." })
end

local set_mode_keymaps = function(cfg)
  cfg.mode_keys = {
    append = { "a", desc = "MULTICURSORS: enter(head) inster mode." },
    change = { "c", desc = "MULTICURSORS: cut character and enter insert mode." },
    extend = { "Þ", desc = "which_key_ignore" },
    insert = { "A", desc = "MULTICURSORS: enter(tail) inster mode." },
  }
end

local set_normal_keymaps = function(cfg)
  cfg.normal_keys = {
    ["<C-]>"] = {
      method = function()
        vim.__jumplst.add()
        mc_n.find_next()
        vim.__jumplst.add()
      end,
      opts = { desc = "MULTICURSORS: find next match." }
    },
    ["<C-[>"] = {
      method = function()
        vim.__jumplst.add()
        mc_n.find_prev()
        vim.__jumplst.add()
      end,
      opts = { desc = "MULTICURSORS: find previous match." }
    },
    ["{"] = {
      method = function()
        mc_n.skip_find_prev()
      end,
      opts = { desc = "MULTICURSORS: skip current and find previous match."  }
    },
    ["}"] = {
      method = function()
        mc_n.skip_find_next()
      end,
      opts = { desc = "MULTICURSORS: skip current and find next match."  }
    },
    ["x"] = {
      method = function()
        mc_n.delete(cfg)
      end,
      opts = { desc = "MULTICURSORS: delete character."  }
    },
    ["<leader>u"] = {
      method = function()
        mc_n.lower_case()
      end,
      opts = { desc = "MULTICURSORS: convert selected text to lowercase."  }
    },
    ["<leader>U"] = {
      method = function()
        mc_n.upper_case()
      end,
      opts = { desc = "MULTICURSORS: convert selected text to uppercase."  }
    },
    ["y"] = {
      method = function()
        mc_n.yank()
      end,
      opts = { desc = "MULTICURSORS: copy text."  }
    },
    ["u"] = {
      method = function()
        mc_n.replace()
      end,
      opts = { desc = "MULTICURSORS: paste text."  }
    },
    ["<S-k>"] = {
      method = mc_e.h_method,
      opts = { desc = "MULTICURSORS: select left."  }
    },
    [":"] = {
      method = mc_e.l_method,
      opts = { desc = "MULTICURSORS: select right."  }
    },
    ["_"] = {
      method = mc_e.caret_method,
      opts = { desc = "MULTICURSORS: select to head of line."  }
    },
    ["+"] = {
      method = mc_e.dollar_method,
      opts = { desc = "MULTICURSORS: select to end of line."  }
    },
    ["<S-w>"] = {
      method = mc_e.w_method,
      opts = { desc = "MULTICURSORS: select world forward."  }
    },
    ["<S-q>"] = {
      method = mc_e.b_method,
      opts = { desc = "MULTICURSORS: select world backward."  }
    },

    [","] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["b"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["b."] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["b,"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["b<"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["b>"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["B"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["B<"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["B>"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["bp"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["bs"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["BC"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["bo"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["bc"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["f"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["fb"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["f<leader>"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["ff"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["fl"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["fs"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["d"] = { method = function() end, opts = { desc = "which_key_ignore" } },
    ["dr"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["de"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["dE"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["d."] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["d,"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["dn"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["da"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["dm"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["dc"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["dp"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["dw"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["di"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["dk"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["dh"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["ds"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["dd"] = { method = function() end, opts = { desc = "which_key_ignore" } },
    ["dD"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["t"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["to"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["tc"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["ts"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["t."] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["t,"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["r"] = { method = function() end, opts = { desc = "which_key_ignore" } },
    ["rc"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["r:"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["r;"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["rl"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["r\""] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["rp"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["rh"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["rv"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["r="] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["r-"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["rs"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["rsh"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["rsv"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["g"] = { method = function() end, opts = { desc = "which_key_ignore" } },
    ["g,"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["g."] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["gp"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["gr"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["gb"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["ga"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["gd"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["gg"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["gu"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["gh"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["ghr"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["ghs"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["gha"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["m"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["m,"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["m."] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["md"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["ms"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["me"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["mm"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["n"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["n,"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["n."] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["nn"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["\\"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["/"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["?"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["U"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["X"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["z"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["Z"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["<leader>c"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["<leader>e"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["<leader>p"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["<leader>l"] = { method = nil, opts = { desc = "which_key_ignore" } },
    ["<leader>q"] = { method = nil, opts = { desc = "which_key_ignore" } },
  }
end

local set_insert_keymaps = function(cfg)
  cfg.insert_keys = {
    ["<A-->"] = {
      method = mc_i.Home_method,
      opts = { desc = "which_key_ignore"  }
    },
    ["<A-=>"] = {
      method = mc_i.End_method,
      opts = { desc = "which_key_ignore"  }
    },
    ["<A-k>"] = {
      method = mc_i.Left_method,
      opts = { desc = "which_key_ignore"  }
    },
    ["<A-;>"] = {
      method = mc_i.Right_method,
      opts = { desc = "which_key_ignore"  }
    },
    ["<A-o>"] = {
      method = mc_i.UP_method,
      opts = { desc = "which_key_ignore"  }
    },
    ["<A-l>"] = {
      method = mc_i.Down_method,
      opts = { desc = "which_key_ignore"  }
    },
    ["<A-w>"] = {
      method = function()
        -- how to integrated spider.nvim?
        mc_selections.move_by_motion("e")
      end,
      opts = { desc = "which_key_ignore"  }
    },
    ["<A-q>"] = {
      method = function()
        -- how to integrated spider.nvim?
        mc_selections.move_by_motion("b")
      end,
      opts = { desc = "which_key_ignore"  }
    },
    ["<BS>"] = { method = mc_i.BS_method, opts = { desc = "which_key_ignore"  } },
    ["<CR>"] = { method = mc_i.CR_method, opts = { desc = "which_key_ignore"  } },
    ["<Del>"] = { method = mc_i.Del_method, opts = { desc = "which_key_ignore"  } },
  }
end

local set_extend_keymaps = function(cfg)
  cfg.extend_keys = {}
end

M.setup = function()
  set_native_keymaps()

  vim.__event.rg(etypes.SETUP_MULTICURSORS, function(cfg)
    set_mode_keymaps(cfg)
    set_normal_keymaps(cfg)
    set_insert_keymaps(cfg)
    set_extend_keymaps(cfg)
  end)
end

return M

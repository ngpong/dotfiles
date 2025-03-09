local M = {}

local NvimTreeAPI   = vim.__lazy.require("nvim-tree.api")
local NvimTreeLib   = vim.__lazy.require("nvim-tree.lib")
local NvimTreeUtils = vim.__lazy.require("nvim-tree.utils")
local NvimTreeView  = vim.__lazy.require("nvim-tree.view")
local NvimTreeCore  = vim.__lazy.require("nvim-tree.core")

local kmodes = vim.__key.e_mode
local etypes = vim.__event.types

local function set_native_keymaps()
  vim.__key.rg(kmodes.N, "<leader>e", function ()
    NvimTreeAPI.tree.toggle({})
  end, { silent = true, desc = "open file explore." })
end

local function del_buffer_keymaps(bufnr)
  -- vim.__key.hide(kmodes.N, "a", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "A", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "y", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "c", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "X", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "x", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "U", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "u", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "Z", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "z", { buffer = bufnr })

  -- vim.__key.hide(kmodes.N, "b", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "b[", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "b]", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "b,", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "b.", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "bs", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "bt", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "bo", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "bc", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "bb", { buffer = bufnr })

  -- vim.__key.hide(kmodes.N, "d", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "dr", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "de", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "d[", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "d]", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "dn", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "dc", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "dp", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "dw", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "di", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "dk", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "dd", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "dD", { buffer = bufnr })

  -- vim.__key.hide(kmodes.N, "f", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "fb", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "fw", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "ff", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "fg", { buffer = bufnr })
  -- vim.__key.hide({ kmodes.N, kmodes.VS }, "fs", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "fd", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "fm", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "fn", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "f<leader>", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "fF", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "fS", { buffer = bufnr })

  -- vim.__key.hide(kmodes.N, "g", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "g[", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "g]", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "gp", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "gr", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "gb", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "gd", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "gn", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "gh", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "ghr", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "ghs", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "gg", { buffer = bufnr })

  -- vim.__key.hide(kmodes.N, "e[", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "e]", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "e1", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "e1[", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "e1]", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "e2", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "e2[", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "e2]", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "e3", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "e3[", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "e3]", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "e4", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "e4[", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "e4]", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "e5", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "e5[", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "e5]", { buffer = bufnr })

  -- vim.__key.hide(kmodes.N, "m", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "m[", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "m]", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "md", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "ms", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "me", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "mm", { buffer = bufnr })

  -- vim.__key.hide(kmodes.N, "<leader>u", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "<leader>U", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "<leader>c", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "<leader>h", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "<leader>f", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "<leader>?", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "<leader>/", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "<leader>l", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "<leader>q", { buffer = bufnr })

  -- vim.__key.hide(kmodes.N, "tc", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "to", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "ts", { buffer = bufnr })

  -- vim.__key.hide(kmodes.N, "n", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "n[", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "n]", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "nn", { buffer = bufnr })

  -- vim.__key.hide(kmodes.N, "rc", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "rh", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "rv", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "rs", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "rsh", { buffer = bufnr })
  -- vim.__key.hide(kmodes.N, "rsv", { buffer = bufnr })
end

local function set_buffer_keymaps(bufnr)
  vim.__key.rg(kmodes.N, "<CR>", function()
    NvimTreeAPI.node.open.edit()
  end, { desc = "NVIMTREE: open selected node.", buffer = bufnr })

  vim.__key.rg(kmodes.N, "<S-CR>", function()
    require("nvim-tree.actions.node.open-file").quit_on_open = true
    NvimTreeAPI.node.open.edit()
    require("nvim-tree.actions.node.open-file").quit_on_open = false
  end, { desc = "NVIMTREE: open selected node and close tree.", buffer = bufnr })

  vim.__key.rg(kmodes.N, "<C-p>", function()
    require("nvim-tree-preview").watch()
  end, { desc = "NVIMTREE: preview selected node.", buffer = bufnr })

  vim.__key.rg(kmodes.N, "z", function()
    local node = NvimTreeLib.get_node_at_cursor()

    if node.nodes then
      NvimTreeLib.expand_or_collapse(node)
    else
      local parent = node.parent
      if not parent.parent then
        return
      end

      NvimTreeLib.expand_or_collapse(parent)

      local _, i = NvimTreeUtils.find_node(NvimTreeCore.get_explorer().nodes, function(node)
        return node.absolute_path == parent.absolute_path
      end)

      NvimTreeView.set_cursor { i + 1, 1 }
    end
  end, { desc = "NVIMTREE: toggle selected node.", buffer = bufnr })

  vim.__key.rg(kmodes.N, "<C-z>", function()
    NvimTreeAPI.tree.collapse_all(false)
  end, { desc = "NVIMTREE: close all nodes.", buffer = bufnr })

  vim.__key.rg(kmodes.N, "Z", function()
    NvimTreeAPI.tree.expand_all(false)
  end, { desc = "NVIMTREE: expand all nodes.", buffer = bufnr })
end

local function on_attach(bufnr)
  del_buffer_keymaps(bufnr)
  set_buffer_keymaps(bufnr)
end

function M.setup()
  set_native_keymaps()

  vim.__event.rg(etypes.SETUP_NVIMTREE, function(cfg)
    cfg.on_attach = on_attach
  end)
end

return M

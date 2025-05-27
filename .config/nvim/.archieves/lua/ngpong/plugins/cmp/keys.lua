local M = {}

local Cmp    = vim.__lazy.require("cmp")
local CmpCfg = vim.__lazy.require("cmp.config")

local c_api = vim._plugins.cmp.api
local l_api = vim._plugins.luasnip.api

local kmodes = vim.__key.e_mode
local etypes = vim.__event.types

local set_global_keymaps = function(...)
  return {
    ["<TAB>"] = Cmp.mapping(function(fallback)
      if c_api.is_visible() then
        l_api.unlink_current_if_expandable()
        Cmp.confirm({ select = false, behavior = Cmp.ConfirmBehavior.insert })
      else
        fallback()
      end
    end, { kmodes.I, kmodes.S }),
    ["<C-p>"] = Cmp.mapping(function(fallback)
      if c_api.is_visible() then
        if c_api.is_docvisible() then
          CmpCfg.get().view.docs.auto_open = false
          Cmp.close_docs()
        else
          CmpCfg.get().view.docs.auto_open = true
          Cmp.open_docs()
        end
      else
        fallback()
      end
    end, { kmodes.I }),
    ["<C-[>"] = Cmp.mapping(function(fallback)
      if l_api.locally_jumpable(-1) then
        l_api.jump(-1)
      else
        fallback()
      end
    end, { kmodes.I, kmodes.S }),
    ["<C-]>"] = Cmp.mapping(function(fallback)
      if l_api.locally_jumpable(1) then
        l_api.jump(1)
      else
        fallback()
      end
    end, { kmodes.I, kmodes.S }),
    ["<A-]>"] = Cmp.mapping(function(fallback)
      if c_api.is_visible() then
        if #Cmp.get_entries() > 1 then
          Cmp.select_next_item({ behavior = Cmp.SelectBehavior.Select })
        else
          Cmp.close()
        end
      else
        fallback()
      end
    end, { kmodes.I }),
    ["<A-[>"] = Cmp.mapping(function(fallback)
      if c_api.is_visible() then
        if #Cmp.get_entries() > 1 then
          Cmp.select_prev_item({ behavior = Cmp.SelectBehavior.Select })
        else
          Cmp.close()
        end
      else
        fallback()
      end
    end, { kmodes.I }),
    ["<C-x>"] = Cmp.mapping(function()
      if c_api.is_visible() then
        Cmp.close()
      end
    end, { kmodes.I }),
  }
end

local set_cmdline_keymaps = function(...)
  return {
    ["<TAB>"] = Cmp.mapping(function(fallback)
      if c_api.is_visible() then
        Cmp.confirm({ select = false, behavior = Cmp.ConfirmBehavior.insert })
      else
        fallback()
      end
    end, { kmodes.S }),
    ["<A-[>"] = Cmp.mapping(function(_)
      if c_api.is_visible() then
        if #Cmp.get_entries() > 1 then
          Cmp.select_prev_item({ behavior = Cmp.SelectBehavior.Select })
        else
          Cmp.close()
        end
      end
    end, { kmodes.S }),
    ["<A-]>"] = Cmp.mapping(function(_)
      if c_api.is_visible() then
        if #Cmp.get_entries() > 1 then
          Cmp.select_next_item({ behavior = Cmp.SelectBehavior.Select })
        else
          Cmp.close()
        end
      end
    end, { kmodes.S }),
    ["<C-x>"] = Cmp.mapping(function()
      if c_api.is_visible() then
        Cmp.close()
      end
    end, { kmodes.S }),
  }
end

M.setup = function()
  vim.__event.rg(etypes.SETUP_CMP, function(state)
    if state.source == "global" then
      state.cfg.mapping = set_global_keymaps()
    elseif state.source == "cmdline" then
      state.cfg.mapping = set_cmdline_keymaps()
    end
  end)
end

return M

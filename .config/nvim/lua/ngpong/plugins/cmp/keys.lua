local M = {}

-- stylua: ignore start
local Events = require('ngpong.common.events')
local Keymap = require('ngpong.common.keybinder')
local Lazy   = require('ngpong.utils.lazy')
local Cmp    = Lazy.require('cmp')
local CmpCfg = Lazy.require('cmp.config')

local e_mode = Keymap.e_mode
local e_name = Events.e_name

local this = Plgs.cmp
local ls   = Plgs.luasnip
-- stylua: ignore end

local set_global_keymaps = function(...)
  return {
    ['<TAB>'] = Cmp.mapping(function(fallback)
      if this.api.is_visible() then
        ls.api.unlink_current_if_expandable()
        Cmp.confirm({ select = false, behavior = Cmp.ConfirmBehavior.insert })
      else
        fallback()
      end
    end, { e_mode.INSERT, e_mode.SELECT }),
    ['<C-p>'] = Cmp.mapping(function(fallback)
      if this.api.is_visible() then
        if this.api.is_docvisible() then
          CmpCfg.get().view.docs.auto_open = false
          Cmp.close_docs()
        else
          CmpCfg.get().view.docs.auto_open = true
          Cmp.open_docs()
        end
      else
        fallback()
      end
    end, { e_mode.INSERT }),
    ['<C-[>'] = Cmp.mapping(function(fallback)
      if ls.api.locally_jumpable(-1) then
        ls.api.jump(-1)
      else
        fallback()
      end
    end, { e_mode.INSERT, e_mode.SELECT }),
    ['<C-]>'] = Cmp.mapping(function(fallback)
      if ls.api.locally_jumpable(1) then
        ls.api.jump(1)
      else
        fallback()
      end
    end, { e_mode.INSERT, e_mode.SELECT }),
    ['<A-]>'] = Cmp.mapping(function(fallback)
      if this.api.is_visible() then
        if #Cmp.get_entries() > 1 then
          Cmp.select_next_item({ behavior = Cmp.SelectBehavior.Select })
        else
          Cmp.close()
        end
      else
        fallback()
      end
    end, { e_mode.INSERT }),
    ['<A-[>'] = Cmp.mapping(function(fallback)
      if this.api.is_visible() then
        if #Cmp.get_entries() > 1 then
          Cmp.select_prev_item({ behavior = Cmp.SelectBehavior.Select })
        else
          Cmp.close()
        end
      else
        fallback()
      end
    end, { e_mode.INSERT }),
  }
end

local set_cmdline_keymaps = function(...)
  return {
    ['<TAB>'] = Cmp.mapping(function(fallback)
      if this.api.is_visible() then
        Cmp.confirm({ select = false, behavior = Cmp.ConfirmBehavior.insert })
      else
        fallback()
      end
    end, { e_mode.COMMAND }),
    ['<A-[>'] = Cmp.mapping(function(_)
      if this.api.is_visible() then
        if #Cmp.get_entries() > 1 then
          Cmp.select_prev_item({ behavior = Cmp.SelectBehavior.Select })
        else
          Cmp.close()
        end
      end
    end, { e_mode.COMMAND }),
    ['<A-]>'] = Cmp.mapping(function(_)
      if this.api.is_visible() then
        if #Cmp.get_entries() > 1 then
          Cmp.select_next_item({ behavior = Cmp.SelectBehavior.Select })
        else
          Cmp.close()
        end
      end
    end, { e_mode.COMMAND }),
  }
end

M.setup = function()
  Events.rg(e_name.SETUP_CMP, function(state)
    if state.source == 'global' then
      Tools.tbl_r_extend(state.cfg, {
        mapping = set_global_keymaps(),
      })
    elseif state.source == 'cmdline' then
      Tools.tbl_r_extend(state.cfg, {
        mapping = set_cmdline_keymaps(),
      })
    end
  end)
end

return M

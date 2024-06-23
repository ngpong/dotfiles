local M = {}

local Events = require('ngpong.common.events')
local Keymap = require('ngpong.common.keybinder')
local Lazy = require('ngpong.utils.lazy')
local Cmp = Lazy.require('cmp')
local CmpCfg = Lazy.require('cmp.config')

local e_mode = Keymap.e_mode
local e_name = Events.e_name

local this = Plgs.cmp
local ls = Plgs.luasnip

local set_global_keymaps = function(...)
  return {
    ['<TAB>'] = Cmp.mapping(function(fallback)
      if Cmp.visible() and Cmp.get_selected_entry() then
        ls.api.unlink_current_if_expandable()
        Cmp.confirm({ select = false, behavior = Cmp.ConfirmBehavior.insert })
      else
        fallback()
      end
    end, { e_mode.INSERT, e_mode.SELECT }),
    -- ['<ESC>'] = Cmp.mapping(function(fallback)
    --   fallback()
    -- end, { e_mode.INSERT, e_mode.SELECT }),
    ['<C-p>'] = Cmp.mapping(function(fallback)
      if Cmp.visible() then
        if Cmp.visible_docs() then
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
    ['<C-]>'] = Cmp.mapping({
      [e_mode.INSERT] = function(fallback)
        if Cmp.visible() then
          if #Cmp.get_entries() > 1 then
            Cmp.select_next_item({ behavior = Cmp.SelectBehavior.Select })
          else
            Cmp.close()
          end
        elseif ls.api.locally_jumpable(1) then
          ls.api.jump(1)
        else
          fallback()
        end
      end,
      [e_mode.SELECT] = function(fallback)
        if ls.api.locally_jumpable(1) then
          ls.api.jump(1)
        else
          fallback()
        end
      end,
    }),
    ['<C-[>'] = Cmp.mapping({
      [e_mode.INSERT] = function(fallback)
        if Cmp.visible() then
          if #Cmp.get_entries() > 1 then
            Cmp.select_prev_item({ behavior = Cmp.SelectBehavior.Select })
          else
            Cmp.close()
          end
        elseif ls.api.locally_jumpable(-1) then
          ls.api.jump(-1)
        else
          fallback()
        end
      end,
      [e_mode.SELECT] = function(fallback)
        if ls.api.locally_jumpable(-1) then
          ls.api.jump(-1)
        else
          fallback()
        end
      end,
    }),
  }
end

local set_cmdline_keymaps = function(...)
  return {
    ['<TAB>'] = Cmp.mapping(function(fallback)
      if Cmp.visible() and Cmp.get_selected_entry() then
        Cmp.confirm({ select = false, behavior = Cmp.ConfirmBehavior.insert })
      elseif not Cmp.visible() and this.api.has_words_before() then
        Cmp.complete()
      else
        fallback()
      end
    end, { e_mode.COMMAND }),
    -- ['<ESC>'] = Cmp.mapping(function(fallback)
    --   Helper.feedkeys('<ESC>')
    -- end, { e_mode.COMMAND }),
    ['<C-[>'] = Cmp.mapping(function(fallback)
      if Cmp.visible() then
        if #Cmp.get_entries() > 1 then
          Cmp.select_prev_item({ behavior = Cmp.SelectBehavior.Select })
        else
          Cmp.close()
        end
      end
    end, { e_mode.COMMAND }),
    ['<C-]>'] = Cmp.mapping(function(fallback)
      if Cmp.visible() then
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

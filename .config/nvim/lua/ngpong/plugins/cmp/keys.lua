local M = {}

local keymap  = require('ngpong.common.keybinder')
local events  = require('ngpong.common.events')
local lazy    = require('ngpong.utils.lazy')
local cmp     = lazy.require('cmp')
local cmp_cfg = lazy.require('cmp.config')

local this     = PLGS.cmp
local ls       = PLGS.luasnip
local e_mode   = keymap.e_mode
local e_events = events.e_name

local set_global_keymaps = function(...)
  return {
    -- ['<CR>'] = cmp.mapping(function(fallback)
    --   if cmp.visible() and cmp.get_selected_entry() then
    --     ls.api.unlink_current_if_expandable()
    --     cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.insert })
    --   else
    --     fallback()
    --   end
    -- end, { e_mode.INSERT }),
    ['<C-s>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if cmp.visible_docs() then
          cmp_cfg.get().view.docs.auto_open = false
          cmp.close_docs()
        else
          cmp_cfg.get().view.docs.auto_open = true
          cmp.open_docs()
        end
      else
        fallback()
      end
    end, { e_mode.INSERT }),
    ['<TAB>'] = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_selected_entry() then
        ls.api.unlink_current_if_expandable()
        cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.insert })
      else
        fallback()
      end
    end, { e_mode.INSERT, e_mode.SELECT }),
    ['<C-.>'] = cmp.mapping(function(_)
      if ls.api.locally_jumpable(1) then
        ls.api.jump(1)
      else
        HELPER.feedkeys('<C-.>')
      end
    end, { e_mode.INSERT, e_mode.SELECT }),
    ['<C-,>'] = cmp.mapping(function(_)
      if ls.api.locally_jumpable(-1) then
        ls.api.jump(-1)
      else
        HELPER.feedkeys('<C-,>')
      end
    end, { e_mode.INSERT, e_mode.SELECT }),
    ['<A-,>'] = cmp.mapping(function(_)
      if cmp.visible() then
        if #cmp.get_entries() > 1 then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        else
          cmp.close()
        end
      else
        HELPER.feedkeys('<A-,>')
      end
    end, { e_mode.INSERT }),
    ['<A-.>'] = cmp.mapping(function(_)
      if cmp.visible() then
        if #cmp.get_entries() > 1 then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          cmp.close()
        end
      else
        HELPER.feedkeys('<A-.>')
      end
    end, { e_mode.INSERT }),
  }
end

local set_cmdline_keymaps = function(...)
  return {
    ['<TAB>'] = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_selected_entry() then
        cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.insert })
      elseif not cmp.visible() and this.api.has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { e_mode.COMMAND }),
    -- ['<CR>'] = cmp.mapping(function(fallback)
    --   if cmp.visible() and cmp.get_selected_entry() then
    --     cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.insert })
    --   else
    --     HELPER.feedkeys('<C-]>')
    --     HELPER.feedkeys('<CR>')
    --   end
    -- end, { e_mode.COMMAND }),
    ['<A-,>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if #cmp.get_entries() > 1 then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        else
          cmp.close()
        end
      end
    end, { e_mode.COMMAND }),
    ['<A-.>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if #cmp.get_entries() > 1 then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          cmp.close()
        end
      end
    end, { e_mode.COMMAND }),
  }
end

M.setup = function()
  events.rg(e_events.SETUP_CMP, function(state)
    if state.source == 'global' then
      TOOLS.tbl_r_extend(state.cfg, {
        mapping = set_global_keymaps()
      })
    elseif state.source == 'cmdline' then
      TOOLS.tbl_r_extend(state.cfg, {
        mapping = set_cmdline_keymaps()
      })
    end
  end)
end

return M

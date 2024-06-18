local keybinder = {}

-- +-------------------------------------------------------------------+
-- | Mode           | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang |
-- | Command        +------+-----+-----+-----+-----+-----+------+------+
-- | [nore]map      | yes  |  -  |  -  | yes | yes | yes |  -   |  -   |
-- | n[nore]map     | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
-- | [nore]map!     |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
-- | i[nore]map     |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
-- | c[nore]map     |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
-- | v[nore]map     |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
-- | x[nore]map     |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
-- | s[nore]map     |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
-- | o[nore]map     |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
-- | t[nore]map     |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
-- | l[nore]map     |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |
-- +-------------------------------------------------------------------+
keybinder.e_mode = {
  ALL     = '',
  NORMAL  = 'n',
  VISUAL  = 'v',
  INSERT  = 'i',
  SELECT  = 's',
  COMMAND = 'c',
  VISUAL_X = 'x',
}

keybinder.get_keymap = function(mode, lhs, bufnr)
  if bufnr then
    for _, mapagr in ipairs(vim.api.nvim_buf_get_keymap(bufnr, mode)) do
      if mapagr.lhs == lhs then
        return mapagr
      end
    end
  else
    for _, mapagr in ipairs(vim.api.nvim_get_keymap(mode)) do
      if mapagr.lhs == lhs then
        return mapagr
      end
    end
  end

  return nil
end

keybinder.hidegister = function(mode, key, opts)
  local final_opts = {
    remap = true,
    silent = true,
    desc = 'which_key_ignore'
  }

  Tools.tbl_r_extend(final_opts, opts or {})

  vim.keymap.set(mode, key, function() end, final_opts)
end

keybinder.unregister = function(mode, key, opts)
  local final_opts = {
    remap = true,
    silent = true,
  }

  Tools.tbl_r_extend(final_opts, opts or {})

  vim.keymap.set(mode, key, '<NOP>', final_opts)
end

keybinder.register = function(mode, lhs, rhs, opts)
  -- combine default options
  local final_opts = {
    remap = true,
    silent = true,
  }
  Tools.tbl_r_extend(final_opts, opts or {})

  -- fix rhs variable
  if (Tools.is_fwrapper(rhs)) then
    local wrapper = rhs
    rhs = function(...)
      wrapper(...)
    end
  end

  if not final_opts.mixture then
    vim.keymap.set(mode, lhs, rhs, final_opts)
  else
    keybinder.__mixture_keys = keybinder.__mixture_keys or (function()
      local ret = {}
      for _, _mode in pairs(keybinder.e_mode) do
        ret[_mode] = {
          native = {},
          buffer = {},
        }
      end
      return ret
    end)()

    local source = final_opts.mixture
    final_opts.mixture = nil

    local __mixture_key = {
      new = function(self, source, rhs, opts)
        table.insert(self.handlers, 1, { source = source, rhs = rhs })
        self.opts = opts
        return self
      end,
      append = function(self, source, rhs, opts)
        for _, _handler in pairs(self.handlers) do
          if _handler.source == source then
            return
          end
        end

        table.insert(self.handlers, 1, { source = source, rhs = rhs })
        Tools.tbl_r_extend(self.opts, opts or {})
      end,
      loop = function(self)
        for _, _handler in ipairs(self.handlers) do
          if type(_handler.rhs) == 'function' then
            local success = _handler.rhs()
            if success ~= nil and not success then
              return
            end
          else
            Helper.feedkeys(_handler.rhs)
          end
        end
      end,
      handlers = {},
      opts = {},
    }

    local _classify = final_opts.buffer ~= nil and 'buffer' or 'native'
    for _, _mode in ipairs(type(mode) == 'string' and { mode } or mode) do
      if keybinder.__mixture_keys[_mode][_classify][lhs] == nil then
        keybinder.__mixture_keys[_mode][_classify][lhs] = __mixture_key:new(source, rhs, final_opts)

        vim.keymap.set(mode, lhs, function(...)
          keybinder.__mixture_keys[_mode][_classify][lhs]:loop()
        end, final_opts)
      else
        keybinder.__mixture_keys[_mode][_classify][lhs]:append(source, rhs, final_opts)
      end
    end
  end
end

return keybinder

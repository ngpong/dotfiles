local M = {}

local Hop     = vim.__lazy.require("hop")
local HopHint = vim.__lazy.require("hop.hint")

local kmodes = vim.__key.e_mode

local function set_native_keymaps()
  local function donot_prompt(cb)
    return function()
      local nvim_echo = vim.api.nvim_echo
      vim.api.nvim_echo = function(...) end

      cb()

      vim.api.nvim_echo = nvim_echo
    end
  end

  local function short_prompt(cb)
    return function()
      local get_input_pattern = Hop.get_input_pattern
      Hop.get_input_pattern = function(...)
        local args = { ... } args[1] = ":"
        return get_input_pattern(table.unpack(args))
      end

      cb()

      Hop.get_input_pattern = get_input_pattern
    end
  end

  -- vim.__key.rg(kmodes.NVSO, "S", short_prompt(function()
  --   Hop.hint_words()
  -- end), { remap = true, silent = true })
  vim.__key.rg(kmodes.NVSO, "s", short_prompt(function()
    Hop.hint_char2()
  end), { remap = true, silent = true })
  vim.__key.rg({ kmodes.O, kmodes.VS }, "f", donot_prompt(function ()
    Hop.hint_char1({ direction = HopHint.HintDirection.AFTER_CURSOR, current_line_only = true })
  end), { remap = true, silent = true })
  vim.__key.rg({ kmodes.O, kmodes.VS }, "F", donot_prompt(function()
    Hop.hint_char1({ direction = HopHint.HintDirection.BEFORE_CURSOR, current_line_only = true })
  end), { remap = true, silent = true })
  vim.__key.rg({ kmodes.O, kmodes.VS }, "t", donot_prompt(function()
    Hop.hint_char1({ direction = HopHint.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
  end), { remap = true, silent = true })
  vim.__key.rg({ kmodes.O, kmodes.VS }, "T", donot_prompt(function()
    Hop.hint_char1({ direction = HopHint.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
  end), { remap = true, silent = true })
end

M.setup = function()
  set_native_keymaps()
end

return M

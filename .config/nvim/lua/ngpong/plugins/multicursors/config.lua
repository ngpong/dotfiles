local M = {}

local Events = require('ngpong.common.events')

local this = Plgs.multicursors

local e_name = Events.e_name

M.setup = function()
  local cfg = {
    DEBUG_MODE = false,
    create_commands = false, -- create Multicursor user commands
    updatetime = 50, -- selections get updated if this many milliseconds nothing is typed in the insert mode see :help updatetime
    nowait = true, -- see :help :map-nowait
    -- see :help hydra-config.hint
    hint_config = false,
    -- accepted values:
    -- -1 true: generate hints
    -- -2 false: don't generate hints
    -- -3 [[multi line string]] provide your own hints
    -- -4 fun(heads: Head[]): string - provide your own hints
    generate_hints = {
      normal = false,
      insert = false,
      extend = false,
      config = {
        -- determines how many columns are used to display the hints. If you leave this option nil, the number of columns will depend on the size of your window.
        column_count = nil,
        -- maximum width of a column.
        max_hint_length = 25,
      }
    },
    on_enter = function()
      if this.api.is_first_time_enter_normal() then
        Helper.add_jumplist()
        this.api.set_first_time_enter_normal()
      end

      vim.schedule(function()
        Plgs.lualine.api.refresh()
      end)
    end,
    on_exit = function()
      this.api.unset_first_time_enter_normal()
      vim.schedule(function()
        Plgs.lualine.api.refresh()
      end)
    end,
  }

  Events.emit(e_name.SETUP_MULTICURSORS, cfg)

  require('multicursors').setup(cfg)
end

return M

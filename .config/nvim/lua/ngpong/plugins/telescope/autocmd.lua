local M = {}

local libP    = require('ngpong.common.libp')
local Autocmd = require('ngpong.common.autocmd')
local Events  = require('ngpong.common.events')

local this = Plgs.telescope

local e_name = Events.e_name

local unset_autocmds = function()
  Autocmd.del_augroup('telescope')
end

local setup_autocmds = function()
  Autocmd.new_augroup().on('User', function(args)
    Events.emit(e_name.TELESCOPE_PREVIEW_LOAD, args)
  end, 'TelescopePreviewerLoaded')

  Autocmd.new_augroup('telescope').on('WinEnter', function(args)
    local bufnr = args.buf

    libP.async.run(function()
      libP.async.util.scheduler()

      if not Plgs.is_loaded('telescope.nvim') then
        return
      end

      if not this.api.is_prompt_buf(bufnr) then
        return
      end

      local picker = this.api.get_current_picker(bufnr)
      if not picker then
        return
      end

      Events.emit(e_name.TELESCOPE_LOAD, { bufnr = bufnr, picker = picker })
    end)
  end)
end

M.setup = function()
  unset_autocmds()
  setup_autocmds()
end

return M

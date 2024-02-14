local M = {}

local autocmd = require('ngpong.common.autocmd')
local events  = require('ngpong.common.events')
local lazy    = require('ngpong.utils.lazy')
local async   = lazy.require('plenary.async')

local this = PLGS.telescope
local e_events = events.e_name

local unset_autocmds = function()
  autocmd.del_augroup('telescope')
end

local setup_autocmds = function()
  local group_id = autocmd.new_augroup('telescope')

  vim.api.nvim_create_autocmd('User', {
    pattern = 'TelescopePreviewerLoaded',
    callback = function(args)
      events.emit(e_events.TELESCOPE_PREVIEW_LOAD, args)
    end,
  })

  vim.api.nvim_create_autocmd('WinEnter', {
    group = group_id,
    callback = function(args)
      local bufnr = args.buf

      async.run(function()
        async.util.scheduler()

        if not PLGS.is_loaded('telescope.nvim') then
          return
        end

        if not this.api.is_prompt_buf(bufnr) then
          return
        end

        local picker = this.api.get_current_picker(bufnr)
        if not picker then
          return
        end

        events.emit(e_events.TELESCOPE_LOAD, { bufnr = bufnr, picker = picker })
      end)
    end,
  })
end

M.setup = function()
  unset_autocmds()
  setup_autocmds()
end

return M

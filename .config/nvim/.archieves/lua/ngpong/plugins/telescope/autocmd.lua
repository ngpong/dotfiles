local M = {}

local etypes = vim.__event.types

local group = vim.__autocmd.augroup("telescope")

local unset_autocmds = function()
  group:del()
end

local setup_autocmds = function()
  local t_api = vim._plugins.telescope.api

  group:on("User", function(args)
    vim.__event.emit(etypes.TELESCOPE_PREVIEW_LOAD, args)
  end, { pattern = "TelescopePreviewerLoaded" })

  group:on("WinEnter", vim.__async.schedule_wrap(function(args)
    if not vim.__plugin.loaded("telescope.nvim") then
      return
    end

    if not vim.__buf.is_valid(args.buf) then
      return
    end

    if not t_api.is_prompt_buf(args.buf) then
      return
    end

    local picker = t_api.get_current_picker(args.buf)
    if not picker then
      return
    end

    vim.__event.emit(etypes.TELESCOPE_LOAD, { bufnr = args.buf, picker = picker })
  end))
end

M.setup = function()
  unset_autocmds()
  setup_autocmds()
end

return M

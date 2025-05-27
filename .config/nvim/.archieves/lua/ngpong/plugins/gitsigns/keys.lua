local M = {}

local Gitsigns = vim.__lazy.require("gitsigns")

local g_api = vim._plugins.gitsigns.api
local t_api = vim._plugins.trouble.api

local kmodes = vim.__key.e_mode
local etypes = vim.__event.types

local set_git_buffer_diffthis_keymaps = function(bufnr)
  bufnr = bufnr or true

  vim.__key.rg(kmodes.N, "gd", g_api.toggle_diffthis, { buffer = bufnr, desc = "toggle current file changed." })
end

local set_git_buffer_popup_keymaps = function(bufnr)
  bufnr = bufnr or true

  local maparg = vim.__key.get(kmodes.N, "q")
  if maparg then
    vim.__key.rg(kmodes.N, "q", maparg.callback, { buffer = bufnr, desc = maparg.desc, silent = maparg.silent, remap = not maparg.noremap })
  end
end

local set_git_buffer_keymaps = function(bufnr)
  bufnr = bufnr or true

  set_git_buffer_diffthis_keymaps(bufnr)

  vim.__key.rg(kmodes.N, "gg", vim.__util.wrap_f(t_api.toggle, "git"), { silent = true, buffer = bufnr, desc = "toggle current buffer gitsigns list." })
  vim.__key.rg(kmodes.N, "g[", vim.__util.wrap_f(Gitsigns.prev_hunk, { wrap = false, navigation_message = true }), { buffer = bufnr, nowait = true, desc = "jump to prev hunk." })
  vim.__key.rg(kmodes.N, "g]", vim.__util.wrap_f(Gitsigns.next_hunk, { wrap = false, navigation_message = true }), { buffer = bufnr, nowait = true, desc = "jump to next hunk." })
  vim.__key.rg(kmodes.N, "ghs", Gitsigns.select_hunk, { buffer = bufnr, nowait = true, desc = "select current hunk." })
  -- vim.__key.rg(kmodes.N, "gha", Gitsigns.stage_hunk, { buffer = bufnr, nowait = true, desc = "staged current hunk." })
  vim.__key.rg(kmodes.N, "ghr", Gitsigns.reset_hunk, { buffer = bufnr, nowait = true, desc = "restore current hunk." })
  vim.__key.rg(kmodes.N, "gr", function()
    vim.__ui.input({ prompt = "This operation will restore the entire file, yes(y) or no(n,...)?", relative = "editor" }, function(res)
      if res ~= "y" then
        return
      end

      Gitsigns.reset_buffer()
    end)
  end, { buffer = bufnr, nowait = true, desc = "restore current file." })
  -- vim.__key.rg(kmodes.N, "gu", Gitsigns.reset_buffer_index, { buffer = bufnr, nowait = true, desc = "unstage current file." })
  -- vim.__key.rg(kmodes.N, "ga", Gitsigns.stage_buffer, { buffer = bufnr, nowait = true, desc = "stage current file." })
  vim.__key.rg(kmodes.N, "gb", vim.__util.wrap_f(g_api.blame_line), { buffer = bufnr, nowait = true, desc = "show blame line for current hunk." })
  vim.__key.rg(kmodes.N, "gp", vim.__util.wrap_f(g_api.preview_hunk), { buffer = bufnr, nowait = true, desc = "preview current hunk changed." })
end

M.setup = function()
  vim.__event.rg(etypes.GITSIGNS_OPEN_DIFFTHIS, function(state)
    set_git_buffer_diffthis_keymaps(state.bufnr)
  end)

  vim.__event.rg(etypes.GITSIGNS_OPEN_POPUP, function(state)
    set_git_buffer_popup_keymaps(state.bufnr)
  end)

  vim.__event.rg(etypes.ATTACH_GITSIGNS, function(state)
    set_git_buffer_keymaps(state.bufnr)
  end)
end

return M

local M = {}

local Luasnip = vim.__lazy.require("luasnip")

local group = vim.__autocmd.augroup("luasnip")

local unset_autocmds = function()
  group:del()
end

local setup_autocmds = function()
  group:on("ModeChanged", function(_)
    if ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
        and Luasnip.session.current_nodes[vim.__buf.current()]
        and not Luasnip.session.jump_active
    then
      Luasnip.unlink_current()
    end
  end)
end

M.setup = function()
  unset_autocmds()
  setup_autocmds()
end

return M

local M = {}

local etypes = vim.__event.types

local schedule_quitall = vim.__async.schedule_wrap(function()
  vim.cmd("wqall")
end)

M.setup = function()
  local t_api = vim._plugins.telescope.api

  -- 设置 previewer 行号和 wrapper
  vim.__event.rg(etypes.TELESCOPE_PREVIEW_LOAD, function(_)
    -- https://github.com/nvim-telescope/telescope.nvim/issues/2777
    vim.opt.wrap = true
    -- https://github.com/nvim-telescope/telescope.nvim/issues/1186
    vim.opt.number = true
  end)

  -- 在打开 telescope 退出 vim 的情况下不要报错
  vim.__event.rg(etypes.VIM_EXIT_PRE, function(_)
    for _, tabpage in pairs(vim.__tab.pages()) do
      for _, winid in pairs(vim.__win.all(tabpage)) do
        local bufnr = vim.__buf.number(winid)

        if t_api.is_prompt_buf(bufnr) then
          t_api.actions.close(bufnr)
          return schedule_quitall()
        end
      end
    end
  end)
end

return M

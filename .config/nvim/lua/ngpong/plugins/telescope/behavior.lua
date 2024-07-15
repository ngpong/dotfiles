local M = {}

local Events = require('ngpong.common.events')

local this = Plgs.telescope

local e_name = Events.e_name

M.setup = function()
  -- 设置 previewer 行号和 wrapper
  Events.rg(e_name.TELESCOPE_PREVIEW_LOAD, function(_)
    -- https://github.com/nvim-telescope/telescope.nvim/issues/2777
    vim.opt.wrap = true
    -- https://github.com/nvim-telescope/telescope.nvim/issues/1186
    vim.opt.number = true
  end)

  -- 在打开 telescope 退出 vim 的情况下不要报错
  Events.rg(e_name.VIM_EXIT_PRE, function(_)
    for _, tabpage in pairs(Helper.get_list_tabpage()) do
      for _, winid in pairs(Helper.get_list_winids(tabpage)) do
        local bufnr = Helper.get_bufnr(winid)

        if this.api.is_prompt_buf(bufnr) then
          this.api.actions.close(bufnr)
          vim.cmd('wqall')
          return
        end
      end
    end
  end)
end

return M

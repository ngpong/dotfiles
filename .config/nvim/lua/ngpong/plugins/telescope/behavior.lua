local M = {}

local events  = require('ngpong.common.events')

local this = PLGS.telescope
local e_events = events.e_name

M.setup = function()
  -- 设置 previewer 行号和 wrapper
  events.rg(e_events.TELESCOPE_PREVIEW_LOAD, function(_)
    -- https://github.com/nvim-telescope/telescope.nvim/issues/2777
    vim.opt.wrap = true
    -- https://github.com/nvim-telescope/telescope.nvim/issues/1186
    vim.opt.number = true
  end)

  -- 调整 telescope 刚打开时候的鼠标位置
  events.rg(e_events.TELESCOPE_LOAD, function(state)
    HELPER.presskeys('g$')
  end)

  -- 在打开 telescope 退出 vim 的情况下不要报错
  events.rg(e_events.VIM_EXIT_PRE, function(_)
    for _, tabpage in pairs(HELPER.get_list_tabpage()) do
      for _, winid in pairs(HELPER.get_list_winids(tabpage)) do
        local bufnr = HELPER.get_bufnr(winid)

        if this.api.is_prompt_buf(bufnr) then
          this.api.actions.close(bufnr)
          vim.cmd('qall')
          return
        end
      end
    end
  end)
end

return M

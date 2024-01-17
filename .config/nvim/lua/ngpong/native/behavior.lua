local M = {}

local events = require('ngpong.common.events')

local e_events = events.e_name

M.setup = function()
  events.rg(e_events.VIM_ENTER, function()
    -- clear jump list
    HELPER.clear_jumplist()

    -- clear search pattern
    HELPER.clear_searchpattern()
  end)

  events.rg(e_events.BUFFER_READ_POST, function(args)
    -- 打开文件时自动跳到文件上一次关闭时所停留的问题
    --  1. https://www.reddit.com/r/neovim/comments/ucgxmj/how_to_update_the_lastpositionjump_to_a_lua/
    --  2. https://www.reddit.com/r/neovim/comments/632wh4/neovim_does_not_save_last_cursor_position/

    -- don't apply to git messages
    local ft = vim.opt_local.filetype:get()
    if (ft:match('commit') or ft:match('rebase')) then
      return
    end

    -- get position of last saved edit
    local line, col = TOOLS.tbl_unpack(vim.api.nvim_buf_get_mark(0, '"'))

    -- if in range, go there
    if (line > 1) and (line <= vim.api.nvim_buf_line_count(0)) then
      vim.api.nvim_win_set_cursor(0, { line, col })
    end
  end)
end

return M
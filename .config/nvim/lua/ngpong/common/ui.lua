local ui = {}

local icons     = require('ngpong.utils.icon')
local filesize  = require('ngpong.utils.filesize')
local lazy      = require('ngpong.utils.lazy')
local nui_popup = lazy.require('nui.popup')
local nui_text  = lazy.require('nui.text')

-- https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup
-- https://github.com/nvim-neo-tree/neo-tree.nvim/blob/77d9f484b88fd380386b46ed9206e5374d69d9d8/lua/neo-tree/ui/popups.lua#L70

ui.popup_fileinfo = function(bufnr)
  bufnr = bufnr or HELPER.get_cur_bufnr()

  local path = HELPER.get_buf_name(bufnr)

  local state = TOOLS.get_filestate(path)
  if not state then
    HELPER.notify_err('Unable to get file state, bufnr [' .. bufnr .. ']')
    return
  end

  local lines = {}
  table.insert(lines, '')
  table.insert(lines, string.format('%9s: %s', 'Name', TOOLS.get_filename(path)))
  table.insert(lines, string.format('%9s: %s', 'bufnr', tostring(bufnr)))
  table.insert(lines, string.format('%9s: %s', 'Path', path))
  table.insert(lines, string.format('%9s: %s', 'Type', state.type))
  if state.size then
    table.insert(lines, string.format('%9s: %s', 'Size', filesize(state.size, { output = 'string' })))
    table.insert(lines, string.format('%9s: %s', 'Created', os.date('%Y-%m-%d %I:%M %p', state.birthtime.sec)))
    table.insert(lines, string.format('%9s: %s', 'Modified', os.date('%Y-%m-%d %I:%M %p', state.mtime.sec)))
  end
  table.insert(lines, '')
  table.insert(lines, ' Press <Escape> to close')

  local max_line_width = 0
  for _, line in ipairs(lines) do
    if line:len() > max_line_width then
      max_line_width = line:len()
    end
  end

  local popup_options = {
    relative = 'editor',
    position = '50%',
    size = {
      width = max_line_width + 1,
      height = #lines + 1
    },
    border = {
      text = {
        top = nui_text(icons.space .. 'File info' .. icons.space, 'FloatTitle'),
      },
      style = 'rounded',
    },
    win_options = {
      winblend = 20,
    },
    buf_options = {
      bufhidden = 'delete',
      buflisted = false,
      filetype = 'ngpong_popup',
    },
    zindex = 60,
  }

  local win = nui_popup(popup_options)
  win:mount()

  local success, msg = pcall(vim.api.nvim_buf_set_lines, win.bufnr, 0, 0, false, lines)
  if success then
    vim.api.nvim_set_option_value('modifiable', false, { buf = win.bufnr })
    vim.api.nvim_set_option_value('readonly', true, { buf = win.bufnr })

    win:map('n', '<esc>', function(bufnr)
      win:unmount()
    end, { noremap = true })

    local event = require('nui.utils.autocmd').event
    win:on({ event.BufLeave, event.BufDelete }, function()
      win:unmount()
    end, { once = true })

    -- why is this necessary?
    vim.api.nvim_set_current_win(win.winid)
  else
    LOGGER.error(msg)
    win:unmount()
  end
end

return ui

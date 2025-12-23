local ui = {}

local NuiPopup = vim.__lazy.require("nui.popup")
local NuiText  = vim.__lazy.require("nui.text")
local NuiLine  = vim.__lazy.require("nui.line")

vim.api.nvim_set_hl(0, "NuiFileInfoTail", { fg = vim.__color.dark4, italic = true })
vim.api.nvim_set_hl(0, "NuiFileInfoText", { fg = vim.__color.dark4, italic = true })
ui.popup_fileinfo = function(bufnr)
  bufnr = bufnr or vim.__buf.current()
  local path = vim.__buf.name(bufnr)

  local state, err = vim.__fs.state(path)
  if not state then
    vim.__echo.err(err)
    return
  end

  local texts = {
    NuiText(""),
    NuiText(string.format("%8s: %s", "Name", vim.__path.basename(path))),
    NuiText(string.format("%8s: %s", "Bufinfo", string.format("%s|%s(%s)", tostring(bufnr), tostring(vim.__win.current()), table.concat(vim.__buf.findwin(bufnr), ",")))),
    NuiText(string.format("%8s: %s", "Path", vim.__path.relpath(path, vim.__path.cwd()))),
    NuiText(string.format("%8s: %s", "Ws", vim.__path.cwd())),
    NuiText(string.format("%8s: %s", "Type", state.type)),
  }
  if state.size then
    table.insert(texts, NuiText(string.format("%8s: %s", "Size", vim.__fs.human_size(state.size, { output = "string" }))))
    table.insert(texts, NuiText(string.format("%8s: %s", "Created", os.date("%Y-%m-%d %I:%M %p", state.birthtime.sec))))
    table.insert(texts, NuiText(string.format("%8s: %s", "Modified", os.date("%Y-%m-%d %I:%M %p", state.mtime.sec))))
  end
  table.insert(texts, NuiText(""))
  table.insert(texts, NuiText(" Press q to close", "NuiFileInfoTail"))
  table.insert(texts, NuiText(""))

  local max_length = 0
  for _, text in ipairs(texts) do
    local length = text:length()

    if length > max_length then
      max_length = length
    end
  end

  local function open_popup()
    local win = NuiPopup({
      position = "50%",
      size = {
        width = max_length + 1,
        height = #texts,
      },
      zindex = 60,
      relative = "editor",
      border = {
        padding = { top = 0, bottom = 0, left = 0, right = 0, },
        style = vim.__icons.border.no,
        -- text = { top = NuiText(vim.__icons.space .. "File info" .. vim.__icons.space, "FloatTitle"), },
      },
      buf_options = {
        bufhidden = "wipe",
        buflisted = false,
        filetype = "fileinfo_popup",
      },
      win_options = {
        winblend = 0,
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
      },
    })
    win:mount()

    for i, text in ipairs(texts) do
      NuiLine({ text }):render(win.bufnr, -1, i)
    end

    return win
  end

  local success, win = pcall(open_popup)
  if success then
    vim.api.nvim_set_option_value("modifiable", false, { buf = win.bufnr })
    vim.api.nvim_set_option_value("readonly", true, { buf = win.bufnr })

    win:map("n", "q", function(...) -- bufnr
      win:unmount()
    end, { noremap = true })

    local event = require("nui.utils.autocmd").event
    win:on({ event.BufLeave, event.BufDelete, event.WinLeave }, vim.schedule_wrap(function()
      win:unmount()
    end), { once = true })

    vim.api.nvim_set_current_win(win.winid)
  else
    vim.__logger.error(win)
    win:unmount()
  end
end

return ui

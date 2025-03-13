local M = {}

local t_api = vim._plugins.trouble.api

local etypes = vim.__event.types

M.setup = function()
  vim.__event.rg(etypes.FILE_TYPE, vim.__async.schedule_wrap(function(state) -- 在刚打开 trouble 后并不会立即初始化
    if "trouble" ~= state.file then
      return
    end

    local view = t_api.find_view({ bufnr = state.buf })
    if not view then
      return
    end

    vim.__event.emit(etypes.CREATE_TROUBLE_LIST, { buf = state.buf, mode = view.opts.mode, view = view })
  end))

  vim.__event.rg(etypes.WIN_CLOSED, function(state)
    if "trouble" ~= vim.__buf.filetype(state.buf) then
      return
    end

    local view = t_api.find_view({ bufnr = state.buf })
    if not view then
      return
    end

    vim.__event.emit(etypes.CLOSED_TROUBLE_LIST, { buf = state.buf, mode = view.opts.mode, view = view })
  end)

  vim.__event.rg(etypes.BUFFER_ENTER, function(state)
    if "trouble" == vim.__buf.filetype(state.buf) then
      local view = t_api.find_view({ bufnr = state.buf })
      if not view then
        return
      end

      if view.opts.win.position == "right" then
        vim.__g.resize_direction = "v"
      else
        vim.__g.resize_direction = "h"
      end
    else
      vim.__g.resize_direction = "v"
    end
  end)
end

return M

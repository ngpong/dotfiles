local Marks = vim.__lazy.require("marks")
local Item  = vim.__lazy.require("trouble.item")
local Cache = vim.__lazy.require("trouble.cache")

local m_api = vim._plugins.marks.api

local etypes = vim.__event.types

local M = {}

M.config = {
  formatters = {
    mark_text = function(ctx)
      return {
        text = ctx.item.mark,
        hl = "MarkSignHL",
      }
    end,
  },
  modes = {
    mark = {
      events = {
        "BufEnter",
        "BufWritePost",
        { event = "User", pattern = { "MarkChanged" } },
        { event = "User", pattern = { "NeotreeDeletedFile", "NeotreeMovedFile", "NeotreeRenamedFile" } },
      },
      source = "mark",
      desc = "Marks",
      groups = {
        { "filename", format = "{file_icon}{filename} {count}" },
      },
      sort = { { buf = 0 }, "filename", "pos" },
      format = "{mark_text} {text:ts} {pos}",
    },
  },
}

local cache_pattern = function(mode, bufnr)
  if not bufnr then
    return mode
  else
    return string.format("%s_%d", mode, bufnr)
  end
end

M.setup = function()
  vim.api.nvim_set_hl(0, "MarkTextAqua", { fg = vim.__color.bright_aqua, italic = true })
  vim.api.nvim_set_hl(0, "MarkTextRed", { fg = vim.__color.bright_red, italic = true })

  local avalib_modes = vim.__tbl.keys(M.config.modes, function(k, v)
    return not v.is_template_section
  end)

  vim.__event.rg(etypes.CREATE_TROUBLE_LIST, function(event_info)
    if not vim.__tbl.contains(avalib_modes, event_info.mode) then
      return
    end

    local group = vim.__autocmd.augroup("trouble_mark")

    group:on("User", function(state)
      Cache.mark[cache_pattern("document_mark", state.buf)] = nil
      Cache.mark[cache_pattern("workspace_mark")] = nil
    end, { pattern = "MarkChanged" })

    group:on("BufWritePost", function(state)
      Cache.mark[cache_pattern("document_mark", state.buf)] = nil
      Cache.mark[cache_pattern("workspace_mark")] = nil
    end)

    group:on("BufDelete", function(state)
      Cache.mark[cache_pattern("document_mark", state.buf)] = nil
    end)

    group:on("User", function(_)
      Cache.mark[cache_pattern("workspace_mark")] = nil
    end, { pattern = { "NeotreeDeletedFile", "NeotreeMovedFile", "NeotreeRenamedFile" } })
  end)

  vim.__event.rg(etypes.CLOSED_TROUBLE_LIST, function(event_info)
    if not vim.__tbl.contains(avalib_modes, event_info.mode) then
      return
    end

    vim.__autocmd.clear("trouble_mark")
  end)
end

M.get = function(cb, ctx)
  local total_items = {}

  local bufnr = vim.__buf.current()

  do
    local pattern = cache_pattern("document_mark", bufnr)

    local trouble_buf_cache = Cache.mark[pattern]
    if trouble_buf_cache then
      vim.__tbl.insert_arr(total_items, trouble_buf_cache)
    else
      local items = {}

      local cache_mark = Marks.mark_state.buffers[bufnr] or {}

      for _mark, _data in pairs(cache_mark and cache_mark.placed_marks or {}) do
        if m_api.is_lower_mark(_mark) then
          local text = vim.__fs.getline(bufnr, _data.line)
          if not text then
            goto continue
          end

          local _item = {
            filename = vim.__buf.name(bufnr),
            tag = "Lowercase mark",
            mark = _mark,
            lnum = _data.line,
            col = vim.v.maxcol,
            text = text,
          }

          items[#items + 1] = Item.new({
            buf = vim.fn.bufadd(_item.filename),
            pos = { _item.lnum, 0 },
            end_pos = { _item.lnum, _item.col },
            text = _item.text,
            filename = _item.filename,
            item = _item,
            source = "mark",
          })
        end

        ::continue::
      end

      if next(items) then
        Cache.mark[pattern] = items
        vim.__tbl.insert_arr(total_items, items)
      end
    end
  end

  do
    local pattern = cache_pattern("workspace_mark")

    local trouble_glob_cache = Cache.mark[pattern]
    if trouble_glob_cache then
      vim.__tbl.insert_arr(total_items, trouble_glob_cache)
    else
      local items = {}

      local workspace = vim.__path.cwd()

      for _, _data in ipairs(vim.fn.getmarklist()) do
        local mark = _data.mark:sub(2, 3)

        if m_api.is_upper_mark(mark) then
          local row = _data.pos[2]
          local col = _data.pos[3]

          local filename = vim.__path.expanduser(_data.file)

          if not vim.__fs.exists(filename) then
            goto continue
          end

          local text = vim.__fs.getline(filename, row)
          if not text then
            goto continue
          end

          if filename:match(workspace) then
            local _item = {
              filename = filename,
              tag = "Uppercase mark",
              lnum = row,
              mark = mark,
              col = vim.v.maxcol,
              text = text,
            }

            items[#items + 1] = Item.new({
              buf = vim.fn.bufadd(_item.filename),
              pos = { _item.lnum, 0 },
              end_pos = { _item.lnum, _item.col },
              text = _item.text,
              filename = _item.filename,
              item = _item,
              source = "mark",
            })
          end
        end

        ::continue::
      end

      if next(items) then
        Cache.mark[pattern] = items
        vim.__tbl.insert_arr(total_items, items)
      end
    end
  end

  Item.add_id(total_items)

  cb(total_items)
end

return M

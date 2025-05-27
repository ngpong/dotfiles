local M = {}

M.config = {
  formatters = {
    bookmarkinfo = function(ctx)
      local item = ctx.item

      local bmid  = item.item.bmid
      local alias = item.item.alias

      local form = {}

      if bmid then
        table.insert(form, {
          text = "(",
          hl = "TroubleBookmark"
        })
        table.insert(form, {
          text = bmid,
          hl = "TroubleBookmark"
        })
      end

      if alias then
        table.insert(form, {
          text = string.format(": %s", alias),
          hl = "TroubleBookmark"
        })
      end

      if next(form) then
        table.insert(form, {
          text = ")",
          hl = "TroubleBookmark"
        })

        table.insert(form, {
          text = " "
        })
      end

      return form
    end,
  },
  modes = {
    bookmarks = {
      title = "{hl:TroubleTitle}Bookmarks",
      events = {
        "BufWinEnter",
        { event = "User", pattern = { "BookmarkCountChanged" } },
      },
      desc = "Bookmarks",
      source = "bookmarks",
      format = "{file}{bookmarkinfo}{text:ts}",
    },
  },
}

function M.setup()
  vim.api.nvim_set_hl(0, "TroubleBookmark", { fg = vim.__color.bright_red })
end

function M.get(cb, ctx)
  local Item = require("trouble.item")

  local bm_states, bm_persists, get_extmark_lnum = vim.__bookmark:utils()

  local items = {}

  local function cvrt_state_2_items(bufnr, state)
    local bufname = vim.__buf.name(bufnr)

    for bmid, v in pairs(state._) do
      local extmark_id = v.ex_ids[1]

      local lnum = get_extmark_lnum(bufnr, extmark_id)
      local pos = { lnum, 0 }

      local line = vim.__buf.getline(bufnr, lnum)
      if line then line = vim.trim(line) end

      table.insert(items, Item.new({
        buf = bufnr,
        filename = bufname,
        pos = pos,
        end_pos = pos,
        source = "bookmarks",
        item = {
          text = line,
          bmid = bmid,
          alias = v.alias,
        }
      }))
    end
  end

  local function cvrt_persist_2_items(path, persist)
    for bmid, v in pairs(persist._) do
      local lnum = v.lnum
      local pos = { lnum, 0 }

      local line = vim.__fs.getline(path, lnum)
      if line then line = vim.trim(line) end

      table.insert(items, Item.new({
        filename = path,
        pos = pos,
        end_pos = pos,
        source = "bookmarks",
        item = {
          text = line,
          bmid = bmid,
          alias = v.alias,
        }
      }))
    end
  end

  for bufnr, state in pairs(bm_states) do
    cvrt_state_2_items(bufnr, state)
  end
  for path, persist in pairs(bm_persists) do
    cvrt_persist_2_items(path, persist)
  end

  local current_bufnr = vim.__buf.current()
  table.sort(items, function(lhs, rhs)
    if
      lhs.buf == current_bufnr and rhs.buf ~= current_bufnr
    then
      return true
    elseif
      lhs.buf ~= current_bufnr and rhs.buf == current_bufnr
    then
      return false
    else
      if lhs.filename ~= rhs.filename then
        return lhs.filename < rhs.filename
      end
      return lhs.pos[1] < rhs.pos[1]
    end
  end)

  for _, i in ipairs(items) do
    i.id = Item.generate_id(i)
  end

  cb(items)
end

return M

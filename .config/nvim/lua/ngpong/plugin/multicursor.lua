local f_wrap = function(f)
  return function ()
    local bufnr = vim.__buf.current()

    local bopts = vim.bo[bufnr]
    if bopts.readonly or not bopts.modifiable then
      return
    end

    local ft = vim.__buf.filetype(bufnr)
    if vim.__filter.contain_fts(ft) then
      return
    end

    local bt = vim.__buf.buftype(bufnr)
    if vim.__filter.contain_bts(bt) then
      return
    end

    f()

    vim.__stl.redraw()
  end
end

local mc = vim.__lazy.require("multicursor-nvim")

return {
  "jake-stewart/multicursor.nvim",
  main = "multicursor-nvim",
  lazy = true,
  highlights = {
    { "MultiCursorCursor", bg = vim.__color.bright_blue, fg = vim.__color.dark0_hard },
    { "MultiCursorVisual", link = "Visual" },
    { "MultiCursorDisabledCursor", link = "MultiCursorCursor" },
    { "MultiCursorDisabledVisual", link = "Visual" },
  },
  opts = {
    signs = false,
    shallowUndo = true,
    hlsearch = true,
    layer_keys = {
      {
        "<A-f>",
        f_wrap(function()
          mc.nextCursor()
        end),
        mode = { "n", "v" }
      },
      {
        "<A-b>",
        f_wrap(function()
          mc.prevCursor()
        end),
        mode = { "n", "v" }
      },
      {
        "<ESC>",
        f_wrap(function()
          mc.clearCursors()
        end)
      },
      {
        "<A-SPACE>",
        f_wrap(function()
          if mc.cursorsEnabled() then
            mc.disableCursors()
          else
            mc.enableCursors()
          end
        end),
        mode = { "n", "v" }
      }
    },
  },
  keys = {
    {
      "<A-u>",
      f_wrap(function()
        mc.lineAddCursor(-1)

        if not mc.cursorsEnabled() then
          mc.toggleCursor()
        end
      end)
    },
    {
      "<A-d>",
      f_wrap(function()
        mc.lineAddCursor(1)

        if not mc.cursorsEnabled() then
          mc.toggleCursor()
        end
      end)
    },
    {
      "<A-S-D>",
      f_wrap(function()
        if not mc.cursorsEnabled() then
          mc.action(function(ctx)
            local cursor = ctx:mainCursor():overlappedCursor()
            if cursor then
              cursor:delete()
            end
          end)
        end

        mc.lineSkipCursor(1)
      end)
    },
    {
      "<A-S-U>",
      f_wrap(function()
        if not mc.cursorsEnabled() then
          mc.action(function(ctx)
            local cursor = ctx:mainCursor():overlappedCursor()
            if cursor then
              cursor:delete()
            end
          end)
        end

        mc.lineSkipCursor(-1)
      end)
    },
    {
      "<A-n>",
      f_wrap(function()
        vim.__jumplst.add()
        mc.matchAddCursor(1)

        if not mc.cursorsEnabled() then
          mc.toggleCursor()
        end
      end),
    },
    {
      "<A-n>",
      f_wrap(function()
        vim.__jumplst.add()
        mc.matchAddCursor(1)

        if not mc.cursorsEnabled() then
          mc.toggleCursor("v")
        end
      end),
      mode = "v"
    },
    {
      "<A-S-N>",
      f_wrap(function()
        local cursor_enabled = mc.cursorsEnabled()

        if not cursor_enabled then
          mc.action(function(ctx)
            local cursor = ctx:mainCursor():overlappedCursor()
            if cursor then
              cursor:delete()
            end
          end)
        end

        vim.__jumplst.add()
        mc.matchSkipCursor(1)

        if not cursor_enabled then
          mc.toggleCursor()
        end
      end),
    },
    {
      "<A-S-N>",
      f_wrap(function()
        local cursor_enabled = mc.cursorsEnabled()

        if not cursor_enabled then
          mc.action(function(ctx)
            local cursor = ctx:mainCursor():overlappedCursor()
            if cursor then
              cursor:delete()
            end
          end)
        end

        vim.__jumplst.add()
        mc.matchSkipCursor(1)

        if not cursor_enabled then
          mc.toggleCursor("v")
        end
      end),
      mode = "v"
    },
    {
      "<A-`>",
      f_wrap(function()
        local has_cursor     = mc.hasCursors()
        local cursor_enabled = mc.cursorsEnabled()

        if not has_cursor or not cursor_enabled then
          mc.toggleCursor()
        else
          mc.deleteCursor()
        end
      end)
    },
    {
      "<A-`>",
      f_wrap(function()
        mc.visualToCursors()
        if not mc.cursorsEnabled() then
          mc.toggleCursor()
        end
      end),
      mode = "v"
    }
  },
  config = function(_, opts)
    mc.setup(opts)

    mc.addKeymapLayer(function(layerSet)
      for _, keyspec in ipairs(opts.layer_keys) do
        layerSet(keyspec.mode or "n", keyspec[1], keyspec[2])
      end
    end)
  end,
  hackers = {
    before = {
      function()
        local examples = require("multicursor-nvim.examples")
        function examples.toggleCursor(mode)
          mode = mode or "n"
          mc.action(function(ctx)
            ctx:setCursorsEnabled(false)

            local mainCursor = ctx:mainCursor()
            local cursor = mainCursor:overlappedCursor()
            if cursor then
              cursor:delete()
            else
              local newCursor = mainCursor:clone()
              mainCursor:disable()
              newCursor:setMode(mode):select()
            end
          end)
        end
      end
    }
  }
}

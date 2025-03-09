-- {
--   "   ▄█▄       ▐▄",
--   "▄█████▄      ▐██▌                                           ▄▄",
--   "█████████▄   ▐████                                ▄▄     ▄▄ ▄▄  ▄▄  ▄▄   ▄▄▄",
--   "███████████▄ ▐████     ▐▌▄▀▀▀▀▌  ▄▀▀▀▀▀▄  ▄▀▀▀▀▀█▄▀██   ▄█▌ ██  ██▀▀▀▀██▀▀▀▀█▌",
--   "████▌▀████████████     ▐▌     █ ▐▌▄▄▄▄▄▀ █       █ ▀█▌ ▄█▌  ██  ██    ██    █▌",
--   "████▌  ▀██████████     ▐▌     █ ▐▌       █       █  ▀█▄██   ██  ██    ██    █▌",
--   "████▌    ▀████████     ▐▌     █  ▀▀▄▄▄▄▀  ▀▄▄▄▄▄▀    ▀██    ██  ██    ██    █▌",
--   "▀███▌      ▀██████",
--     "▀█▌        ▀██▀",
-- }

local function greeting()
  local datetime = tonumber(os.date(" %H "))
  local username = os.getenv("USER")

  local ret

  if datetime >= 0 and datetime < 6 then
    ret = "Dreaming..󰒲 󰒲 "
  elseif datetime >= 6 and datetime < 12 then
    ret = "🌅 Hi " .. username .. ", Good Morning ☀️"
  elseif datetime >= 12 and datetime < 18 then
    ret = "🌞 Hi " .. username .. ", Good Afternoon ☕️"
  elseif datetime >= 18 and datetime < 21 then
    ret = "🌆 Hi " .. username .. ", Good Evening 🌙"
  else
    ret = "Hi " .. username .. ", it's getting late, get some sleep 😴"
  end
  return ret
end

local function footer()
  local stats = require("lazy").stats()

  local footer_datetime = os.date(" %m-%d-%Y   %H:%M:%S")
  local version = vim.version()
  local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
  local value = footer_datetime .. "   Plugins " .. stats.count .. nvim_version_info
  return value
end

local function dailyquotes()
  return vim.__tbl.unpack(require("ngpong.utils.quotes").random())
end

return {
  "folke/snacks.nvim",
  optional = true,
  opts = {
    dashboard = {
      enabled = false,
      width = 60,
      row = nil, -- dashboard position. nil for center
      col = nil, -- dashboard position. nil for center
      pane_gap = 4, -- empty columns between vertical panes
      autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
      -- These settings are used by some built-in sections
      preset = {
        -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
        ---@type fun(cmd:string, opts:table)|nil
        pick = nil,
        -- Used by the `keys` section to show keymaps.
        -- Set your custom keymaps here.
        -- When using a function, the `items` argument are the default keymaps.
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        -- Used by the `header` section
        header = [[
    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
      },
      -- item field formatters
      formats = {
        icon = function(item)
          if item.file and item.icon == "file" or item.icon == "directory" then
            return M.icon(item.file, item.icon)
          end
          return { item.icon, width = 2, hl = "icon" }
        end,
        footer = { "%s", align = "center" },
        header = { "%s", align = "center" },
        file = function(item, ctx)
          local fname = vim.fn.fnamemodify(item.file, ":~")
          fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
          if #fname > ctx.width then
            local dir = vim.fn.fnamemodify(fname, ":h")
            local file = vim.fn.fnamemodify(fname, ":t")
            if dir and file then
              file = file:sub(-(ctx.width - #dir - 2))
              fname = dir .. "/…" .. file
            end
          end
          local dir, file = fname:match("^(.*)/(.+)$")
          return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
        end,
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
      debug = false,
    },
  },
}
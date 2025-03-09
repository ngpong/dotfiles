-- local M = {}

-- -- stylua: ignore start
-- local Path        = require("plenary.path")
-- local Item        = vim.__lazy.require("trouble.item")
-- local Util        = vim.__lazy.require("trouble.util")
-- local Cache       = vim.__lazy.require("trouble.cache")
-- local Action      = vim.__lazy.require("telescope.actions")
-- local ActionState = vim.__lazy.require("telescope.actions.state")

-- local telescope = vim._plugins.telescope.api
-- local trouble   = vim._plugins.trouble.api
-- -- stylua: ignore end

-- M.config = {
--   modes = {
--     telescope = {
--       source = "telescope",
--       events = { "BufWritePost" },
--       sort = { "filename", "pos" },
--     },
--     telescope_multi_selected_files = {
--       desc = "Telescope multi-selected result",
--       mode = "telescope",
--       format = "{file_icon}{filename}",
--     },
--     telescope_multi_selected_lines = {
--       desc = "Telescope multi-selected result",
--       mode = "telescope",
--       groups = {
--         { "filename", format = "{file_icon} {filename} {count}" },
--       },
--       format = "{text:ts} {pos}",
--     },
--   },
-- }

-- local append_cache = function(mode, items)
--   local idx = Cache[mode].idx
--   local rel_datas = Cache[mode].rel_datas

--   if #rel_datas == 5 then
--     table.remove(rel_datas, 1)
--     idx = idx - 1
--   end

--   rel_datas[#rel_datas + 1] = items

--   Cache[mode].idx = idx + 1
--   Cache[mode].rel_datas = rel_datas
-- end

-- local get_cache = function(mode)
--   local items = {}

--   local idx = Cache[mode].idx
--   local rel_datas = Cache[mode].rel_datas

--   if not next(rel_datas) then
--     return items
--   end

--   local rel_data = rel_datas[idx]
--   for _, _item in ipairs(rel_data) do
--     local filename
--     if _item.path then
--       filename = _item.path
--     else
--       filename = _item.filename
--       if _item.cwd then
--         filename = _item.cwd .. "/" .. filename
--       end
--     end

--     if _item.text then
--       local new_text = vim.__fs.getline(_item.filename, _item.lnum)
--       if not new_text then
--         _item.invalid_pos = true
--       else
--         _item.text = new_text
--         _item.invalid_pos = false
--         _item[1] = _item.filename .. ":" .. _item.lnum .. ":" .. _item.col .. ":" .. _item.text
--       end
--     end

--     local word = _item.text and _item.col and _item.text:sub(_item.col):match("%S+")

--     local pos = _item.lnum and { _item.lnum, _item.col and _item.col - 1 or 0 } or nil

--     items[#items + 1] = Item.new({
--       buf = _item.bufnr,
--       pos = pos,
--       end_pos = word and pos and { pos[1], pos[2] + #word } or nil,
--       filename = filename,
--       item = _item,
--       source = "telescope",
--     })
--   end
--   rel_datas[idx] = rel_data

--   vim.__logger.info(Cache[mode])

--   return items
-- end

-- M.setup = function()
--   local ws_sha1 = vim.__path.cwdsha1()

--   for key, val in pairs(M.config.modes) do
--     if key == val.source then
--       goto continue
--     end

--     Cache[key].idx = 0
--     Cache[key].rel_datas = {}

--     local file = Path:new(string.format("%s%s%s%s", vim.__path.standard("data"), "/trouble_presist/", ws_sha1, ".json"))
--     if not file:exists() then
--       goto continue
--     end

--     file:read(function(data)
--       local result = vim.json.decode(data) or {} -- 这里不是 item

--       Cache[key].idx = result.idx
--       Cache[key].rel_datas = result.rel_datas

--       vim.__logger.info(Cache[key])
--     end)

--     ::continue::
--   end

--   M.setup = function() end
-- end

-- M.open = vim.__async.void(function(mode, prompt_bufnr)
--   M.setup()

--   vim.__logger.info("append cache")

--   local items = {}

--   local picker = ActionState.get_current_picker(prompt_bufnr)
--   if not picker then
--     return vim.__notifier.warn("No Telescope picker found.")
--   end

--   if #picker:get_multi_selection() <= 0 then
--     return vim.__notifier.warn("No Telescope selection result found.")
--   end

--   for _, _item in ipairs(picker:get_multi_selection()) do
--     items[#items+1] = _item
--   end

--   append_cache(mode, items)

--   vim.__async.scheduler()
--   -- vim.__async.sleep(1000)

--   telescope.close_telescope(prompt_bufnr)

--   trouble.open(mode)
-- end)

-- M.get = vim.__async.void(function(cb, ctx)
--   vim.__logger.info("get cache")

--   cb(get_cache(ctx.opts.mode))
-- end)

-- return M

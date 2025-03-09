local hl_cache = {}
local function hl_text(txt, hl)
  local _hl = hl
  if not _hl then
    return txt
  end

  if type(hl) == "table" then
    _hl = { "STL" }
    if hl.fg then
      table.insert(_hl, "fg" .. hl.fg)
    end
    if hl.bg then
      table.insert(_hl, "bg" .. hl.bg)
    end
    if hl.bold then
      table.insert(_hl, "bold")
    end
    if hl.italic then
      table.insert(_hl, "italic")
    end
    _hl = table.concat(_hl, "-"):gsub("#", "")

    if not hl_cache[_hl] then
      hl_cache[_hl] = true
      vim.api.nvim_set_hl(0, _hl, hl)
    end
  end

  return "%#" .. _hl .. "#" .. txt .. "%*"
end

local component = vim.__class.def(function(this)
  local function normalize_provider(provider)
    if type(provider) == "string" then
      return function(_)
        return provider, nil
      end
    elseif type(provider) == "table" then
      return function(_)
        return vim.__tbl.unpack(provider)
      end
    elseif type(provider) == "function" then
      return provider
    end
  end

  local function register_update(updater)
    local group = vim.__autocmd.augroup("stl-component-" .. this.id)

    local t = type(updater)

    if t == "string" and updater ~= "never" then
      group:on(updater, function() this.cache = nil end)
    elseif t == "table" then
      local sevents = {}
      local tevents = {}

      for _, e in ipairs(updater) do
        local te = type(e)

        if te == "string" then
          table.insert(sevents, e)
        elseif te == "table" then
          table.insert(tevents, e)
        end
      end

      if #sevents > 0 then
        group:on(sevents, function() this.cache = nil end)
      end

      for _, e in ipairs(tevents) do
        group:on(e[1], function() this.cache = nil end, { pattern = e.pattern })
      end
    end
  end

  function this:__init(args)
    this.id = args.id or vim._tool.uuid()

    this.cfg = args.cfg

    this.ready = args.ready

    this.rounded = args.rounded

    this.providers = {}
    for _, p in ipairs(args) do
      table.insert(this.providers, normalize_provider(p))
    end

    this.cache = nil
    this.update = args.update
    if this.update then
      register_update(this.update)
    end

    if args.init then
      args.init(this)
    end
  end

  function this:eval()
    if this.ready and not this.ready(this) then
      return
    end

    if this.cache then
      return this.cache
    end

    local res = {}

    local function format_provider_txt(...)
      local first = select(1, ...)
      if not first then
        return
      end

      if type(first) == "table" then -- { value, {hl} }, { value }, { value, {hl} }, ...
        local datas = { ... }

        for i = 1, select("#", ...) do
          table.insert(res, hl_text(table.unpack(datas[i])))
        end
      else                           -- value, { hl }
                                     -- value
        table.insert(res, hl_text(first, select(2, ...)))
      end
    end
    for _, p in ipairs(this.providers) do
      format_provider_txt(p(this))
    end

    local final = table.concat(res)

    if this.rounded and final ~= "" then
      final = (this.rounded.left or "") .. final .. (this.rounded.right or "")
    end

    if this.update then
      this.cache = final
    end

    return final
  end
end)

local components = {
  fill = component:new({
    id = "fill",
    update = "never",
    function()
      return "%="
    end
  }),
  mode = component:new({
    id = "mode",
    update = { "ModeChanged", "TermLeave", "TermEnter" },
    init = function()
      vim.api.nvim_set_hl(0, "STL-mode-none-1", { bg = vim.__color.bright_aqua, fg = vim.__color.dark0 })
      vim.api.nvim_set_hl(0, "STL-mode-none-2", { bg = vim.__color.bright_aqua, fg = vim.__color.dark0, italic = true, bold = true })
      vim.api.nvim_set_hl(0, "STL-mode-aqua-1", { bg = vim.__color.bright_aqua, fg = vim.__color.dark0 })
      vim.api.nvim_set_hl(0, "STL-mode-aqua-2", { bg = vim.__color.bright_aqua, fg = vim.__color.dark0, italic = true, bold = true })
      vim.api.nvim_set_hl(0, "STL-mode-blue-1", { bg = vim.__color.bright_blue, fg = vim.__color.dark0 })
      vim.api.nvim_set_hl(0, "STL-mode-blue-2", { bg = vim.__color.bright_blue, fg = vim.__color.dark0, italic = true, bold = true })
      vim.api.nvim_set_hl(0, "STL-mode-orange-1", { bg = vim.__color.bright_orange, fg = vim.__color.dark0 })
      vim.api.nvim_set_hl(0, "STL-mode-orange-2", { bg = vim.__color.bright_orange, fg = vim.__color.dark0, italic = true, bold = true })
      vim.api.nvim_set_hl(0, "STL-mode-red-1", { bg = vim.__color.bright_red, fg = vim.__color.dark0 })
      vim.api.nvim_set_hl(0, "STL-mode-red-2", { bg = vim.__color.bright_red, fg = vim.__color.dark0, italic = true, bold = true })
      vim.api.nvim_set_hl(0, "STL-mode-green-1", { bg = vim.__color.bright_green, fg = vim.__color.dark0 })
      vim.api.nvim_set_hl(0, "STL-mode-green-2", { bg = vim.__color.bright_green, fg = vim.__color.dark0, italic = true, bold = true })
      vim.api.nvim_set_hl(0, "STL-mode-yellow-1", { bg = vim.__color.bright_yellow, fg = vim.__color.dark0 })
      vim.api.nvim_set_hl(0, "STL-mode-yellow-2", { bg = vim.__color.bright_yellow, fg = vim.__color.dark0, italic = true, bold = true })
      vim.api.nvim_set_hl(0, "STL-mode-purple-1", { bg = vim.__color.bright_purple, fg = vim.__color.dark0 })
      vim.api.nvim_set_hl(0, "STL-mode-purple-2", { bg = vim.__color.bright_purple, fg = vim.__color.dark0, italic = true, bold = true })
    end,
    cfg = {
      names = {
        ["n"]     = "N",
        ["niI"]   = "I",
        ["niR"]   = "I",
        ["niV"]   = "I",
        ["nt"]    = "N",
        ["ntT"]   = "N",
        ["no"]    = "N",
        ["nov"]   = "N",
        ["noV"]   = "N",
        ["no\22"] = "N",
        ["v"]     = "V",
        ["vs"]    = "V",
        ["V"]     = "V",
        ["Vs"]    = "V",
        ["\22"]   = "V",
        ["\22s"]  = "V",
        ["s"]     = "S",
        ["S"]     = "S",
        ["\19"]   = "S",
        ["i"]     = "I",
        ["ic"]    = "I",
        ["ix"]    = "I",
        ["R"]     = "R",
        ["Rc"]    = "R",
        ["Rx"]    = "R",
        ["Rv"]    = "R",
        ["Rvc"]   = "R",
        ["Rvx"]   = "R",
        ["c"]     = "C",
        ["cr"]    = "C",
        ["cv"]    = "E",
        ["ce"]    = "E",
        ["cvr"]   = "E",
        ["r"]     = "P",
        ["rm"]    = "P",
        ["r?"]    = "?",
        ["!"]     = "!",
        ["t"]     = "T",
      },
      colors = {
        ["?"] = { "STL-mode-none-1"   , "STL-mode-none-2" },
        ["N"] = { "STL-mode-blue-1"   , "STL-mode-blue-2" },
        ["V"] = { "STL-mode-orange-1" , "STL-mode-orange-2" },
        ["I"] = { "STL-mode-red-1"    , "STL-mode-red-2" },
        ["C"] = { "STL-mode-green-1"  , "STL-mode-green-2" },
        ["T"] = { "STL-mode-yellow-1" , "STL-mode-yellow-2" },
        ["S"] = { "STL-mode-aqua-1" , "STL-mode-aqua-2" },
        ["R"] = { "STL-mode-purple-1" , "STL-mode-purple-2" },
      },
    },
    function(this)
      local cfg = this.cfg

      local mode_name = cfg.names[vim.fn.mode(1)] or "?"
      local mode_hl   = cfg.colors[mode_name]

      return hl_text(" 🦬 ", mode_hl[1]) ..
             hl_text(mode_name .. "  ", mode_hl[2])
    end
  }),
  cmd = component:new({
    id = "cmd",
    update = "never",
    function()
      vim.go.showcmd    = true
      vim.go.showcmdloc = "statusline"
      return hl_text("%S", { fg = vim.__color.dark3, italic = true, bold = true })
    end
  }),
  location = component:new({
    id = "location",
    update = "never",
    function()
      return hl_text(" ", { fg = vim.__color.bright_yellow }) .. "%l/%L:%c  " ..
             hl_text(" ", { fg = vim.__color.bright_aqua }) .. hl_text("%P ", { bold = true, italic = true })
    end
  }),
  encoding = component:new({
    id = "encoding",
    update = "BufEnter",
    cfg = {
      icon_txt = hl_text(vim.__icons.files_2, { fg = vim.__color.light4 })
    },
    rounded = { right = "  " },
    function(this)
      local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
      return this.cfg.icon_txt .. " " .. enc:lower()
    end,
  }),
  previewflg = component:new({
    id = "previewflg",
    rounded = { right = " " },
    update = { { "User", pattern = "UserPreview" }, "BufEnter" },
    cfg = {
      icon = hl_text(" ", { fg = vim.__color.bright_aqua }),
    },
    function(this)
      local ret = false

      if not ret and vim.__plugin.loaded("nvim-tree-preview.lua") then
        ret = require("nvim-tree-preview").is_open()
      end

      -- if not ret and vim.__plugin.loaded("xx") then
      --   -- ..
      -- end

      if ret then
        return this.cfg.icon
      end
    end,
  }),
  explorerflag = component:new({
    id = "explorerflag",
    rounded = { right = " " },
    update = { { "User", pattern = "NvimtreeToggleFilter" }, "BufEnter" },
    cfg = {
      enabled_icon = hl_text("󱨿 ", { fg = vim.__color.bright_green }),
      disable_icon = hl_text("󱓯 ", { fg = vim.__color.bright_red }),
      dotfiles = "ʰ",
      git_ignored = "ᵍ",
      no_bookmark = "ᵐ",
      no_buffer = "ᵇ",
    },
    function(this)
      local res = {}

      local cfg = this.cfg

      local ft = vim.__buf.filetype()
      if ft ~= "NvimTree" then
        return
      end

      if not vim.__plugin.loaded("nvim-tree.lua") then
        return
      end

      local explorer = require("nvim-tree.core").get_explorer()
      if not explorer then
        return
      end

      local filters = explorer.filters
      if not filters then
        return
      end
      if filters.enabled then
        table.insert(res, cfg.enabled_icon)
      else
        table.insert(res, cfg.disable_icon)
      end

      local state = filters.state
      if not state then
        return
      end
      if state.no_buffer then
        table.insert(res, cfg.no_buffer)
      end
      if state.dotfiles then
        table.insert(res, cfg.dotfiles)
      end
      if state.git_ignored then
        table.insert(res, cfg.git_ignored)
      end
      if state.no_bookmark then
        table.insert(res, cfg.no_bookmark)
      end

      if #res > 1 then
        return table.concat(res)
      end
    end,
  }),
  modifiable = component:new({
    id = "modifiable",
    rounded = { right = " " },
    update = { { "User", pattern = "LazyBufModifiedSet" }, "BufEnter" },
    cfg = {
      readyonly = hl_text("󱙑 ", { fg = vim.__color.bright_red }),
      unmodifiable = hl_text("󱙏 ", { fg = vim.__color.bright_yellow }),
    },
    function(this)
      local res = {}

      local cfg = this.cfg

      if vim.bo.readonly then
        table.insert(res, cfg.readyonly)
      end

      if not vim.bo.modifiable then
        table.insert(res, cfg.unmodifiable)
      end

      return table.concat(res)
    end,
  }),
  filetype = component:new({
    id = "filetype",
    update = { "BufEnter", "TermEnter" },
    rounded = { right = "  " },
    cfg = {
      override = {
        NvimTree = "explorer",
        lazy = "plugins",
      },
    },
    function(this)
      local ft = vim.__buf.filetype()
      if not ft or ft == "" then
        return
      end

      local icon, hl = vim.__icons.get_icon_color_by_ft(ft)
      return hl_text(icon, hl) .. " " .. string.lower(this.cfg.override[ft] or ft)
    end,
  }),
  os = component:new({
    id = "os",
    update = "never",
    rounded = { right = "  " },
    function()
      local os_name = vim.__util.get_os()
      if not os_name or os_name == "" then
        return
      end

      local iinfo = vim.__webicons.get_icons_by_operating_system()[os_name]
      return { iinfo.icon .. " ", { fg = iinfo.color } }, { os_name }
    end,
  }),
  search = component:new({
    id = "search",
    cfg = {
      icon_txt = hl_text(" ", { fg = vim.__color.bright_blue })
    },
    rounded = { right = "  " },
    ready = function()
      return vim.v.hlsearch > 0 and vim.fn.getreg("/") ~= ""
    end,
    function(this)
      local sinfo = vim.fn.searchcount({ maxcount = 0 })
      local search_stat = sinfo.incomplete > 0 and "?/?" or sinfo.total > 0 and ("%s/%s"):format(sinfo.current, sinfo.total) or "0/0"

      return this.cfg.icon_txt .. search_stat
    end,
  }),
  lsp = component:new({
    id = "lsp",
    update = { "LspAttach", "LspDetach", "BufEnter" },
    cfg = {
      icon_txt = hl_text(vim.__icons.activelsp, { fg = vim.__color.bright_blue }),
    },
    rounded = { left = "  " },
    function(this)
      local success, clis = pcall(vim.lsp.get_clients, { bufnr = vim.g._actual_curbuf })
      return (success and next(clis)) and this.cfg.icon_txt .. " " .. clis[1].name:gsub("_", "")
    end
  }),
  diagnostic = component:new({
    id = "diagnostics",
    update = { "DiagnosticChanged", "BufEnter" },
    rounded = { left = "  " },
    function()
      local ret = {}
      local size = 0

      local bufnr = vim.g._actual_curbuf

      local diagnostics = vim.diagnostic.count(bufnr)

      local info_count = diagnostics[3] or 0
      if info_count > 0 then
        ret[size + 1] = hl_text(vim.__icons.diagnostic_info .. " " .. info_count, "DiagnosticInfo")
        size = size + 1
      end

      local hint_count = diagnostics[4] or 0
      if hint_count > 0 then
        ret[size + 1] = hl_text(vim.__icons.diagnostic_hint .. " " .. hint_count, "DiagnosticHint")
        size = size + 1
      end

      local warn_count = diagnostics[2] or 0
      if warn_count > 0 then
        ret[size + 1] = hl_text(vim.__icons.diagnostic_warn .. " " .. warn_count, "DiagnosticWarn")
        size = size + 1
      end

      local error_count = diagnostics[1] or 0
      if error_count > 0 then
        ret[size + 1] = hl_text(vim.__icons.diagnostic_err .. " " .. error_count, "DiagnosticError")
        size = size + 1
      end

      return size > 0 and table.concat(ret, " ")
    end
  }),
  git_branch = component:new({
    id = "git_branch",
    update = { { "User", pattern = "GitSignsAttached" }, "BufEnter" },
    cfg = {
      icon_txt = hl_text(vim.__icons.git_2, { fg = vim.__color.bright_purple }),
    },
    rounded = { left = "  " },
    function(this)
      local head = vim.b.gitsigns_head
      return head and this.cfg.icon_txt .. " " .. hl_text(head, { bold = true })
    end
  }),
  git_diff = component:new({
    id = "git_diff",
    update = { { "User", pattern = "GitSignsUpdate" }, "BufEnter" },
    rounded = { left = "  " },
    function()
      local ret = {}
      local size = 0

      local status_dict = vim.b.gitsigns_status_dict
      if not status_dict then
        return
      end

      local added_count = status_dict.added or 0
      if added_count > 0 then
        ret[size + 1] = hl_text(vim.__icons.git_add .. " " .. added_count, "GitSignsAdd")
        size = size + 1
      end

      local changed_count = status_dict.changed or 0
      if changed_count > 0 then
        ret[size + 1] = hl_text(vim.__icons.git_add .. " " .. changed_count, "GitSignsChange")
        size = size + 1
      end

      local removed_count = status_dict.removed or 0
      if removed_count > 0 then
        ret[size + 1] = hl_text(vim.__icons.git_add .. " " .. removed_count, "GitSignsDelete")
        size = size + 1
      end

      return size > 0 and table.concat(ret, " ")
    end
  })
}

-- 初始化高亮
vim.api.nvim_set_hl(0, "StatusLine", { bg = vim.__color.dark1 })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = vim.__color.dark1 })
vim.api.nvim_set_hl(0, "StatusLineTermNC", { bg = vim.__color.dark1 })

-- 提示信息相关的设置
vim.opt.shortmess:append("S") -- S	do not show search count message when searching, e.g.	"[1/5]"
vim.opt.shortmess:append("o") -- o	overwrite message for writing a file with subsequent message for reading a file (useful for ":wn" or when "autowrite" on)
vim.opt.shortmess:append("O") -- O	message for reading a file overwrites any previous message; also for quickfix message (e.g., ":cn")
vim.opt.shortmess:append("s") -- s	don"t give "search hit BOTTOM, continuing at TOP" or "search hit TOP, continuing at BOTTOM" messages; when using the search count do not show "W" after the count message (see S below)
vim.opt.shortmess:append("c") -- c	don"t give ins-completion-menu messages; for example, "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found", "Back at original", etc.
vim.opt.shortmess:append("F") -- F	don"t give the file info when editing a file, like :silent was used for the command

-- 不显示当前的输入模式(左下角)
vim.go.showmode = false

-- 控制状态行显示位置；2：全部，3：当前
vim.go.laststatus = 3

-- 不显示当前输入的命令(右下角)
-- 暂时禁用它，不然在移动(从下往上一直按p移动)的时候会有一些鼠标乱飘的bug
vim.go.showcmd = true

-- 控制命令行的高度(最后一行)
vim.go.cmdheight = 1

-- statusline
vim.o.statusline = "%{%v:lua.require'ngpong.core.statusline'.eval()%}"

local normal = {
  components.mode,
  components.git_branch,
  components.lsp,
  components.git_diff,
  components.diagnostic,
  components.fill,
  -- components.cmd,
  -- components.fill,
  components.modifiable,
  components.search,
  components.os,
  components.encoding,
  components.filetype,
  components.location,
}

local special = {
  components.mode,
  components.fill,
  -- components.cmd,
  -- components.fill,
  components.previewflg,
  components.explorerflag,
  components.modifiable,
  components.search,
  components.os,
  components.filetype,
  components.location,
}

local stl_group, forced = {}, false

local function new_stl(bufnr)
  local ft = vim.__buf.filetype(bufnr)
  local bt = vim.__buf.buftype(bufnr)

  local stl = {
    components = (vim.__filter.contain_fts(ft) or vim.__filter.contain_bts(bt)) and special or normal,
    timer = vim.loop.new_timer(),
  }
  stl_group[bufnr] = stl

  return stl
end

vim.__event.rg(vim.__event.types.FILE_TYPE, function(state)
  new_stl(state.buf)
end)

vim.__event.rg(vim.__event.types.BUFFER_DELETE, function(state)
  local stl = stl_group[state.buf]
  if not stl then
    return
  end

  stl.timer:stop()
  stl.timer:close()

  stl_group[state.buf] = nil
end)

-- constant updater
vim.uv.new_timer():start(500, 500, vim.schedule_wrap(function()
  vim.__stl.redraw()
end))

return {
  redraw = function(_force)
    if _force then
      forced = true
    end
    vim.cmd.redraws()
  end,
  eval = function()
    local bufnr = tonumber(vim.g.actual_curbuf) or vim.__buf.current()
    vim.g._actual_curbuf = bufnr

    local stl = stl_group[bufnr] or new_stl(bufnr)

    if stl.cache then
      if forced then
        stl.timer:stop()
      else
        return stl.cache
      end
    end
    forced = false

    local val = ""
    for _, c in ipairs(stl.components) do
      local r = c:eval()
      if r and r ~= "" then
        val = val .. r
      end
    end

    stl.cache = val
    stl.timer:start(5, 0, function()
      stl.cache = nil
      stl.timer:stop()
    end)

    return val
  end
}
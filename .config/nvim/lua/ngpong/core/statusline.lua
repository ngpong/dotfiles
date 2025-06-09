local Highlighter = vim.__class.def(function(this)
  local m_cache = {}

  local function cvrt(hl)
    local _hl = hl
    if hl then
      if type(hl) == "table" then
        _hl = { "WBR" }
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

        if not m_cache[_hl] then
          m_cache[_hl] = true
          vim.api.nvim_set_hl(0, _hl, hl)
        end
      end
    end

    return _hl
  end

  function this:draw_fmt(txt, hl)
    if not hl then
      return txt
    end
    return "%%#" .. cvrt(hl) .. "#" .. txt .. "%%*"
  end

  function this:draw(txt, hl)
    if not hl then
      return txt
    end
    return "%#" .. cvrt(hl) .. "#" .. txt .. "%*"
  end
end):new()

local Component = vim.__class.def(function(this)
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

  function this:eval(bufnr)
    if this.ready and not this.ready(this, bufnr) then
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
          table.insert(res, Highlighter:draw(table.unpack(datas[i])))
        end
      else                           -- value, { hl }
                                     -- value
        table.insert(res, Highlighter:draw(first, select(2, ...)))
      end
    end
    for _, p in ipairs(this.providers) do
      format_provider_txt(p(this, bufnr))
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

local Components = {
  fill = Component:new({
    id = "fill",
    update = "never",
    function()
      return "%="
    end
  }),
  mode = Component:new({
    id = "mode",
    update = {
      "ModeChanged",
      "TermLeave",
      "TermEnter",
      "CmdlineEnter",
      "CmdlineLeave",
      { "User", pattern = "PickerOnShow" },
      { "User", pattern = "PickerOnClose" }
    },
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
    function(this, _)
      local cfg = this.cfg

      local mode_name = cfg.names[vim.fn.mode(1)] or "?"
      local mode_hl   = cfg.colors[mode_name]

      return Highlighter:draw(" 🦬 ", mode_hl[1]) ..
             Highlighter:draw(mode_name .. "  ", mode_hl[2])
    end
  }),
  cmd = Component:new({
    id = "cmd",
    update = "never",
    function(_, _)
      vim.go.showcmd    = true
      vim.go.showcmdloc = "statusline"
      return Highlighter:draw("%S", { fg = vim.__color.dark3, italic = true, bold = true })
    end
  }),
  location = Component:new({
    id = "location",
    update = "never",
    function(_, _)
      return Highlighter:draw(" ", { fg = vim.__color.bright_yellow }) .. "%l/%L:%c  " ..
             Highlighter:draw(" ", { fg = vim.__color.bright_aqua }) .. Highlighter:draw("%P ", { bold = true, italic = true })
    end
  }),
  encoding = Component:new({
    id = "encoding",
    update = "BufEnter",
    cfg = {
      icontxt = Highlighter:draw(vim.__icons.files_2, { fg = vim.__color.light4 }),
      alias = {
        ["utf-8"] = "utf8",
      },
    },
    rounded = { right = "  " },
    function(this, bufnr)
      local fencoding = vim.bo[bufnr].fenc
      fencoding = (fencoding ~= "" and fencoding or vim.o.enc):lower()
      fencoding = this.cfg.alias[fencoding] or fencoding

      return this.cfg.icontxt .. " " .. fencoding
    end,
  }),
  modifiable = Component:new({
    id = "modifiable",
    rounded = { right = " " },
    update = { { "User", pattern = "UserBufModifiedSet" }, "BufEnter" },
    cfg = {
      readyonly = Highlighter:draw("󱙑 ", { fg = vim.__color.bright_red }),
      unmodifiable = Highlighter:draw("󱙏 ", { fg = vim.__color.bright_yellow }),
    },
    function(this, bufnr)
      local ret = {}

      local bopts = vim.bo[bufnr]

      if bopts.readonly then
        table.insert(ret, this.cfg.readyonly)
      end

      if not bopts.modifiable then
        table.insert(ret, this.cfg.unmodifiable)
      end

      return table.concat(ret)
    end,
  }),
  filetype = Component:new({
    id = "filetype",
    update = { "BufEnter", "TermEnter" },
    rounded = { right = "  " },
    cfg = {
      alias = {
        NvimTree = "explorer",
        lazy = "plugins",
        snacks_picker_input = "picker",
        snacks_picker_list = "picker",
        snacks_picker_preview = "picker",
      },
    },
    function(this, bufnr)
      local ft = vim.__buf.filetype(bufnr)
      if not ft or ft == "" then
        return
      end

      local icon, hl = vim.__icons.get_icon_color_by_ft(ft)
      local text
      -- if ft == "trouble" then
      --   local view = vim.__trouble:find_view({ bufnr = bufnr })
      --   text = string.format("%s(%s)", ft, view.opts.mode)
      -- else
        text = this.cfg.alias[ft] or string.lower(ft)
      -- end

      return Highlighter:draw(icon .. " ", hl) .. text
    end,
  }),
  os = Component:new({
    id = "os",
    update = "never",
    rounded = { right = "  " },
    function(_, _)
      local os_name = vim.__util.get_os()
      if not os_name or os_name == "" then
        return
      end

      local iinfo = vim.__webicons.get_icons_by_operating_system()[os_name]
      return { iinfo.icon .. " ", { fg = iinfo.color } }, { os_name }
    end,
  }),
  multicursor = Component:new({
    id = "multicursor",
    ready = function(this, _)
      local cfg = this.cfg

      if not cfg.is_loaded then
        if vim.__plugin.loaded("multicursor.nvim") then
          cfg.is_loaded = true
          cfg.package_mc_manager = require("multicursor-nvim.cursor-manager")
        else
          return false
        end
      end

      return cfg.package_mc_manager:hasCursors()
    end,
    cfg = {
      locked = Highlighter:draw(vim.__icons.cursor_2 .. " ", { fg = vim.__color.bright_yellow }),
      unlocked = Highlighter:draw(vim.__icons.cursor_2 .. " ", { fg = vim.__color.bright_red }),
    },
    rounded = { right = "  " },
    function(this, _)
      local cfg = this.cfg

      local mc_manager = cfg.package_mc_manager

      local icon
      if mc_manager:cursorsEnabled() then
        icon = cfg.locked
      else
        icon = cfg.unlocked
      end

      local num_cursor = mc_manager:numCursors() or 0

      return icon .. num_cursor
    end,
  }),
  bookmark = Component:new({
    id = "bookmark",
    update = { { "User", pattern = "BookmarkCountChanged" }, "BufEnter" },
    cfg = {
      icon = Highlighter:draw(vim.__icons.bookmark .. " ", { fg = vim.__color.bright_red }),
    },
    rounded = { right = "  " },
    function(this, bufnr)
      local bmcount = vim.__bookmark:get_bmcount(bufnr)
      if bmcount == 0 then return end

      return this.cfg.icon .. bmcount
    end,
  }),
  search = Component:new({
    id = "search",
    cfg = {
      icontxt = Highlighter:draw(" ", { fg = vim.__color.bright_blue })
    },
    rounded = { right = "  " },
    ready = function()
      return vim.v.hlsearch > 0 and vim.fn.getreg("/") ~= ""
    end,
    function(this, _)
      local ok, sinfo = pcall(vim.fn.searchcount, { maxcount = 0 })
      if ok then
        local search_stat = sinfo.incomplete > 0 and "?/?" or sinfo.total > 0 and ("%s/%s"):format(sinfo.current, sinfo.total) or "0/0"
        return this.cfg.icontxt .. search_stat
      end
    end,
  }),
  lsp = Component:new({
    id = "lsp",
    update = { "LspAttach", "LspDetach", "BufEnter" },
    cfg = {
      icontxt = Highlighter:draw(vim.__icons.activelsp .. " ", { fg = vim.__color.bright_blue }),
      severname_fmtd = Highlighter:draw_fmt("%s", { bold = true, italic = true }),
    },
    rounded = { left = "  " },
    function(this, bufnr)
      local success, clis = pcall(vim.lsp.get_clients, { bufnr = bufnr })
      if success and next(clis) then
        return this.cfg.icontxt .. string.format(this.cfg.severname_fmtd, clis[1].name:gsub("_", ""))
      end
    end
  }),
  diagnostic = Component:new({
    id = "diagnostics",
    update = { "DiagnosticChanged", "BufEnter" },
    cfg = {
      info_fmtd = Highlighter:draw_fmt(vim.__icons.diagnostic_info .. " %d", "DiagnosticInfo"),
      hint_fmtd = Highlighter:draw_fmt(vim.__icons.diagnostic_hint .. " %d", "DiagnosticHint"),
      err_fmtd = Highlighter:draw_fmt(vim.__icons.diagnostic_error .. " %d", "DiagnosticError"),
      warn_fmtd = Highlighter:draw_fmt(vim.__icons.diagnostic_warn .. " %d", "DiagnosticWarn"),
    },
    rounded = { left = "  " },
    function(this, bufnr)
      local ret = {}

      local diagnostics = vim.diagnostic.count(bufnr)

      local info_count = diagnostics[3] or 0
      if info_count > 0 then
        table.insert(ret, string.format(this.cfg.info_fmtd, info_count))
      end

      local hint_count = diagnostics[4] or 0
      if hint_count > 0 then
        table.insert(ret, string.format(this.cfg.hint_fmtd, hint_count))
      end

      local warn_count = diagnostics[2] or 0
      if warn_count > 0 then
        table.insert(ret, string.format(this.cfg.warn_fmtd, warn_count))
      end

      local error_count = diagnostics[1] or 0
      if error_count > 0 then
        table.insert(ret, string.format(this.cfg.err_fmtd, error_count))
      end

      if next(ret) then
        return table.concat(ret, " ")
      end
    end
  }),
  git_branch = Component:new({
    id = "git_branch",
    update = { { "User", pattern = "GitSignsAttached" }, "BufEnter" },
    cfg = {
      icontxt = Highlighter:draw(vim.__icons.git_2, { fg = vim.__color.bright_purple }),
    },
    rounded = { left = "  " },
    function(this, bufnr)
      local head = vim.b[bufnr].gitsigns_head
      return head and this.cfg.icontxt .. " " .. head
    end
  }),
  git_diff = Component:new({
    id = "git_diff",
    update = { { "User", pattern = "GitSignsUpdate" }, "BufEnter" },
    cfg = {
      added_fmtd = Highlighter:draw_fmt(vim.__icons.git_add .. " %d", "GitSignsAdd"),
      changed_fmtd = Highlighter:draw_fmt(vim.__icons.git_change .. " %d", "GitSignsChange"),
      removed_fmtd = Highlighter:draw_fmt(vim.__icons.git_delete .. " %d", "GitSignsDelete"),
    },
    rounded = { left = "  " },
    function(this, bufnr)
      local ret = {}

      local status_dict = vim.b[bufnr].gitsigns_status_dict
      if not status_dict then
        return
      end

      local added_count = status_dict.added or 0
      if added_count > 0 then
        table.insert(ret, string.format(this.cfg.added_fmtd, added_count))
      end

      local changed_count = status_dict.changed or 0
      if changed_count > 0 then
        table.insert(ret, string.format(this.cfg.changed_fmtd, changed_count))
      end

      local removed_count = status_dict.removed or 0
      if removed_count > 0 then
        table.insert(ret, string.format(this.cfg.removed_fmtd, removed_count))
      end

      if next(ret) then
        return table.concat(ret, " ")
      end
    end
  })
}

local Statusline = vim.__class.def(function(this)
  local m_compgroup = {
    normal = {
      Components.mode,
      Components.git_branch,
      Components.lsp,
      Components.git_diff,
      Components.diagnostic,
      Components.fill,
      -- Components.cmd,
      -- Components.fill,
      Components.modifiable,
      Components.bookmark,
      Components.multicursor,
      Components.search,
      Components.os,
      Components.encoding,
      Components.filetype,
      Components.location,
    },
    special = {
      Components.mode,
      Components.fill,
      Components.modifiable,
      Components.search,
      Components.os,
      Components.filetype,
      Components.location,
    },
    unknown = {
      Components.mode,
      Components.fill,
      Components.modifiable,
      Components.search,
      Components.os,
      Components.location,
    }
  }
  local m_caches = {
    unknown = m_compgroup.unknown
  }
  local function get_components(ft)
    return vim.__filter.contain_fts(ft) and m_compgroup.special or m_compgroup.normal
  end

  function this:__init()
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
    vim.g.qf_disable_statusline = 1

    -- updater
    vim.uv.new_timer():start(1000, 1000, vim.schedule_wrap(function()
      this:redraw()
    end))
    vim.__autocmd.on("BufDelete", function(state)
      m_caches[state.buf] = nil
    end)
    -- HACK:
    -- 未知原因（怀疑是 neovim 本身的问题），导致在 Insert 模式下移动光标至
    -- Indent-line 时会消失，必须要强制刷新才可以解决这个问题。
    --
    -- 这种情况仅会在 statusline 是一个 eval 函数的时候才会出现。如果是给定
    -- 一个已经计算出的结果则不会出现这个问题，但是这样的话就需要自己手动管
    -- 理 redraw 的时机，这是十分难以控制的。
    vim.__autocmd.on("CursorMovedI", function()
      this:redraw()
    end)
    vim.__autocmd.on("ModeChanged", function ()
      this:redraw()
    end, { pattern = "n:i" })
  end

  function this:debug()
    return m_caches
  end

  function this:redraw()
    vim.cmd.redraws()
  end

  function this:eval()
    local bufnr = tonumber(vim.g.actual_curbuf) or vim.__buf.current()

    local cs = m_caches[bufnr]
    if not cs then
      local ft = vim.__buf.filetype(bufnr)
      if not vim.__util.isempty(ft) then
        cs = get_components(ft)
        m_caches[bufnr] = cs
      else
        cs = m_caches["unknown"]
      end
    end

    local evalstrs = {}
    for _, c in ipairs(cs) do
      local str0 = c:eval(bufnr)
      if str0 and str0 ~= "" then
        table.insert(evalstrs, str0)
      end
    end

    return table.concat(evalstrs)
  end
end)

local stl = Statusline:new()
return {
  redraw = function() return stl:redraw() end,
  eval = function() return stl:eval() end
}

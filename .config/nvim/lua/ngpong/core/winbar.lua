local Options = {
  extend = "…",
  separator = " ",
  separator_width = vim.__str.displaywidth(" "),
  eval_interval = 40,
  lsp = {
    retry_ttl = 60,
    retry_interval = 200,
    update_interval = 300,
    eval_interval = 40,
    lsp_kinds = {
      [1]  = vim.__icons.lsp_kinds.File,
      [2]  = vim.__icons.lsp_kinds.Module,
      [3]  = vim.__icons.lsp_kinds.Namespace,
      [4]  = vim.__icons.lsp_kinds.Package,
      [5]  = vim.__icons.lsp_kinds.Class,
      [6]  = vim.__icons.lsp_kinds.Method,
      [7]  = vim.__icons.lsp_kinds.Property,
      [8]  = vim.__icons.lsp_kinds.Field,
      [9]  = vim.__icons.lsp_kinds.Constructor,
      [10] = vim.__icons.lsp_kinds.Enum,
      [11] = vim.__icons.lsp_kinds.Interface,
      [12] = vim.__icons.lsp_kinds.Function,
      [13] = vim.__icons.lsp_kinds.Variable,
      [14] = vim.__icons.lsp_kinds.Constant,
      [15] = vim.__icons.lsp_kinds.String,
      [16] = vim.__icons.lsp_kinds.Number,
      [17] = vim.__icons.lsp_kinds.Boolean,
      [18] = vim.__icons.lsp_kinds.Array,
      [19] = vim.__icons.lsp_kinds.Object,
      [20] = vim.__icons.lsp_kinds.Keyword,
      [21] = vim.__icons.lsp_kinds.Null,
      [22] = vim.__icons.lsp_kinds.EnumMember,
      [23] = vim.__icons.lsp_kinds.Struct,
      [24] = vim.__icons.lsp_kinds.Event,
      [25] = vim.__icons.lsp_kinds.Operator,
      [26] = vim.__icons.lsp_kinds.TypeParameter,
    },
  }
}

local Highlighter = vim.__class.def(function(this)
  local m_cache = {}
  function this:text(txt, hl)
    local _hl = hl
    if not _hl then
      return txt
    end

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

    return "%#" .. _hl .. "#" .. txt .. "%*"
  end
end):new()

local Item = vim.__class.def(function(this)
  local m_name, m_icon, m_iconhl
  function this:__init(_name, _icon, _iconhl)
    assert(_name and _icon and _iconhl)
    m_name   = _name
    m_icon   = _icon
    m_iconhl = _iconhl
  end

  local __eval
  function this:eval()
    __eval = string.format("%s %s", this:icon(), this:name())
    function this:eval()
      return __eval
    end
    return this:eval()
  end

  local __width
  function this:width()
    __width = vim.__str.displaywidth(string.format("%s %s", this:pale_icon(), this:name()))
    function this:width()
      return __width
    end
    return this:width()
  end

  function this:name()
    return m_name
  end

  local __namewidth
  function this:namewidth()
    __namewidth = vim.__str.displaywidth(this:name())
    function this:namewidth()
      return __namewidth
    end
    return this:namewidth()
  end

  local __icon
  function this:icon()
    __icon = Highlighter:text(m_icon, m_iconhl)
    function this:icon()
      return __icon
    end
    return this:icon()
  end

  function this:pale_icon()
    return m_icon
  end

  local __truncate = {}
  function this:truncate(len)
    local t = __truncate[len]
    if not t then
      t = {}

      local ___name
      function t:name()
        ___name = this:name():sub(1, len) .. Options.extend
        function t:name()
          return ___name
        end
        return t:name()
      end

      local ___namewidth
      function t:namewidth()
        ___namewidth = vim.__str.displaywidth(t:name())
        function t:namewidth()
          return ___namewidth
        end
        return t:namewidth()
      end

      local ___eval
      function t:eval()
        ___eval = string.format("%s %s", this:icon(), t:name())
        function t:eval()
          return ___eval
        end
        return t:eval()
      end

      local ___width
      function t:width()
        ___width = vim.__str.displaywidth(string.format("%s %s", this:pale_icon(), t:name()))
        function t:width()
          return ___width
        end
        return t:width()
      end

      __truncate[len] = t
    end
    return t
  end
end)

local LspSymbol = vim.__class.def(function(this)
  local strbuffer = require("string.buffer")
  local bit       = require("bit")
  local uv        = vim.loop

  local m_attachstat
  local m_items, m_item_cache = {}, setmetatable({}, {
    __index = function(self, k)
      self[k] = {}
      return self[k]
    end,
  })

  local m_updating = {}
  local m_symbols = {}

  local m_lsp_options = Options.lsp

  function this:__init(attachstat)
    m_attachstat = attachstat

    vim.__autocmd.on("BufWipeout", function(state)
      local bufnr = state.buf

      m_items[bufnr] = nil
      m_updating[bufnr] = nil
      m_symbols[bufnr] = nil
    end)
  end

  local __update, __update_retry, __update_bounce
  local __update_leagcy_worker, __update_leagcy_worker_libs
  __update_bounce = vim.__bouncer.throttle_trailing(
    m_lsp_options.update_interval,
    true,
    vim.schedule_wrap(function(...) __update(...) end)
  )
  __update_retry = function(bufnr, ttl)
    ttl = ttl or m_lsp_options.retry_ttl
    vim.defer_fn(function() __update(bufnr, ttl - 1) end, m_lsp_options.retry_interval)
  end
  __update_leagcy_worker_libs = string.dump(function()
    return require("string.buffer"), require("ngpong.utils.tbl")
  end)
  __update_leagcy_worker = uv.new_work(
    function(bufnr, symbols_bc, libs_bc)
      local libs = loadstring(libs_bc)
      local strbuffer, tbl = libs()

      local symbols = strbuffer.decode(symbols_bc)

      local function compare_f(lhs, rhs)
        local l_range = lhs.location.range
        local r_range = rhs.location.range

        if l_range.start.line < r_range.start.line then
          return true
        elseif l_range.start.line == r_range.start.line then
          if l_range.start.character < r_range.start.character then
            return true
          elseif l_range.start.character == r_range.start.character then
            if l_range["end"].line < r_range["end"].line then
              return true
            elseif l_range["end"].line == r_range["end"].line then
              return l_range["end"].character < r_range["end"].character
            else
              return false
            end
          else
            return false
          end
        else
          return false
        end
      end
      table.sort(symbols, compare_f)

      local search, childs = setmetatable({}, {
        __index = function(self, k)
          self[k] = {}
          return self[k]
        end,
      }), {}
      tbl.remove_iter(symbols, function(t, i)
        local sym = t[i]
        sym.range = sym.location.range
        sym.location = nil

        table.insert(search[sym.name], sym)

        if sym.containerName then
          table.insert(childs, sym)
          return false
        end

        return true
      end)

      local function range_contain(range1, range2)
        local range1_start, range1_ended = range1["start"], range1["end"]
        local range2_start, range2_ended = range2["start"], range2["end"]

        return
          (range2_start.line > range1_start.line or
          (range2_start.line == range1_start.line and range2_start.character > range1_start.character))
          and
          (range2_start.line < range1_ended.line or
          (range2_start.line == range1_ended.line and range2_start.character < range1_ended.character))
          and
          (range2_ended.line > range1_start.line or
          (range2_ended.line == range1_start.line and range2_ended.character > range1_start.character))
          and
          (range2_ended.line < range1_ended.line or
          (range2_ended.line == range1_ended.line and range2_ended.character < range1_ended.character))
      end
      for _, child in ipairs(childs) do
        for _, parent in ipairs(search[child.containerName]) do
          local range_parent = parent.range
          local range_child  = child.range

          if range_contain(range_parent, range_child) then
            if not parent.children then
              local children = {}
              parent.children = children
            end
            table.insert(parent.children, child)
          end
        end
        child.containerName = nil
      end

      return bufnr, strbuffer.encode(symbols)
    end,
    function(bufnr, symbols_bc)
      local symbols = strbuffer.decode(symbols_bc)
      m_symbols[bufnr] = symbols
      m_updating[bufnr] = nil
    end
  )
  __update = function(bufnr, ttl)
    if not vim.__buf.is_valid(bufnr) then
      return
    end

    if not ttl and m_updating[bufnr] then
      return
    end

    if ttl and ttl <= 0 then
      m_updating[bufnr] = nil
      return
    end

    m_updating[bufnr] = true

    local stat = m_attachstat[bufnr]
    if not stat then
      __update_retry(bufnr, ttl)
      return
    end

    stat.client:request(
      "textDocument/documentSymbol",
      {
        textDocument = {
          uri = vim.uri_from_bufnr(bufnr)
        }
      },
      function(err, symbols, _)
        if not vim.__buf.is_valid(bufnr) then
          return
        end

        if
          err or
          not m_attachstat[bufnr] or
          not symbols or
          not symbols[1]
        then
          __update_retry(bufnr, ttl)
          return
        end

        if (symbols[1] and symbols[1].range) or not symbols[1] then
          m_symbols[bufnr] = symbols
          m_updating[bufnr] = nil
        else
          __update_leagcy_worker:queue(
            bufnr,
            strbuffer.encode(symbols),
            __update_leagcy_worker_libs
          )
        end
      end,
      bufnr
    )
  end
  function this:update(bufnr)
    __update_bounce(bufnr)
  end


  local __eval, __eval_bounce
  __eval_bounce = vim.__bouncer.throttle_trailing(
    m_lsp_options.eval_interval,
    true,
    vim.schedule_wrap(function(...) __eval(...) end)
  )
  __eval = function(bufnr, cursor, symbols, items)
    if not symbols then
      symbols = m_symbols[bufnr] or {}
    end

    if not items then
      items = {} m_items[bufnr] = items
    end

    local len = #symbols
    if len == 0 then
      return
    end

    local lnum, col = cursor[1], cursor[2]
    local lsp_kinds = m_lsp_options.lsp_kinds

    local low, high = 1, len
    while low <= high do
      local mid = bit.rshift(low + high, 1)

      local symbol = symbols[mid]

      local range = symbol.range
      local range_start = range["start"]
      local range_ended = range["end"]

      if
        (
          lnum > range_start.line or
          (lnum == range_start.line and col >= range_start.character)
        )
        and
        (
          lnum < range_ended.line or
          (lnum == range_ended.line and col <= range_ended.character)
        )
      then
        local kind = symbol.kind
        local name = symbol.name

        local item = m_item_cache[kind][name]
        if not item then
          local k = lsp_kinds[kind]
          item = Item:new(name, k.val, k.hl)

          m_item_cache[kind][name] = item
        end

        table.insert(items, item)
        if symbol.children then
          __eval(bufnr, cursor, symbol.children, items)
        end

        return
      elseif
        (
          lnum < range_start.line or
          (lnum == range_start.line and col < range_start.character)
        )
        and
        (
          lnum < range_ended.line or
          (lnum == range_ended.line and col < range_ended.character)
        )
      then
        high = mid - 1
      elseif
        (
          lnum > range_start.line or
          (lnum == range_start.line and col > range_start.character)
        )
        and
        (
          lnum > range_ended.line or
          (lnum == range_ended.line and col > range_ended.character)
        )
      then
        low = mid + 1
      else
        return
      end
    end
  end
  function this:eval(bufnr, cursor)
    cursor = { cursor[1] - 1, cursor[2] }
    __eval(bufnr, cursor)
    return m_items[bufnr]
  end
end)

local LspSource = vim.__class.def(function(this)
  local m_attachstat, m_symbol = {}, {}
  function this:__init()
    local function attach(bufnr, client_id)
      local cli = vim.lsp.get_client_by_id(client_id)
      if not cli or not cli:supports_method("textDocument/documentSymbol") then
        return
      end

      if m_attachstat[bufnr] then
        return
      end

      m_symbol:update(bufnr)

      local group = vim.__autocmd.augroup("wb-lspsource-" .. tostring(bufnr))
      group:on(
        { "BufWritePost", "TextChanged" },
        function(state)
          m_symbol:update(state.buf)
        end,
        { buffer = bufnr }
      )
      group:on(
        { "ModeChanged" },
        function(state)
          if state.match == "i:n" then
            m_symbol:update(state.buf)
          end
        end,
        { buffer = bufnr }
      )

      m_attachstat[bufnr] = {
        augroup = group,
        client = cli,
        bufnr = bufnr
      }
    end

    local function detach(bufnr, client_id)
      if not m_attachstat[bufnr] then
        return
      end

      m_attachstat[bufnr].augroup:del()
      m_attachstat[bufnr] = nil
    end

    m_symbol = LspSymbol:new(m_attachstat)

    vim.__autocmd.on("LspAttach", function(state)
      attach(state.buf, state.data.client_id)
    end)

    vim.__autocmd.on("LspDetach", function(state)
      detach(state.buf, state.data.client_id)
    end)
  end

  function this:eval(winid, bufnr)
    return m_symbol:eval(bufnr, vim.__cursor.norm_get())
  end
end)

local PathSource = vim.__class.def(function(this)
  local m_items = {}

  function this:__init()
    vim.__autocmd.on("BufWipeout", function(state) m_items[state.match] = nil end)
  end

  function this:eval(winid, bufnr)
    local fpath = vim.__buf.name(bufnr)
    local root  = vim.__path.cwd()

    local items = m_items[fpath]
    if not items then
      items = {}

      local ft = vim.__buf.filetype(bufnr)

      local p = fpath
      while
        p and
        p ~= root
      do
        local d = vim.__path.dirname(p)
        if p == d then break end -- "/" "."

        local basename = vim.__path.basename(p)
        local icon, icon_hl
        if vim.__fs.isdir(p) then
          icon, icon_hl = vim.__icons.directory, "DirectoryIcon"
        else
          icon, icon_hl = vim.__icons.get_icon_color_by_ft(ft)
        end

        table.insert(items, Item:new(basename, icon, icon_hl))

        p = d
      end

      vim.__tbl.reverse(items)
      m_items[fpath] = items
    end

    return items
  end
end)

local Winbar = vim.__class.def(function(this)
  local m_sources = {}
  function this:__init()
    local function attach(winid, bufnr)
      if vim.wo[winid].winbar ~= "" then
        return
      end

      local ft = vim.__buf.filetype(bufnr)
      local bt = vim.__buf.buftype(bufnr)
      if
        ft == "" or
        vim.__filter.contain_fts(ft) or
        vim.__filter.contain_bts(bt) or
        vim.__win.is_float(winid) or
        not vim.__buf.is_valid(bufnr) or
        not vim.__win.is_valid(winid)
      then
        vim.wo[winid].winbar = ""
        return
      end

      vim.wo[winid].winbar = "%{%v:lua.require'ngpong.core.winbar'.eval()%}"
    end
    for _, winid in ipairs(vim.__win.all()) do
      local bufnr = vim.__buf.number(winid)
      attach(winid, bufnr)
    end
    vim.__autocmd.on({ "BufWinEnter", "BufWritePost", }, function(state)
      attach(vim.__win.current(), state.buf)
    end)

    table.insert(m_sources, PathSource:new())
    table.insert(m_sources, LspSource:new())
  end

  local m_timer, m_evalcache = vim.loop.new_timer(), nil
  function this:eval(winid, bufnr)
    if m_evalcache then
      return m_evalcache
    end

    local items, item_size, linewidth = {}, 0, 0
    for _, source in ipairs(m_sources) do
      for _, item in ipairs(source:eval(winid, bufnr) or {}) do
        linewidth = linewidth + item:width()
        item_size = item_size + 1
        table.insert(items, item)
      end
    end
    linewidth = linewidth + 2 + (Options.separator_width * (item_size - 1))

    local win_width = vim.api.nvim_win_get_width(winid)
    local delta = linewidth - win_width
    local evalstrs = {}
    for _, item in ipairs(items) do
      if delta <= 0 then
        table.insert(evalstrs, item:eval())
      else
        local namewidth = item:namewidth()
        local miniwidth = item:truncate(1):namewidth()
        if namewidth > miniwidth then
          local sub = math.max(1, namewidth - delta - 1)

          local truncate = item:truncate(sub)
          table.insert(evalstrs, truncate:eval())
          delta = delta - namewidth + truncate:namewidth()
        end
      end
    end

    m_evalcache = string.format(" %s ", table.concat(evalstrs, Options.separator))
    m_timer:start(Options.eval_interval, 0, function()
      m_timer:stop()
      m_evalcache = nil
    end)

    return m_evalcache
  end
end)

local wb = Winbar:new()
return {
  eval = function()
    local winid = vim.__win.current()
    local bufnr = vim.__buf.current()
    return wb:eval(winid, bufnr)
  end,
}
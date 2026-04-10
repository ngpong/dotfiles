do
  table.pack = table.pack or function(...) return { n = select("#", ...), ... } end
  table.unpack = table.unpack or function(t, i, j) return unpack(t, i or 1, j or t.n or #t) end

  math.randomseed(os.time())

  vim.pack.add({"https://github.com/ellisonleao/gruvbox.nvim"})
  do
    local gb = require("gruvbox")
    vim.__color = gb.palette
    gb.setup({
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        comments = false,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = "",
      palette_overrides = {},
      dim_inactive = false,
      transparent_mode = false,
      overrides = {
        LazyButton = { bg = vim.__color.dark4, fg = vim.__color.dark0 },
        LazyButtonActive = { bg = vim.__color.bright_blue, fg = vim.__color.dark0, bold = true },
        LazyH1 = { bg = vim.__color.bright_blue, fg = vim.__color.dark0, bold = true },
        LazySpecial = { fg = vim.__color.bright_orange },
        LazyBackdrop = { link = "Normal" },

        WinSeparator = { fg = "#222222" },
        VertSplit = { fg = vim.__color.dark0_hard },

        NormalFloat = { bg = vim.__color.dark0_soft, fg = vim.__color.light1 },
        FloatBorder = { fg = vim.__color.dark0_soft, bg = vim.__color.dark0_soft },
        FloatTitle = { bg = vim.__color.bright_blue, fg = vim.__color.dark0_hard, bold = true },
        FloatEndOfBuffer = { bg = vim.__color.dark0_soft, fg = vim.__color.dark0_soft },

        CursorLineNr = { fg = vim.__color.bright_yellow, bg = vim.__color.dark0 },
        CursorLine = { bg = "#302e2e" },
        CursorLineDark = { bg = "#242424" },
        Visual = { bg = "#384539" },

        SignColumn = { bg = vim.__color.dark0 },

        IndentGuide = { fg = "#3f3b38" },

        WinBar = { fg = vim.__color.light2 },
        WinBarNC = { link = "WinBar" },

        -- Directory = { fg = vim.__color.light2 },
        DirectoryIcon = { fg = "#c09553" },

        -- CurSearch = { link = "Search" },
        -- IncSearch = { link = "Search" },

        StatusLine = { bg = vim.__color.dark0_soft },
        StatusLineNC = { bg = vim.__color.dark0_soft },
        StatusLineTermNC = { bg = vim.__color.dark0_soft },

        cStatement = { fg = vim.__color.bright_red, italic = true },
        cppStatement = { fg = vim.__color.bright_red, italic = true },
        cConditional = { fg = vim.__color.bright_red, italic = true },
        cRepeat = { fg = vim.__color.bright_red, italic = true },
        cLabel = { fg = vim.__color.bright_red, italic = true },
      }
    })
    vim.go.background = "dark"
    vim.cmd.colorscheme("gruvbox")
  end

  vim.async = require("neil.utils.async")

  vim.__g = {}
  do
    local should_load_session = os.getenv("NVIM_SESSION")
    vim.__g.should_load_session = not should_load_session or should_load_session == "1"
  end

  vim.__lazy = require("neil.utils.lazy")

  vim.__class     = vim.__lazy.require("neil.utils.oop")
  vim.__bouncer   = vim.__lazy.require("neil.utils.debounce")
  vim.__str       = vim.__lazy.require("neil.utils.str")
  vim.__tbl       = vim.__lazy.require("neil.utils.tbl")
  vim.__fs        = vim.__lazy.require("neil.utils.fs")
  vim.__path      = vim.__lazy.require("neil.utils.path")
  vim.__git       = vim.__lazy.require("neil.utils.git")
  vim.__cache     = vim.__lazy.require("neil.utils.lrucache")
  vim.__util      = vim.__lazy.require("neil.utils")
  vim.__logger    = vim.__lazy.require("neil.utils.log")
  vim.__timestamp = vim.__lazy.require("neil.utils.timestamp")
  vim.__icons     = vim.__lazy.require("neil.utils.icon")
  vim.__libp      = vim.__lazy.require("neil.utils.libp")
  vim.__autocmd   = vim.__lazy.require("neil.core.autocmd")
  vim.__key       = vim.__lazy.require("neil.core.key")
  vim.__filter    = vim.__lazy.require("neil.core.filter")
  vim.__ui        = vim.__lazy.require("neil.core.ui")
  vim.__helper    = vim.__lazy.require("neil.core.helper")
  vim.__buf       = vim.__lazy.require("neil.core.buf")
  vim.__mark      = vim.__lazy.require("neil.core.buf")
  vim.__win       = vim.__lazy.require("neil.core.win")
  vim.__tab       = vim.__lazy.require("neil.core.tab")
  vim.__cursor    = vim.__lazy.require("neil.core.cursor")
  vim.__jumplst   = vim.__lazy.require("neil.core.jumplst")
  vim.__qfixlst   = vim.__lazy.require("neil.core.qfixlst")
  vim.__plugin    = vim.__lazy.require("neil.core.plugin")
  vim.__echo      = vim.__lazy.require("neil.core.echo")

  vim.__stl      = require("neil.core.statusline")
  vim.__session  = require("neil.core.session")
  vim.__wbr      = require("neil.core.winbar")
  vim.__bookmark = require("neil.core.bookmark")

  -- 加载用户配置
  require("neil.config.opts")
  require("neil.config.cmds")
  require("neil.config.keymap")

  vim.__autocmd.on("VimEnter", function()
    -- clear jump list && search pattern
    vim.__jumplst.clear()
    vim.__helper.clear_searchpattern()

    -- preserved position after yank
    local ylnum, ycol
    vim.__autocmd.on("ModeChanged", function()
      if vim.v.operator == "y" then
        ylnum, ycol = vim.__cursor.get()
      end
    end, { pattern = "n:no" })
    vim.__autocmd.on("TextYankPost", function()
      if vim.__helper.get_mode() ~= "no" or vim.v.event.operator ~= "y" then
        return
      end

      if not vim.b.visual_multi then
        vim.highlight.on_yank{ higroup = "Visual", timeout = 75 }
      end

      if ylnum and ycol then
        vim.__cursor.set(ylnum, ycol)
      end
    end)
  end)
end

do
  -- 确保 lazy.nvim 的安装
  do
    local path = vim.__path.join(vim.__path.standard("data"), "lazy", "lazy.nvim")
    if not vim.__fs.exists(path) then
      vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        path,
      })
    end
    vim.opt.rtp:prepend(path)
  end

  -- 注册 lazy-spec 使用到的懒加载事件
  do
    local lazy_event = require("lazy.core.handler.event")

    -- Add support for the LazyFile event
    local Event = require("lazy.core.handler.event")

    lazy_event.mappings.LazyFile = { id = "LazyFile", event = "User", pattern = "LazyFile" }
    lazy_event.mappings["User LazyFile"] = Event.mappings.LazyFile

    lazy_event.mappings.VeryLazyFile = { id = "VeryLazyFile", event = "User", pattern = "VeryLazyFile" }
    lazy_event.mappings["User VeryLazyFile"] = Event.mappings.VeryLazyFile

    local group = vim.__autocmd.augroup("lazy_event")
    group:on({ "BufReadPost", "BufNewFile", "BufWritePre" }, vim.async.void(function(_)
      group:del()
      vim.__autocmd.exec("User", { pattern = "LazyFile" })
      vim.async.sleep(200)
      vim.__autocmd.exec("User", { pattern = "VeryLazyFile", modeline = false })
    end))
  end

  -- 注册 lazy.nvim 的按键
  do
    vim.__key.rg("n", "<leader>p", function() pcall(vim.cmd, "Lazy") end)

    -- hijack plugin manager native key setup
    local Config = require("lazy.view.config")
    Config.keys.hover = "<nop>"
    Config.keys.diff = "<nop>"
    Config.commands.help.key = "M"
  end

  local function getspecs()
    local config_path = vim.__path.standard("config")

    local function setup_spec_highlights(oldconfig, highlights)
      local function __setup_spec_highlights(__highlights)
        if type(__highlights) == "function" then
          return __setup_spec_highlights(__highlights())
        end

        for _, hl in ipairs(__highlights) do
          if type(hl) == "function" then
            __setup_spec_highlights(hl())
          else
            vim.api.nvim_set_hl(0, hl[1], {
              fg = hl.fg,
              bg = hl.bg,
              sp = hl.sp,
              link = hl.link,
              bold = hl.bold,
              blend = hl.blend,
              italic = hl.italic,
              reverse = hl.reverse,
              nocombine = hl.nocombine,
              underline = hl.underline,
              undercurl = hl.undercurl,
              underdouble = hl.underdouble,
              underdotted = hl.underdotted,
              underdashed = hl.underdashed,
              strikethrough = hl.strikethrough,
            })
          end
        end
      end

      return function(p, opts)
        __setup_spec_highlights(highlights)

        if not oldconfig and p.main then
          local module = require(p.main)
          module.setup(opts)
        elseif oldconfig then
          oldconfig(p, opts)
        end
      end
    end

    local function setup_spec_hackers(oldconfig, hackers)
      local function __setup_spec_hackers(__hackers, __opts)
        if not __hackers then return end

        for _, hacker in ipairs(__hackers) do
          hacker(__opts)
        end
      end

      return function(p, opts)
        __setup_spec_hackers(hackers.before, opts)

        if not oldconfig and p.main then
          local module = require(p.main)
          if module.setup then
            module.setup(opts)
          end
        elseif oldconfig then
          oldconfig(p, opts)
        end

        __setup_spec_hackers(hackers.after, opts)
      end
    end

    local function setup_spec_dispatchs(oldinit, dispatchs)
      return function(...)
        for _, d in ipairs(dispatchs) do
          vim[string.format("__%s", d[1])] = vim.__class.def(d[2]):new()
        end

        if oldinit then oldinit(...) end
      end
    end

    local function setup_spec_commands(oldinit, commands)
      return function(...)
        for _, c in ipairs(commands) do
          vim.api.nvim_create_user_command(c[1], c[2], {})
        end

        if oldinit then oldinit(...) end
      end
    end

    local function setup_spec_autocmds(oldinit, autocmds)
      return function(...)
        for _, a in ipairs(autocmds) do
          vim.__autocmd.on(a[1], a[2], { pattern = a.pattern, once = a.once, buffer = a.buffer })
        end

        if oldinit then oldinit(...) end
      end
    end

    local function setup_specs(specs)
      if not specs.enabled then
        return
      end

      local root = specs.root
      if not root then
        root = specs[1]
      end
      assert(root, "missing root in specs")

      local combinit = specs.combinit
      local combconfig = specs.combconfig

      for _, spec in ipairs(specs) do
        local highlights = spec.highlights
        spec.highlights = nil
        if highlights then
          combconfig = setup_spec_highlights(combconfig, highlights)
        end

        local hackers = spec.hackers
        spec.hackers = nil
        if hackers then
          combconfig = setup_spec_hackers(combconfig, hackers)
        end

        local dispatchs = spec.dispatchs
        spec.dispatchs = nil
        if dispatchs then
          combinit = setup_spec_dispatchs(combinit, dispatchs)
        end

        local commands = spec.commands
        spec.commands = nil
        if commands then
          combinit = setup_spec_commands(combinit, commands)
        end

        local autocmds = spec.autocmds
        spec.autocmds = nil
        if autocmds then
          combinit = setup_spec_autocmds(combinit, autocmds)
        end
      end

      root.init = combinit
      root.config = combconfig
    end

    local specs, specs_m = {}, setmetatable({}, {
      __index = function(t, k)
        rawset(t, k, {})
        return rawget(t, k)
      end,
    })
    local function scanmod(suffix)
      local function append_2_specs_m(specname, spec)
        local specs0 = specs_m[specname]

        if spec.main then
          assert(not spec.optional, "optional spec can not set root " .. specname)
          assert(not specs0.main, "multiple root " .. specname)
          specs0.root = spec
          specs0.main = spec.main
        end

        if spec.enabled ~= nil then
          specs0.enabled = spec.enabled
        else
          specs0.enabled = true
        end

        table.insert(specs0, spec)

        local config = spec.config
        if config then
          spec.config = nil

          local old_combconfig = specs0.combconfig
          if old_combconfig then
            specs0.combconfig = function(...)
              old_combconfig(...)
              config(...)
            end
          else
            specs0.combconfig = config
          end
        end

        local init = spec.init
        if init then
          spec.init = nil

          local old_combinit = specs0.combinit
          if old_combinit then
            specs0.combinit = function(...)
              old_combinit(...)
              init(...)
            end
          else
            specs0.combinit = init
          end
        end
      end

      local path = string.format(config_path .. "/lua/neil/%s", suffix)

      vim.__fs.scandir(path, function(fname, ftype)
        if ftype == 8 then
          local require_path = string.format("neil.%s.%s", suffix, fname:sub(1, -5))

          local package = require(require_path)

          if vim.__tbl.isarray(package) then
            for _, spec in ipairs(package) do
              append_2_specs_m(spec[1], spec)
            end
          else
            append_2_specs_m(package[1], package)
          end

          table.insert(specs, package)
        end
      end)
    end
    scanmod("plugin")
    scanmod("lang")

    for _, v in pairs(specs_m) do
      setup_specs(v)
    end

    return specs
  end

  require("lazy").setup(getspecs(), {
    profiling = {
      loader = false,
      require = false,
    },
    defaults = { lazy = false, },
    install = { colorscheme = { "gruvbox" }, },
    ui = {
      size = { width = 0.8, height = 0.8 },
      border = vim.__icons.border.no, -- "rounded"
      backdrop = 100,
      title = " Lazy ",
      custom_keys = {
        ["<localleader>l"] = false,
        ["<localleader>t"] = false,
      },
    },
    checker = {
      enabled = true,
    },
    change_detection = {
      enabled = false,
      notify = false,
    },
    readme = {
      enabled = false,
    },
    pkg = {
      enabled = false,
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "ftplugin",
          "bugreport",
          "rplugin",
          "syntax",
          "synmenu",
          "optwin",
          "compiler",
          "bugreport",
          "tutor",
          "gzip",
          "zip",
          "zipPlugin",
          "netrw",
          "netrwPlugin",
          "netrwSettings",
          "netrwFileHandlers",
          "tohtml",
          "2html_plugin",
          "getscript",
          "getscriptPlugin",
          "logipat",
          "rrhelper",
          "tar",
          "tarPlugin",
          "matchit",
          "matchparen",
          "man",
          "vimball",
          "vimballPlugin",
          "spellfile_plugin",
          "spellfile",
          "editorconfig", -- 该内置插件在保存文件时会遍历文件内容，可能会造成一些性能问题
          -- "osc52",
        },
      },
    },
  })

  -- lazy autocmd
  vim.__autocmd.on("FileType", function(state)
    vim.__autocmd.on("BufModifiedSet", function()
      vim.__autocmd.exec("User", { pattern = "UserBufModifiedSet" })
      vim.__stl.redraw()
    end, { buffer = state.buf, once = true })

    vim.__autocmd.on("WinLeave", function()
      local view = require("lazy.view").view

      if view and view:win_valid() and view:buf_valid() then
        view:close()
      end
    end, { buffer = state.buf, once = true })
  end, { pattern = "lazy" })
  vim.__autocmd.on("User", function()
    vim.pack.update(nil, { force = true })
  end, { pattern = "LazyUpdate" })
end

-- restore session
if vim.__g.should_load_session then
  vim.__session.buffer:load()
end

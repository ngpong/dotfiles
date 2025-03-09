
local function load_global_modules()
  table.pack = table.pack or function(...) return { n = select("#", ...), ... } end
  table.unpack = table.unpack or function(t, i, j) return unpack(t, i or 1, j or t.n or #t) end

  math.randomseed(os.time())

  -- fix builtin inspect
  local inspect = vim.inspect
  vim.inspect = function(root, options)
    local ok, ret = pcall(inspect, root, options)
    if not ok then
      vim.__logger.error(root, options, ok, ret)
      ok, ret = pcall(inspect, root, options)
    end
    if not ok then
      return ""
    else
      return ret
    end
  end

  vim.__g         = {}
  vim.__lazy      = require("ngpong.utils.lazy")
  vim.__class     = vim.__lazy.require("ngpong.utils.oop")
  vim.__async     = vim.__lazy.require("ngpong.utils.async")
  vim.__job       = vim.__lazy.require("ngpong.utils.async.job")
  vim.__bouncer   = vim.__lazy.require("ngpong.utils.debounce")
  vim.__str       = vim.__lazy.require("ngpong.utils.str")
  vim.__tbl       = vim.__lazy.require("ngpong.utils.tbl")
  vim.__fs        = vim.__lazy.require("ngpong.utils.fs")
  vim.__path      = vim.__lazy.require("ngpong.utils.path")
  vim.__git       = vim.__lazy.require("ngpong.utils.git")
  vim.__util      = vim.__lazy.require("ngpong.utils")
  vim.__logger    = vim.__lazy.require("ngpong.utils.log")
  vim.__timestamp = vim.__lazy.require("ngpong.utils.timestamp")
  vim.__icons     = vim.__lazy.require("ngpong.utils.icon")
  vim.__libp      = vim.__lazy.require("ngpong.utils.libp")
  vim.__autocmd   = vim.__lazy.require("ngpong.core.autocmd")
  vim.__event     = vim.__lazy.require("ngpong.core.events")
  vim.__key       = vim.__lazy.require("ngpong.core.key")
  vim.__filter    = vim.__lazy.require("ngpong.core.filter")
  vim.__ui        = vim.__lazy.require("ngpong.core.ui")
  vim.__helper    = vim.__lazy.require("ngpong.core.helper")
  vim.__buf       = vim.__lazy.require("ngpong.core.buf")
  vim.__mark      = vim.__lazy.require("ngpong.core.buf")
  vim.__win       = vim.__lazy.require("ngpong.core.win")
  vim.__tab       = vim.__lazy.require("ngpong.core.tab")
  vim.__cursor    = vim.__lazy.require("ngpong.core.cursor")
  vim.__jumplst   = vim.__lazy.require("ngpong.core.jumplst")
  vim.__qfixlst   = vim.__lazy.require("ngpong.core.qfixlst")
  vim.__color     = vim.__lazy.require("ngpong.core.color")
  vim.__plugin    = vim.__lazy.require("ngpong.core.plugin")

  vim.__event.rg(vim.__event.types.COLOR_SCHEME, function()
    vim.__stl = require("ngpong.core.statusline")
    vim.__wbr = require("ngpong.core.winbar")
  end)
end

local function load_user_config()
  vim.__event.rg(vim.__event.types.VIM_ENTER, function()
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

  require("ngpong.config.opts")
  require("ngpong.config.cmds")
  require("ngpong.config.keymap")
end

local function lanugh()
  local kmodes = vim.__key.e_mode
  local etypes = vim.__event.types

  -- ensure installed lazy.nvim
  local function ensure_install()
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
  ensure_install()

  -- register starter events
  local function reg_events()
    local lazy_event = require("lazy.core.handler.event")

    -- Add support for the LazyFile event
    local Event = require("lazy.core.handler.event")

    lazy_event.mappings.LazyFile = { id = "LazyFile", event = "User", pattern = "LazyFile" }
    lazy_event.mappings["User LazyFile"] = Event.mappings.LazyFile

    lazy_event.mappings.VeryLazyFile = { id = "VeryLazyFile", event = "User", pattern = "VeryLazyFile" }
    lazy_event.mappings["User VeryLazyFile"] = Event.mappings.VeryLazyFile

    local group = vim.__autocmd.augroup("lazy_event")
    group:on({ "BufReadPost", "BufNewFile", "BufWritePre" }, vim.__async.void(function(_)
      group:del()
      vim.__autocmd.exec("User", { pattern = "LazyFile" })
      vim.__async.sleep(200)
      vim.__autocmd.exec("User", { pattern = "VeryLazyFile", modeline = false })
    end))
  end
  reg_events()

  -- register starter keymaps
  local function reg_keymaps()
    vim.__key.rg(kmodes.N, "<leader>p", function()
      vim.cmd("Lazy")

      -- 由于 lazy 禁用了 autocmd，所以我们要手动触发一次
      for _, bufnr in pairs(vim.__buf.all()) do
        if "lazy" == vim.__buf.filetype(bufnr) then
          vim.__event.emit(etypes.BUFFER_ENTER, { buf = bufnr })
          break
        end
      end
    end)

    -- hijack plugin manager native key setup
    require("lazy.view.config").keys.hover = "<nop>"
    require("lazy.view.config").keys.diff = "<nop>"
    vim.__tbl.r_extend(require("lazy.view.config").commands.help, { key = "M" })
  end
  reg_keymaps()

  local function scanspecs()
    local config_path = vim.__path.standard("config")

    local function setup_spec_highlights(oldconfig, highlights)
      local function __setup_spec_highlights(p, __highlights)
        if type(__highlights) == "function" then
          return __setup_spec_highlights(p, __highlights())
        end

        for _, hl in ipairs(__highlights) do
          if type(hl) == "function" then
            __setup_spec_highlights(p, hl())
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
        __setup_spec_highlights(p, highlights)

        if not oldconfig then
          local LazyLoader = require("lazy.core.loader")
          local LazyUtil   = require("lazy.core.util")

          local main = LazyLoader.get_main(p)
          if main then
            LazyUtil.try(function() require(main).setup(opts) end, "Failed to run `config` for " .. p.name)
          else
            LazyUtil.error("Lua module not found for config of " .. p.name .. ". Please use a `config()` function instead")
          end
        else
          oldconfig(p, opts)
        end
      end
    end

    local function setup_spec_events(oldinit, events)
      return function(...)
        for _, e in ipairs(events) do
          vim.__event.rg(e[1], e[2])
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
      local function find_finalspec()
        for _, spec in ipairs(specs) do
          if not spec.optional then
            return spec
          end
        end
      end

      local finalspec_cache
      for _, spec in ipairs(specs) do
        local finalspec = spec

        if spec.optional then
          if not finalspec_cache then finalspec_cache = find_finalspec() end
          assert(finalspec_cache, "can not find final spec")

          finalspec = finalspec_cache
        end

        if spec.highlights then
          finalspec.config = setup_spec_highlights(finalspec.config, spec.highlights)
          spec.highlights = nil
        end

        if spec.events then
          finalspec.init = setup_spec_events(finalspec.init, spec.events)
          spec.events = nil
        end

        if spec.autocmds then
          finalspec.init = setup_spec_autocmds(finalspec.init, spec.autocmds)
          spec.autocmds = nil
        end
      end
    end

    local specs, specs_m = {}, setmetatable({}, {
      __index = function(t, k)
        if rawget(t, k) == nil then rawset(t, k, {}) end
        return rawget(t, k)
      end,
    })
    local function scanmod(suffix)
      local path = string.format(config_path .. "/lua/ngpong/%s", suffix)

      vim.__fs.scandir(path, function(fname, ftype)
        if ftype == 8 then
          local require_path = string.format("ngpong.%s.%s", suffix, fname:sub(1, -5))

          local package = require(require_path)

          -- is more than 1 spec
          if package [2] ~= nil then -- vim.isarray(package)
            for _, spec in ipairs(package) do
              local specname = spec[1]
              table.insert(specs_m[specname], spec)
            end
          else
            local specname = package[1]
            table.insert(specs_m[specname], package)
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

  -- lanugh
  require("lazy").setup(scanspecs(), {
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
          -- "osc52",
        },
      },
    },
  })

  -- lazy highlight
  vim.api.nvim_set_hl(0, "LazyBackdrop", { link = "Normal" })

  vim.__autocmd.on("FileType", function(state)
    vim.__autocmd.on("BufModifiedSet", function()
      vim.__autocmd.exec("User", { pattern = "LazyBufModifiedSet" })
      vim.__stl.redraw(true)
    end, { buffer = state.buf, once = true })

    vim.__autocmd.on("WinLeave", function()
      local view = require("lazy.view").view

      if view and view:win_valid() and view:buf_valid() then
        view:close()
      end
    end, { buffer = state.buf, once = true })
  end, { pattern = "lazy" })
end

load_global_modules()

load_user_config()

lanugh()
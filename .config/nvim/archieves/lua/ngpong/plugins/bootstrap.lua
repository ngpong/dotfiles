local M = {}

local kmodes = vim.__key.e_mode
local etypes = vim.__event.types

M.ensure_install = function()
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

M.laungh = function()
  local specs, size = {}, 0

  for _, dir in ipairs(vim.__fs.scandir("/home/ngpong/.config/nvim/lua/ngpong/plugins")) do
    local success, spec = pcall(require, "ngpong.plugins." .. dir)
    assert(success, "Wrong plugin file structure definition, [" .. dir .. "].")

    if vim.isarray(spec) then
      for i = 1, #spec do
        size = size + 1
        specs[size] = spec[i]
      end
    else
      size = size + 1
      specs[size] = spec
    end
  end
  assert(size > 0, "Not plugins specs found.")

  for _, spec in ipairs(require("ngpong.plugins.enable")) do
    size = size + 1
    specs[size] = spec
  end

  require("lazy").setup({}, {
    defaults = { lazy = false, },
    install = { colorscheme = { "gruvbox" }, },
    ui = {
      size = { width = 0.8, height = 0.8 },
      border = "rounded",
      custom_keys = {
        ["<localleader>l"] = false,
        ["<localleader>t"] = false,
      },
      icons = {
        cmd = vim.__icons.terminal_2 .. vim.__icons.space,
        config = vim.__icons.setting_2 .. vim.__icons.space,
        event = vim.__icons.electricity .. vim.__icons.space,
        ft = vim.__icons.file_1 .. vim.__icons.space,
        init = vim.__icons.setting_2 .. vim.__icons.space,
        import = vim.__icons.import .. vim.__icons.space,
        keys = vim.__icons.keyboard .. vim.__icons.space,
        lazy = vim.__icons.sleep .. vim.__icons.space,
        loaded = vim.__icons.mid_dot .. vim.__icons.space,
        not_loaded = vim.__icons.mid_dot .. vim.__icons.space,
        plugin = vim.__icons.box_1 .. vim.__icons.space,
        runtime = vim.__icons.vim .. vim.__icons.space,
        require = vim.__icons.lua .. vim.__icons.space,
        source = vim.__icons.source .. vim.__icons.space,
        start = vim.__icons.play .. vim.__icons.space,
        task = vim.__icons.yes .. vim.__icons.space,
        list = {
          vim.__icons.mid_dot,
          vim.__icons.arrow_right_2,
          vim.__icons.star,
          vim.__icons.ellipsis,
        },
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
end

M.register_event = function()
  local Event = require("lazy.core.handler.event")

  local register_filepost = function()
    Event.mappings.FilePost = { id = "FilePost", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
    Event.mappings["User FilePost"] = Event.mappings.FilePost
  end

  local register_extra_verylazy = function()
    Event.mappings.VeryVeryLazy = { id = "VeryVeryLazy", event = "User", pattern = "VeryVeryLazy" }
    Event.mappings["User VeryVeryLazy"] = Event.mappings.VeryVeryLazy

    local group = vim.__autocmd.augroup("extra_very_lazy")

    group:on("UIEnter", function(_)
      group:del()

      local timer = vim.loop.new_timer()
      timer:start(350, 0, vim.__async.schedule_wrap(function()
        vim.__autocmd.exec("User", { pattern = "VeryVeryLazy", modeline = false })
        timer:close()
      end))
    end)
  end

  register_filepost()
  register_extra_verylazy()
end

M.register_keymap = function()
  -- 打开 lazy plugin manager
  vim.__key.rg(kmodes.N, "<leader>p", function()
    vim.cmd("Lazy")

    -- 由于 lazy 禁用了 autocmd，所以我们要手动触发一次
    for _, _bufnr in pairs(vim.api.nvim_list_bufs()) do
      if "lazy" == vim.__buf.filetype(_bufnr) then
        vim.__event.emit(etypes.BUFFER_ENTER, { buf = _bufnr })
        break
      end
    end
  end)

  -- hijack plugin manager native key setup
  require("lazy.view.config").keys.close = "<esc>"
  require("lazy.view.config").keys.hover = "<nop>"
  require("lazy.view.config").keys.diff = "<nop>"
  vim.__tbl.r_extend(require("lazy.view.config").commands.help, { key = "M" })
end

return M
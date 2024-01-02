local M = {}

local icons   = require('ngpong.utils.icon')
local lazy    = require('ngpong.utils.lazy')
local keymap  = require('ngpong.common.keybinder')
local autocmd = require('ngpong.common.autocmd')
local async   = lazy.require('plenary.async')

local e_mode = keymap.e_mode

M.ensure_install = function()
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

M.laungh = function()
  local specs = {}

  local dirs = TOOLS.scandir('/home/ngpong/.config/nvim/lua/ngpong/plugins')
  -- local dirs = {
  --   'libs',
  --   'colorscheme',
  --   'multicursors',
  --   'lualine'
  --   -- 'lsp',
  --   -- 'treesitter',
  --   -- 'luasnip',
  --   -- 'cmp',
  --   -- 'profiler',
  --   -- 'notify',
  -- }
  for _, dir in ipairs(dirs) do
    local success, spec = pcall(require, 'ngpong.plugins.' .. dir)
    assert(success, 'Wrong plugin file structure definition, [' .. dir .. '].')

    if vim.tbl_isarray(spec) then
      for i = 0, #spec do
        table.insert(specs, spec[i])
      end
    else
      table.insert(specs, spec)
    end
  end

  if not next(specs) then
    LOGGER.error('Not plugins specs found.')
    return
  end

  require('lazy').setup(specs, {
    defaults = {
      lazy = false,
      version = nil,
      cond = nil,
    },
    -- leave nil when passing the spec as the first argument to setup()
    spec = nil,
    concurrency = jit.os:find('Windows') and (vim.loop.available_parallelism() * 2) or nil,
    install = {
      -- install missing plugins on startup. This doesn't increase startup time.
      missing = true,
      -- try to load one of these colorschemes when starting an installation during startup
      colorscheme = {},
    },
    ui = {
      -- a number <1 is a percentage., >1 is a fixed size
      size = { width = 0.8, height = 0.8 },
      wrap = true, -- wrap the lines in the ui
      border = 'rounded',
      title = '',
      title_pos = 'center',
      pills = true,
      icons = {
        cmd = icons.cmd .. icons.space,
        config = icons.config .. icons.space,
        event = icons.electricity_2 .. icons.space,
        ft = icons.file_1 .. icons.space,
        init = icons.config .. icons.space,
        import = icons.import .. icons.space,
        keys = icons.keyboard .. icons.space,
        lazy = icons.sleep .. icons.space,
        loaded = icons.circular_mid .. icons.space,
        not_loaded = icons.circular_mid_hollow .. icons.space,
        plugin = icons.box_1 .. icons.space,
        runtime = icons.vim .. icons.space,
        require = icons.lua .. icons.space,
        source = icons.source .. icons.space,
        start = icons.play .. icons.space,
        task = icons.yes .. icons.space,
        list = {
          icons.circular_mid,
          icons.arrow_right_2,
          icons.star,
          icons.ellipsis,
        },
      },
      throttle = 20,
      custom_keys = {
        -- You can define custom key maps here. If present, the description will
        -- be shown in the help menu.
        -- To disable one of the defaults, set it to false.
        ['<localleader>l'] = false,
        ['<localleader>t'] = false,
      },
    },
    checker = {
      enabled = true, -- automatically check for plugin updates
      concurrency = nil, -- set to 1 to check for updates very slowly
      notify = true, -- get a notification when new updates are found
      frequency = 3600, -- check for updates every hour
      check_pinned = false, -- check for pinned packages that can't be updated
    },
    change_detection = {
      enabled = false,
      notify = false,
    },
    performance = {
      cache = {
        enabled = true,
      },
      reset_packpath = true,
      rtp = {
        reset = true,
        paths = {},
        disabled_plugins = {
          'bugreport',
          'rplugin',
          'syntax',
          'synmenu',
          'optwin',
          'compiler',
          'bugreport',
          'tutor',
        },
      },
    },
    -- lazy can generate helptags from the headings in markdown readme files,
    -- so :help works even for plugins that don't have vim docs.
    -- when the readme opens with :help it will be correctly displayed as markdown
    readme = {
      enabled = false,
      root = vim.fn.stdpath('state') .. '/lazy/readme',
      files = { 'README.md', 'lua/**/README.md' },
      skip_if_doc_exists = true, -- only generate markdown helptags for plugins that dont have docs
    },
    -- Enable profiling of lazy.nvim. This will add some overhead,
    -- so only enable this when you are debugging lazy.nvim
    profiling = {
      -- Enables extra stats on the debug tab related to the loader cache.
      -- Additionally gathers stats about all package.loaders
      loader = false,
      -- Track each new require in the Lazy profiling tab
      require = false,
    },
  })
end

M.register_event = function()
  local Event = require('lazy.core.handler.event')

  local register_lazyfile = function()
    Event.mappings.LazyFile = { id = 'LazyFile', event = 'User', pattern = 'LazyFile' }
    Event.mappings['User LazyFile'] = Event.mappings.LazyFile

    Event.mappings.VeryLazyFile = { id = 'VeryLazyFile', event = 'User', pattern = 'VeryLazyFile' }
    Event.mappings['User VeryLazyFile'] = Event.mappings.VeryLazyFile

    local events = {}

    local done = false
    local function load()
      if #events == 0 or done then
        return
      end
      done = true

      autocmd.del_augroup('lazy_file')

      local skips = {}
      for _, event in ipairs(events) do
        skips[event.event] = skips[event.event] or Event.get_augroups(event.event)
      end

      vim.api.nvim_exec_autocmds('User', { pattern = 'LazyFile', modeline = false })
      async.run(function()
        async.util.sleep(100)
        vim.api.nvim_exec_autocmds('User', { pattern = 'VeryLazyFile', modeline = false })
      end)

      for _, event in ipairs(events) do
        if vim.api.nvim_buf_is_valid(event.buf) then
          Event.trigger({
            event = event.event,
            exclude = skips[event.event],
            data = event.data,
            buf = event.buf,
          })
          if vim.bo[event.buf].filetype then
            Event.trigger({
              event = 'FileType',
              buf = event.buf,
            })
          end
        end
      end
      vim.api.nvim_exec_autocmds('CursorMoved', { modeline = false })
      events = {}
    end

    -- schedule wrap so that nested autocmds are executed
    -- and the UI can continue rendering without blocking
    load = vim.schedule_wrap(load)

    vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile', 'BufWritePre' }, {
      group = autocmd.new_augroup('lazy_file'),
      callback = function(event)
        table.insert(events, event)
        load()
      end,
    })
  end

  local register_extra_verylazy = function()
    Event.mappings.VeryVeryLazy = { id = 'VeryVeryLazy', event = 'User', pattern = 'VeryVeryLazy' }
    Event.mappings['User VeryVeryLazy'] = Event.mappings.VeryVeryLazy

    vim.api.nvim_create_autocmd('UIEnter', {
      group = autocmd.new_augroup('extra_very_lazy'),
      callback = function(event)
        autocmd.del_augroup('extra_very_lazy')

        async.run(function()
          async.util.sleep(350)
          vim.api.nvim_exec_autocmds('User', { pattern = 'VeryVeryLazy', modeline = false })
        end)
      end,
    })
  end

  register_lazyfile()
  register_extra_verylazy()
end

M.register_keymap = function()
  -- 打开 lazy plugin manager
  keymap.register(e_mode.NORMAL, '<leader>p', '<CMD>Lazy<CR>', { remap = false, desc = 'open lazy plugins manager.' })

  -- hijack plugin manager native key setup
  require('lazy.view.config').keys.close = '<esc>'
  require('lazy.view.config').keys.hover = '<nop>'
  require('lazy.view.config').keys.diff  = '<nop>'
end

return M
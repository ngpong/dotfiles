local M = {}

local lazy                 = require('ngpong.utils.lazy')
local mason                = lazy.require('mason')
local mason_lspconfig      = lazy.require('mason-lspconfig')
local mason_tool_installer = lazy.require('mason-tool-installer')

M.setup = function()
  mason.setup {
    log_level = vim.log.levels.OFF,
    ui = {
      -- Whether to automatically check for new versions when opening the :Mason window.
      check_outdated_packages_on_open = true,
      -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
      border = 'rounded',
      width = 0.8,
      height = 0.8,
      icons = {
        package_installed = '✓',
        package_pending = '➜',
        package_uninstalled = '✗'
      },
      keymaps = {
        -- Keymap to expand a package
        toggle_package_expand = '<CR>',
        -- Keymap to install the package under the current cursor position
        install_package = '<leader>i',
        -- Keymap to reinstall/update the package under the current cursor position
        update_package = '<leader>u',
        -- Keymap to check for new version for the package under the current cursor position
        check_package_version = '<leader>c',
        -- Keymap to check which installed packages are outdated
        check_outdated_packages = '<leader>C',
        -- Keymap to update all installed packages
        update_all_packages = '<leader>U',
        -- Keymap to uninstall a package
        uninstall_package = '<leader>I',
        -- Keymap to cancel a package installation
        -- cancel_installation = '<esc>',
        -- Keymap to apply language filter
        apply_language_filter = '<leader>f',
        -- Keymap to toggle viewing package installation log
        toggle_package_install_log = '<CR>',
        -- Keymap to toggle the help view
        toggle_help = '?',
      },
    },
    pip = {
        upgrade_pip = false,
        install_args = { "--proxy", "http://192.168.1.2:7890" },
    },
  }

  mason_lspconfig.setup { }

  mason_tool_installer.setup {
    -- a list of all tools you want to ensure are installed upon
    ensure_installed = {
      'clangd',
      'lua_ls',
      'bashls',
      'jsonls',
      'yamlls',
      'cmake',
      'asm_lsp',
      'autotools_ls',
      'clang-format',
      'stylua',
    },

    -- if set to true this will check each tool for updates. If updates
    -- are available the tool will be updated. This setting does not
    -- affect :MasonToolsUpdate or :MasonToolsInstall.
    -- Default: false
    auto_update = true,

    -- automatically install / update on startup. If set to false nothing
    -- will happen on startup. You can use :MasonToolsInstall or
    -- :MasonToolsUpdate to install tools and check for updates.
    -- Default: true
    run_on_start = false,

    -- set a delay (in ms) before the installation starts. This is only
    -- effective if run_on_start is set to true.
    -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
    -- Default: 0
    start_delay = 0,

    -- Only attempt to install if 'debounce_hours' number of hours has
    -- elapsed since the last time Neovim was started. This stores a
    -- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
    -- This is only relevant when you are using 'run_on_start'. It has no
    -- effect when running manually via ':MasonToolsInstall' etc....
    -- Default: nil
    debounce_hours = nil,
  }
  vim.defer_fn(mason_tool_installer.check_install, 2000)
end

return M

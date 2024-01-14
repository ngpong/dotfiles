local M = {}

M.setup = function()
  require('mason').setup {
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
  }

  require('mason-lspconfig').setup {
    ensure_installed = { 'lua_ls', 'clangd', 'bashls', 'jsonls', 'yamlls', 'cmake' },
  }
end

return M

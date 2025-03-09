return {
  "rmagatti/auto-session",
  enabled = false,
  lazy = false,
  init = function ()
    vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end,
  opts = {
    root_dir = vim.fn.stdpath "data" .. "/sessions/",
    auto_save = true,
    auto_restore = true,
    auto_create = true,
    suppressed_dirs = nil, -- { "/home/ngpong" }
    allowed_dirs = nil,
    use_git_branch = false,
    bypass_save_filetypes = nil, -- { 'alpha', 'dashboard' }
    args_allow_single_directory = true, -- Follow normal sesion save/load logic if launched with a single directory as the only argument
    args_allow_files_auto_save = false,
    show_auto_restore_notif = true,
  }
}
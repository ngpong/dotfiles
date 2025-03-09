return {
  -- https://github.com/norcalli/profiler.nvim
  "stevearc/profile.nvim",
  lazy = false,
  enabled = false,
  config = function()
    vim._plugins.record_seq("profile.nvim config")
    -- https://www.reddit.com/r/neovim/comments/16zfm91/how_do_you_profile_sluggish_scrolling/
    -- https://stackoverflow.com/questions/12213597/how-to-see-which-plugins-are-making-vim-slow/12216578#12216578
    -- https://thoughtbot.com/blog/profiling-vim
    vim._plugins.profiler.config.setup()
  end
}

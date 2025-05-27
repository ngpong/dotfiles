return {
  "stevearc/profile.nvim",
  enabled = false,
  lazy = false,
  config = function()
    -- https://www.reddit.com/r/neovim/comments/16zfm91/how_do_you_profile_sluggish_scrolling/
    -- https://stackoverflow.com/questions/12213597/how-to-see-which-plugins-are-making-vim-slow/12216578#12216578
    -- https://thoughtbot.com/blog/profiling-vim

    local should_profile = os.getenv("NVIM_PROFILE")
    if should_profile then
      require("profile").instrument_autocmds()
      if should_profile:lower():match("^start") then
        require("profile").start("*")
      else
        require("profile").instrument("*")
      end
    end

    local function toggle_profile()
      local prof = require("profile")
      if prof.is_recording() then
        prof.stop()
        vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
          if filename then
            prof.export(filename)
            vim.notify(string.format("Wrote %s", filename))
          end
        end)
      else
        prof.start("*")
      end
    end
    vim.keymap.set("", "<f1>", toggle_profile)
  end
}

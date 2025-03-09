return {
  setup = function()
    require("ngpong.plugins.bootstrap").ensure_install()
    require("ngpong.plugins.bootstrap").register_event()
    require("ngpong.plugins.bootstrap").register_keymap()
    require("ngpong.plugins.bootstrap").laungh()

    require("ngpong.plugins.session").setup()
  end
}
return {
  setup = function()
    require('ngpong.native.opts').setup()
    require('ngpong.native.neovide').setup()
    require('ngpong.native.autocmd').setup()
    require('ngpong.native.behavior').setup()
    require('ngpong.native.highlight').setup()
    require('ngpong.native.cmds').setup()
    require('ngpong.native.keys').setup()
  end
}

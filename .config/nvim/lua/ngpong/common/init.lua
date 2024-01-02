return {
  setup = function()
    table.pack = table.pack or function(...) return { n = select('#', ...), ... } end
    table.unpack = table.unpack or unpack

    _G.VAR = require('ngpong.common.variable')
    _G.HELPER = require('ngpong.common.helper')

    -- require('ngpong.common.events').track_events()
  end
}
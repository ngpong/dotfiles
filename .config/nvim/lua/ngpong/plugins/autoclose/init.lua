return {
  'NGPONG/autoclose.nvim',
  lazy = true,
  event = { 'InsertEnter', 'CmdlineEnter' },
  enabled = true,
  init = function()
    Plgs.record_seq('autoclose init')
  end,
  config = function()
    Plgs.record_seq('autoclose config')
    Plgs.autoclose.config.setup()
  end
}

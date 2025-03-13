return {
  "ibhagwan/fzf-lua",
  lazy = true,
  cmd = "FzfLua",
  init = function()
    vim._plugins.record_seq("fzf-lua init")
    vim.opt.rtp:append("/home/linuxbrew/.linuxbrew/opt/fzf")
    
    vim._plugins.fzf.keys.setup()
    vim._plugins.fzf.history.setup()
  end,
  config = function()
    vim._plugins.record_seq("fzf-lua config")
    vim._plugins.fzf.highlight.setup()
    vim._plugins.fzf.config.setup()
  end
}

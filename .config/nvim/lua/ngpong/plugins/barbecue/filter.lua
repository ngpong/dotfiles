local execlude_fts = {
  'netrw',
  'help',
  'qf',
  'prompt',

  -- 'dap-repl',
  -- 'dapui_watches',
  -- 'dapui_hover',
  -- 'toggleterm',
  'TelescopePrompt',
  'neo-tree',
  'Trouble',
  'ClangdTypeHierarchy',
  'ClangdAST',
  'lazy',
  'mason',
  'notify',
  'ngpong_popup',
  'neo-tree-popup',
}

local max_size = 1024 * 256 -- 256kb

local f1 = function()
  return execlude_fts
end

local f2 = function(state)
  local size = HELPER.get_bufsize(state.bufnr)

  return size < max_size and state.cli.server_capabilities.documentSymbolProvider
end

return setmetatable({}, {
  __call = function (self, idx, ...)
    if idx == 1 then
      return f1()
    elseif idx == 2 then
      return f2(...)
    else
      return nil
    end
  end
})

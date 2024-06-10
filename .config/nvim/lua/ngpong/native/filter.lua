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
  'trouble',
  'ClangdTypeHierarchy',
  'ClangdAST',
  'lazy',
  'mason',
  'notify',
  'ngpong_popup',
  'neo-tree-popup',
}

local f1 = function(bufnr)
  return Tools.tbl_contains(execlude_fts, Helper.get_filetype(bufnr))
end

local f2 = function()
  if VAR.get('DisablePresistCursor') then
    return false
  else
    return true
  end
end

return setmetatable({}, {
  __call = function (self, idx, ...)
    if idx == 1 then
      return f1(...)
    elseif idx == 2 then
      return f2()
    else
      return nil
    end
  end
})

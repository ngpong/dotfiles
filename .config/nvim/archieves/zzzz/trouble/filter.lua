local execlude_fts = {
  "netrw",
  "help",
  "qf",
  "prompt",

  -- "dap-repl",
  -- "dapui_watches",
  -- "dapui_hover",
  -- "toggleterm",
  "TelescopePrompt",
  "neo-tree",
  "trouble",
  "ClangdTypeHierarchy",
  "ClangdAST",
  "lazy",
  "mason",
  "notify",
  "fidget",
  "fileinfo_popup",
  "neo-tree-popup",
}

local f = function(bufnr)
  return vim.__tbl.contains(execlude_fts, vim.__buf.filetype(bufnr))
end

return setmetatable({}, {
  __call = function (self, ...)
    return f()
  end
})

local M = {}

M.filetypes = {
  {
    "netrw",
    "help",
    "qf",
    "prompt",
    "lazy",
    "NvimTree",
    "trouble",
    "ClangdAST",
    "ClangdTypeHierarchy",
    "fzf",
    "fidget",
    "fileinfo_popup",
    "gitrebase",
    "gitcommit",
    "packer",
    "diff",
    "notify",
    "notify_history",
    -- "DressingSelect",
    -- "DressingInput",
    "viminput",
    "checkhealth",
    "blink-cmp-documentation",
    "blink-cmp-menu",
  },
  {
    "help",
    "qf",
    "query",
    "checkhealth",
    "ClangdTypeHierarchy",
    "ClangdAST",
  },
}

M.filetypes_m = {}
for idx, list in ipairs(M.filetypes) do
  local res = {}
  for _, val in ipairs(list) do
    res[val] = true
  end
  M.filetypes_m[idx] = res
end

M.buftypes = {
  "nofile",
  "prompt",
}

M.buftypes_m = {}
for _, val in ipairs(M.buftypes) do
  M.buftypes_m[val] = true
end

M.names = {
  "^gitsigns:"
}

M.max_size = {
  1024 * 512, -- 512kb
  1024 * 1024 -- 1mb
}

function M.contain_fts(ft, idx)
  ft = ft or vim.__buf.filetype()
  return M.filetypes_m[idx or 1][ft]
end

function M.contain_bts(bt)
  bt = bt or vim.__buf.buftype()
  return M.buftypes_m[bt]
end

function M.contain_names(name)
  name = name or vim.__buf.name(vim.__buf.current())

  local ret = false
  for _, pattern in ipairs(M.names) do
    if name:match(pattern) then
      ret = true
      break
    end
  end

  return ret
end

return M
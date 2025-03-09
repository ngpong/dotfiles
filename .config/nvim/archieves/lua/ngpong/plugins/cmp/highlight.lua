local M = {}

M.setup = function()
  for key, kind in pairs(vim.__icons.lsp_kinds) do
    vim.api.nvim_set_hl(0, "CmpItemKind" .. key, { link = kind.hl_link })
  end
end

return M

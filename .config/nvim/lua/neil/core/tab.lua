local M = {}

function M.nr(tabpage)
  for _, _tabpage in pairs(M.pages()) do
    if _tabpage == tabpage then
      return vim.api.nvim_tabpage_get_number(_tabpage)
    end
  end
end

function M.page(tabnr)
  if not tabnr then
    return vim.api.nvim_get_current_tabpage()
  end

  for _, _tabpage in pairs(M.pages()) do
    local _tabnr = vim.api.nvim_tabpage_get_number(_tabpage)

    if _tabnr == tabnr then
      return _tabpage
    end
  end

  return -1
end

function M.pages(_)
  return vim.api.nvim_list_tabpages()
end

function M.lastpage(_)
  return M.page(vim.fn.tabpagenr("#"))
end

return M

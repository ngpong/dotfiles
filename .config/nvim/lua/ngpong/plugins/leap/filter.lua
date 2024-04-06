local execlude_fts = {
  'notify',
}

local f = function(win)
  return HELPER.is_win_valid(win) and
         vim.api.nvim_win_get_config(win).focusable and
         not TOOLS.tbl_contains(execlude_fts, HELPER.get_filetype(HELPER.get_bufnr(win)))
end

return setmetatable({}, {
  __call = function (self, ...)
    return f(...)
  end
})

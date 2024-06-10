local execlude_fts = {
  'notify',
}

local f = function(win)
  return Helper.is_win_valid(win) and
         vim.api.nvim_win_get_config(win).focusable and
         not Tools.tbl_contains(execlude_fts, Helper.get_filetype(Helper.get_bufnr(win)))
end

return setmetatable({}, {
  __call = function (self, ...)
    return f(...)
  end
})

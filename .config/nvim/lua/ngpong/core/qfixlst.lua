return {
  empty = function()
    return next(vim.fn.getqflist()) == nil
  end,
  add = function(items, action, options)
    vim.fn.setqflist(items or {}, action or "r", options or {})
  end,
  clear = function()
    vim.fn.setqflist({}, "r")
  end
}
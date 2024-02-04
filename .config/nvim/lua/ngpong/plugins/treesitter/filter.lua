local max_size = 1024 * 512 -- 500kb

local f = function()
  return function(lang, bufnr)
    return HELPER.get_bufsize(bufnr) > max_size
  end
end

return setmetatable({}, {
  __call = function (self, ...)
    return f()
  end
})

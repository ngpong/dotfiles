local execlude_fts = {
  'prompt',
  'TelescopePrompt',
  'neo-tree',
}

local max_size = 1024 * 256 -- 500kb

local f1 = function()
  return execlude_fts
end

local f2 = function()
  return function()
    local bufnr = HELPER.get_cur_bufnr()
    local size  = HELPER.get_bufsize(bufnr)

    if size >= 0 then
      if size > max_size then
        return {}
      else
        return { bufnr }
      end
    else
      return {}
    end
  end
end

local f3 = function()
  local context = require('cmp.config.context')

  return function()
    local disabled = false
    disabled = disabled or (context.in_treesitter_capture('comment'))
    disabled = disabled or (vim.fn.reg_recording() ~= '')
    disabled = disabled or (vim.fn.reg_executing() ~= '')
    return not disabled
  end
end

return setmetatable({}, {
  __call = function (self, idx, ...)
    if idx == 1 then
      return f1()
    elseif idx == 2 then
      return f2()
    elseif idx == 3 then
      return f3()
    else
      return nil
    end
  end
})
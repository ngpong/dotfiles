return setmetatable({
  __model_cache = {}
}, {
  __index = function (self, k)
    if not self.__model_cache[k] then
      local success, ret = pcall(require, 'plenary.' .. k)
      assert(success, 'Invalie plenary lib path not found')

      self.__model_cache[k] = ret
    end

    return self.__model_cache[k]
  end
})

local co = coroutine
local vararg = require("ngpong.utils.async.vararg")
local errors = require("ngpong.utils.async.errors")
local traceback_error = errors.traceback_error
local f = require("ngpong.utils.async.functional")

local M = {}

local function is_callable(fn)
  return type(fn) == "function" or (type(fn) == "table" and type(getmetatable(fn)["__call"]) == "function")
end

---because we can't store varargs
local function callback_or_next(step, thread, callback, ...)
  local stat = f.first(...)

  if not stat then
    error(string.format("The coroutine failed with this message: %s", f.second(...)))
  end

  if co.status(thread) == "dead" then
    if callback == nil then
      return
    end
    callback(select(2, ...))
  else
    local returned_function = f.second(...)
    local nargs = f.third(...)

    assert(is_callable(returned_function), "type error :: expected func")
    returned_function(vararg(nargs, step, select(4, ...)))
  end
end

---Executes a future with a callback when it is done
local execute = function(async_function, callback, ...)
  assert(is_callable(async_function), "type error :: expected func")

  local thread = co.create(async_function)

  local step
  step = function(...)
    callback_or_next(step, thread, callback, co.resume(thread, ...))
  end

  step(...)
end

local add_leaf_function
do
  ---A table to store all leaf async functions
  local _LeafTable = setmetatable({}, {
    __mode = "k",
  })

  add_leaf_function = function(async_func, argc)
    assert(_LeafTable[async_func] == nil, "vim.__async function should not already be in the table")
    _LeafTable[async_func] = argc
  end

  function M.is_leaf_function(async_func)
    return _LeafTable[async_func] ~= nil
  end

  function M.get_leaf_function_argc(async_func)
    return _LeafTable[async_func]
  end
end

---Creates an async function with a callback style function.
---@param func function: A callback style function to be converted. The last argument must be the callback.
---@param argc number: The number of arguments of func. Must be included.
---@return function: Returns an async function
M.wrap = function(func, argc)
  if not is_callable(func) then
    traceback_error("type error :: expected func, got " .. type(func))
  end

  if type(argc) ~= "number" then
    traceback_error("type error :: expected number, got " .. type(argc))
  end

  local function leaf(...)
    local nargs = select("#", ...)

    if nargs == argc then
      return func(...)
    else
      return co.yield(func, argc, ...)
    end
  end

  add_leaf_function(leaf, argc)

  return leaf
end

---Use this to either run a future concurrently and then do something else
---or use it to run a future with a callback in a non async context
---@param async_function function
---@param callback function
M.run = function(async_function, callback)
  if M.is_leaf_function(async_function) then
    async_function(callback)
  else
    execute(async_function, callback)
  end
end

---Use this to create a function which executes in an async context but
---called from a non-async context. Inherently this cannot return anything
---since it is non-blocking
---@param func function
M.void = function(func)
  return function(...)
    execute(func, nil, ...)
  end
end

local defer_swapped = function(timeout, callback)
  vim.defer_fn(callback, timeout)
end

M.schedule = vim.schedule
M.schedule_wrap = vim.schedule_wrap
M.scheduler = M.wrap(vim.schedule, 1)
M.sleep = M.wrap(defer_swapped, 2)

return M
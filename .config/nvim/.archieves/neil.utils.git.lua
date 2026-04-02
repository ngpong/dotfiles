local root_cache = {}
local function is_root(dir)
  if root_cache[dir] == nil then
    root_cache[dir] = vim.__fs.exists(dir .. "/.git")
  end
  return root_cache[dir]
end
local function get_root(path)
  path = path or vim.__path.cwd()

  local home = vim.__path.home()

  local todo = { path }
  local p = path
  while p do
    local d = vim.__path.dirname(p)
    if p == d or d == home then break end

    table.insert(todo, d)

    p = d
  end

  -- check cache first
  for _, dir in ipairs(todo) do
    if root_cache[dir] then
      return dir
    end
  end

  for _, dir in ipairs(todo) do
    if is_root(dir) then
      return dir
    end
  end

  return os.getenv("GIT_WORK_TREE")
end

local function status_diff()
  local root = get_root()

  local function parse_line_2_path(line)
    if type(line) ~= "string" then
      return
    end

    local line_parts = vim.split(line, "\t")
    if #line_parts < 2 then
      return
    end
    local status = line_parts[1]
    local relative_path = line_parts[2]

    -- rename output is `R000 from/filename to/filename`
    if status:match("^R") then
      relative_path = line_parts[3]
    end

    -- remove any " due to whitespace or utf-8 in the path
    relative_path = relative_path:gsub('^"', ''):gsub('"$', "")

    -- convert octal encoded lines to utf-8
    relative_path = vim.__str.octal_2utf8(relative_path)

    return vim.__path.join(root, relative_path)
  end

  local ret = {}

  local args = { "-C", root, "diff", "--name-status", "HEAD", "--" }

  local ok, result = vim.__util.exec({ "git", vim.__tbl.unpack(args) })
  if ok then
    for _, line in ipairs(result) do
      ret[parse_line_2_path(line)] = true
    end
  else
    vim.__logger.error("exec git status command error.")
  end

  return ret
end

local function if_has_diff(cb_ok, cb_err, path)
  local root = get_root(path)

  local result

  local await_has_diff = vim.__async.wrap(function(callback)
    vim.__job.new({
      command = "git",
      args = { "-C", root, "diff", "--name-status", "HEAD", "--", path or "." },
      on_exit = function(j, _)
        result = j:result()
        callback()
      end,
    }):start()
  end, 1)

  await_has_diff()

  if next(result) and cb_ok then
    vim.__async.scheduler()
    cb_ok(result)
  elseif cb_err then
    cb_err()
  end
end

local function if_has_diff_sync(path)
  local root = get_root(path)

  local ret = false

  vim.__job.new({
    command = "git",
    args = { "-C", root, "diff", "--name-status", "HEAD", "--", path },
    on_stdout = function(err, data, j)
      if not j.is_shutdown then
        ret = true
        j:shutdown()
      end
    end,
  }):sync()

  return ret
end

local if_has_log = vim.__async.void(function(path, cb)
  local root = get_root(path)

  local result

  local await_has_log = vim.__async.wrap(function(callback)
    vim.__job.new({
      command = "git",
      args = { "-C", root, "log", "-1", "--pretty=format:\"%h\"", "--", path },
      on_exit = function(j, _)
        result = j:result()
        callback()
      end,
    }):start()
  end, 1)

  await_has_log()

  if next(result) and cb then
    vim.__async.scheduler()
    cb(result)
  end
end)

local if_has_diff_or_untracked = vim.__async.void(function(path, cb_ok, cb_err)
  local root = get_root(path)

  local result

  local await_is_untracked = vim.__async.wrap(function(callback)
    vim.__job.new({
      command = "git",
      args = { "-C", root, "ls-files", "--exclude-standard", "--others", "--", path },
      on_exit = function(j, _)
        result = j:result()
        callback()
      end,
    }):start()
  end, 1)

  await_is_untracked()
  if next(result) and cb_ok then
    vim.__async.scheduler()
    cb_ok(result)
    return
  end

  local await_has_diff = vim.__async.wrap(function(callback)
    vim.__job.new({
      command = "git",
      args = { "-C", root, "diff", "--name-status", "HEAD", "--", path },
      on_exit = function(j, _)
        result = j:result()
        callback()
      end,
    }):start()
  end, 1)

  await_has_diff()

  vim.__async.scheduler()

  if next(result) and cb_ok then
    cb_ok(result)
    return
  end

  if cb_err then
    cb_err()
  end
end)

return {
  get_root = get_root,
  status_diff = status_diff,
  if_has_diff = if_has_diff,
  if_has_diff_sync = if_has_diff_sync,
  if_has_log = if_has_log,
  if_has_diff_or_untracked = if_has_diff_or_untracked,
}

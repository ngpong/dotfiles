local root = nil

local function valid()
  return root ~= nil
end

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

  -- convert windows path to unix
  relative_path = vim.__path.normalize(relative_path)

  -- convert octal encoded lines to utf-8
  relative_path = vim.__str.octal_2utf8(relative_path)

  return vim.__path.join(root, relative_path)
end

local function status_diff()
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

local function get_workspace(cb)
  if not valid() then
    local job = vim.__job.new({
      command = "git",
      args = { "-C", ".", "rev-parse", "--show-toplevel" },
      on_exit = function(j, _, _)
        local res = j:result()[1]
        if res then
          root = res
          if cb then cb(root) end
        end
      end
    })

    if cb then
      job:start()
      return nil
    else
      job:sync()
      return root
    end
  else
    if cb then
      cb(root)
    else
      return root
    end
  end
end
get_workspace()

return {
  valid = valid,
  status_diff = status_diff,
  if_has_diff = if_has_diff,
  if_has_diff_sync = if_has_diff_sync,
  if_has_log = if_has_log,
  if_has_diff_or_untracked = if_has_diff_or_untracked,
}
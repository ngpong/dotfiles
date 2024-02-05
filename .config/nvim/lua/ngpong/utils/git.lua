local gitter = {}

local lazy  = require('ngpong.utils.lazy')
local async = lazy.require('plenary.async')
local Job   = lazy.require('plenary.job')

local get_repository_root = (function()
  local git_root = nil

  return function(path)
    if git_root == nil then
      local args = { '-C', path, 'rev-parse', '--show-toplevel' }

      local ok, result = TOOLS.exec_cmd({ 'git', TOOLS.tbl_unpack(args) })
      if not ok then
        return nil
      end

      git_root = TOOLS.to_path(result[1])
    end

    return git_root
  end
end)()

local parse_line_2_path = function(line)
  if type(line) ~= "string" then
    return
  end

  local git_root = get_repository_root(TOOLS.get_cwd())

  local line_parts = vim.split(line, '\t')
  if #line_parts < 2 then
    return
  end
  local status = line_parts[1]
  local relative_path = line_parts[2]

  -- rename output is `R000 from/filename to/filename`
  if status:match("^R") then relative_path = line_parts[3] end

  -- remove any " due to whitespace or utf-8 in the path
  relative_path = relative_path:gsub('^"', ""):gsub('"$', "")

  -- convert windows path to unix
  relative_path = TOOLS.to_path(relative_path)

  -- convert octal encoded lines to utf-8
  relative_path = TOOLS.octal_to_utf8(relative_path)

  return TOOLS.path_join(git_root, relative_path)
end

gitter.status_diff = function()
  local ret = {}

  local args = { '-C', get_repository_root(TOOLS.get_cwd()), 'diff', '--name-status', 'HEAD', '--' }

  local ok, result = TOOLS.exec_cmd({ 'git', TOOLS.tbl_unpack(args) })
  if ok then
    for _, line in ipairs(result) do
      ret[parse_line_2_path(line)] = true
    end
  else
    LOGGER.error('exec git status command error.')
  end

  return ret
end

gitter.if_has_diff = async.void(function(path, cb)
  local job = Job.__get()

  local result

  local await_has_diff = async.wrap(function(callback)
    job:new({
      command = 'git',
      args = { '-C', get_repository_root(TOOLS.get_cwd()), 'diff', '--name-status', 'HEAD', '--', path },
      on_exit = function(j, _)
        result = j:result()
        callback()
      end,
    }):start()
  end, 1)

  await_has_diff()

  if next(result) and cb then
    async.util.scheduler()
    cb(result)
  end
end)

gitter.if_has_log = async.void(function(path, cb)
  local job = Job.__get()

  local result

  local await_has_log = async.wrap(function(callback)
    job:new({
      command = 'git',
      args = { '-C', get_repository_root(TOOLS.get_cwd()), 'log', '-1', '--pretty=format:"%h"', '--', path },
      on_exit = function(j, _)
        result = j:result()
        callback()
      end,
    }):start()
  end, 1)

  await_has_log()

  if next(result) and cb then
    async.util.scheduler()
    cb(result)
  end
end)

gitter.if_has_diff_or_untracked = async.void(function(path, cb)
  local job = Job.__get()

  local result

  local await_is_untracked = async.wrap(function(callback)
    job:new({
      command = 'git',
      args = { '-C', get_repository_root(TOOLS.get_cwd()), 'ls-files', '--exclude-standard', '--others', '--', path },
      on_exit = function(j, _)
        result = j:result()
        callback()
      end,
    }):start()
  end, 1)

  await_is_untracked()
  if next(result) and cb then
    async.util.scheduler()
    cb(result)
    return
  end

  local await_has_diff = async.wrap(function(callback)
    job:new({
      command = 'git',
      args = { '-C', get_repository_root(TOOLS.get_cwd()), 'diff', '--name-status', 'HEAD', '--', path },
      on_exit = function(j, _)
        result = j:result()
        callback()
      end,
    }):start()
  end, 1)

  await_has_diff()
  if next(result) and cb then
    async.util.scheduler()
    cb(result)
    return
  end
end)

return gitter

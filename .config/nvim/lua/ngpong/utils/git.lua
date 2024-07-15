local gitter = {}

local libP = require('ngpong.common.libp')

local parse_line_2_path = function(line)
  if type(line) ~= 'string' then
    return
  end

  local git_root = gitter.get_repository_root()

  local line_parts = vim.split(line, '\t')
  if #line_parts < 2 then
    return
  end
  local status = line_parts[1]
  local relative_path = line_parts[2]

  -- rename output is `R000 from/filename to/filename`
  if status:match('^R') then
    relative_path = line_parts[3]
  end

  -- remove any " due to whitespace or utf-8 in the path
  relative_path = relative_path:gsub('^"', ''):gsub('"$', '')

  -- convert windows path to unix
  relative_path = Tools.to_path(relative_path)

  -- convert octal encoded lines to utf-8
  relative_path = Tools.octal_to_utf8(relative_path)

  return Tools.path_join(git_root, relative_path)
end

gitter.get_repository_root = (function()
  local git_root = nil

  return function()
    if git_root == nil then
      libP.job:new({
        command = 'git',
        args = { '-C', '.', 'rev-parse', '--show-toplevel' },
        on_exit = function(self, _, _)
          git_root = self:result()[1]
        end,
      }):sync()
    end

    return git_root
  end
end)()

gitter.status_diff = function()
  local ret = {}

  local args = { '-C', gitter.get_repository_root(), 'diff', '--name-status', 'HEAD', '--' }

  local ok, result = Tools.exec_cmd({ 'git', Tools.tbl_unpack(args) })
  if ok then
    for _, line in ipairs(result) do
      ret[parse_line_2_path(line)] = true
    end
  else
    Logger.error('exec git status command error.')
  end

  return ret
end

gitter.if_has_diff = function(cb_ok, cb_err, path)
  local result

  local await_has_diff = libP.async.wrap(function(callback)
    libP.job:new({
      command = 'git',
      args = { '-C', gitter.get_repository_root(), 'diff', '--name-status', 'HEAD', '--', path or '.' },
      on_exit = function(j, _)
        result = j:result()
        callback()
      end,
    }):start()
  end, 1)

  await_has_diff()

  if next(result) and cb_ok then
    libP.async.util.scheduler()
    cb_ok(result)
  elseif cb_err then
    cb_err()
  end
end

gitter.if_has_diff_sync = function(path)
  local ret = false

  local job = libP.job:new({
    command = 'git',
    args = { '-C', gitter.get_repository_root(), 'diff', '--name-status', 'HEAD', '--', path },
    -- args = { '-C', gitter.get_repository_root(), 'diff-index', 'HEAD', '--', path },
    on_stdout = function(err, data, self)
      if not self.is_shutdown then
        ret = true
        self:shutdown()
      end
    end,
    on_stderr = function(...) -- err, data, self
      -- Logger.info('on_stderr', {...})
    end,
    on_exit = function(self, code, signal)
      Logger.info(self:result())
    end,
  }):sync()

  Logger.info(ret)

  return ret
end

gitter.if_has_log = libP.async.void(function(path, cb)
  local result

  local await_has_log = libP.async.wrap(function(callback)
    libP.job:new({
      command = 'git',
      args = { '-C', gitter.get_repository_root(), 'log', '-1', '--pretty=format:"%h"', '--', path },
      on_exit = function(j, _)
        result = j:result()
        callback()
      end,
    }):start()
  end, 1)

  await_has_log()

  if next(result) and cb then
    libP.async.util.scheduler()
    cb(result)
  end
end)

gitter.if_has_diff_or_untracked = libP.async.void(function(path, cb_ok, cb_err)
  local result

  local await_is_untracked = libP.async.wrap(function(callback)
    libP.job:new({
      command = 'git',
      args = { '-C', gitter.get_repository_root(), 'ls-files', '--exclude-standard', '--others', '--', path },
      on_exit = function(j, _)
        result = j:result()
        callback()
      end,
    }):start()
  end, 1)

  await_is_untracked()
  if next(result) and cb_ok then
    libP.async.util.scheduler()
    cb_ok(result)
    return
  end

  local await_has_diff = libP.async.wrap(function(callback)
    libP.job:new({
      command = 'git',
      args = { '-C', gitter.get_repository_root(), 'diff', '--name-status', 'HEAD', '--', path },
      on_exit = function(j, _)
        result = j:result()
        callback()
      end,
    }):start()
  end, 1)

  await_has_diff()
  if next(result) and cb_ok then
    libP.async.util.scheduler()
    cb_ok(result)
    return
  end

  if cb_err then
    cb_err()
  end
end)

return gitter

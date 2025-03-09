local M = {}

local __cache = {}

vim.__autocmd.on("DirChanged", function()
  __cache.cwd = nil
  __cache.cwdsha1 = nil
  __cache.cwdtail = nil
end)

function M.cwd()
  local cwd = __cache.cwd
  if not cwd then
    local success, dir = pcall(vim.fn.getcwd) -- vim.loop.cwd()
    if success then
      cwd = dir
      __cache.cwd = cwd
    end
  end

  return cwd
end

function M.cwdsha1()
  local cwdsha1 = __cache.cwdsha1
  if not cwdsha1 then
    cwdsha1 = require("sha1").sha1(M.cwd())
    __cache.cwdsha1 = cwdsha1
  end

  return cwdsha1
end

function M.cwdtail()
  local cwdtail = __cache.cwdtail
  if not cwdtail then
    cwdtail = vim.fn.fnamemodify(M.cwd(), ":t")
    __cache.cwdtail = cwdtail
  end

  return cwdtail
end

function M.home()
  local homepath = __cache.homepath
  if not homepath then
    homepath = vim.__util.getenv("HOME")
    __cache.homepath = homepath
  end

  return homepath
end

function M.normalize(p) -- vim.fs.normalize
  -- windows路径统一转换
  local fnl, _ = p:gsub("\\", "/")
  return fnl
end

__cache.standardpath = {}
function M.standard(what)
  local path = __cache.standardpath[what]
  if not path then
    path = vim.api.nvim_call_function("stdpath", { what })
    __cache.standardpath[what] = path
  end

  return path
end

local libgen = require("posix.libgen")
M.basename = libgen.basename
M.dirname = libgen.dirname

local pl_path = require("pl.path")
M.relpath = pl_path.relpath
M.join = pl_path.join
M.expanduser = pl_path.expanduser

return M
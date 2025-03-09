local M = {}

local ffi = require("ffi")

local C = ffi.C

function M.human_size(size, options)
  local si = {
    bits = {"b", "Kb", "Mb", "Gb", "Tb", "Pb", "Eb", "Zb", "Yb"},
    bytes = {"B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"},
  }

  local function isNan(num)
    -- http://lua-users.org/wiki/InfAndNanComparisons
    -- NaN is the only value that doesn't equal itself
    return num ~= num
  end

  local function roundNumber(num, digits)
    local fmt = "%." .. digits .. "f"
    return tonumber(fmt:format(num))
  end

  -- copy options to o
  local o = {}
  for key, value in pairs(options or {}) do
      o[key] = value
  end

  local function setDefault(name, default)
      if o[name] == nil then
          o[name] = default
      end
  end
  setDefault("bits", false)
  setDefault("unix", false)
  setDefault("base", 2)
  setDefault("round", o.unix and 1 or 2)
  setDefault("spacer", o.unix and "" or " ")
  setDefault("suffixes", {})
  setDefault("output", "string")
  setDefault("exponent", -1)

  assert(not isNan(size), "Invalid arguments")

  local ceil = (o.base > 2) and 1000 or 1024
  local negative = (size < 0)
  if negative then
      -- Flipping a negative number to determine the size
      size = -size
  end

  local result

  -- Zero is now a special case because bytes divide by 1
  if size == 0 then
      result = {
          0,
          o.unix and "" or (o.bits and "b" or "B"),
      }
  else
      -- Determining the exponent
      if o.exponent == -1 or isNan(o.exponent) then
          o.exponent = math.floor(math.log(size) / math.log(ceil))
      end

      -- Exceeding supported length, time to reduce & multiply
      if o.exponent > 8 then
          o.exponent = 8
      end

      local val
      if o.base == 2 then
          val = size / math.pow(2, o.exponent * 10)
      else
          val = size / math.pow(1000, o.exponent)
      end

      if o.bits then
          val = val * 8
          if val > ceil then
              val = val / ceil
              o.exponent = o.exponent + 1
          end
      end

      result = {
          roundNumber(val, o.exponent > 0 and o.round or 0),
          (o.base == 10 and o.exponent == 1) and
              (o.bits and "kb" or "kB") or
              (si[o.bits and "bits" or "bytes"][o.exponent + 1]),
      }

      if o.unix then
          result[2] = result[2]:sub(1, 1)

          if result[2] == "b" or result[2] == "B" then
              result ={
                  math.floor(result[1]),
                  "",
              }
          end
      end
  end

  assert(result)

  -- Decorating a 'diff'
  if negative then
      result[1] = -result[1]
  end

  -- Applying custom suffix
  result[2] = o.suffixes[result[2]] or result[2]

  -- Applying custom suffix
  result[2] = o.suffixes[result[2]] or result[2]

  -- Returning Array, Object, or String (default)
  if o.output == "array" then
      return result
  elseif o.output == "exponent" then
      return o.exponent
  elseif o.output == "object" then
      return {
          value = result[1],
          suffix = result[2],
      }
  elseif o.output == "string" then
      local value = tostring(result[1])
      value = value:gsub("%.0$", "")
      local suffix = result[2]
      return value .. o.spacer .. suffix
  end
end

ffi.cdef[[
  typedef unsigned long ino_t;
  typedef long off_t;

  typedef struct DIR DIR;
  
  struct dirent {
    ino_t d_ino;
    off_t d_off;
    unsigned short d_reclen;
    unsigned char d_type;
    char d_name[];
  };

  DIR* opendir(const char* name);
  int closedir(DIR* dirp);

  struct dirent* readdir(DIR* dirp);
]]
function M.scandir(path, cb)
  local d = C.opendir(path)
  if d then
    while true do
      local f = C.readdir(d)
      if f == nil then break end

      local fname = ffi.string(f.d_name)
      local ftype = f.d_type

      cb(fname, ftype)
    end

    C.closedir(d)
  end
end

function M.getline(buffer, row, nil_result)
  if row <= 0 then
    return nil_result
  end

  local getline_by_file = function(path)
    local lines = M.readlines(path)
    if not lines or not next(lines) then
      return nil_result
    end

    local line = lines[row]

    return line
  end

  local getline_by_cache = function(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)
    if not lines or not next(lines) then
      return nil_result
    end

    return lines[1]
  end

  if type(buffer) == "number" then
    if vim.fn.bufexists(buffer) < 0 then
      return nil_result
    end

    if vim.__buf.is_loaded(buffer) then
      return getline_by_cache(buffer)
    else
      return getline_by_file(vim.__buf.name(buffer))
    end
  elseif type(buffer) == "string" then
    local bufnr = vim.__buf.number(buffer)

    if vim.fn.bufexists(bufnr) > 0 and vim.__buf.is_loaded(bufnr) then
      return getline_by_cache(bufnr)
    else
      return getline_by_file(buffer)
    end
  else
    assert(false)
  end
end

function M.maxline(path)
  return tonumber(vim.fn.system({ "wc", "-l", path }):match("%d+"))
end

function M.state(path)
  local success, stats = pcall(vim.loop.fs_stat, path)
  if success and stats then
    return stats
  else
    return nil
  end
end

function M.valid(path)
  local stat = M.state(path)
  if not stat or stat.type ~= "file" then
    return false
  else
    return true
  end
end

local pl_utils = require("pl.utils")
local pl_file = require("pl.file")
local pl_dir = require("pl.dir")
local pl_path = require("pl.path")
M.readlines = pl_utils.readlines
M.read = pl_file.read
M.write = pl_file.write
M.makepath = pl_dir.makepath
M.exists = pl_path.exists
M.isdir = pl_path.isdir
M.isfile = pl_path.isfile

return M
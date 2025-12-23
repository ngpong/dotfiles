local M = {}

local ffi = require("ffi")

local C = ffi.C

ffi.cdef[[
  typedef struct FILE FILE;
  FILE *fopen(const char *filename, const char *mode);
  int fclose(FILE *stream);
  ssize_t getline(char **lineptr, size_t *n, FILE *stream);
  void free(void *ptr);
]]

local uv = vim.loop

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

local function __getline_trim(line_ptr, len)
  if len == 0 then return 0 end

  if len >= 2 then
    local last = line_ptr[0][len - 1]
    local prev = line_ptr[0][len - 2]
    if last == 0x0A and prev == 0x0D then
      return len - 2
    end
  end

  local last_char = line_ptr[0][len - 1]
  if last_char == 0x0A or last_char == 0x0D then
    return len - 1
  end

  return len
end
function M.getline(path, lnum)
  if not lnum or lnum <= 0 then return nil end

  local line_str

  local bufnr = vim.__buf.number(path)
  if bufnr > 0 then
    line_str = vim.__buf.getline(bufnr, lnum)
    if line_str then return line_str end
  end

  local fp = ffi.C.fopen(path, "r")
  if fp == nil then return nil end

  local p_line = ffi.new("char*[1]")
  local p_len = ffi.new("size_t[1]", 0)

  local idx = 1
  while true do
    local read = C.getline(p_line, p_len, fp)
    if read == -1 then break end

    if idx == lnum then
      local len = __getline_trim(p_line, read)
      line_str = ffi.string(p_line[0], len)
      break
    end

    idx = idx + 1
  end

  C.fclose(fp)
  if p_line[0] ~= nil then
    C.free(p_line[0])
  end

  return line_str
end

function M.readlines(path)
  local fp = ffi.C.fopen(path, "r")
  if fp == nil then return nil end

  local ret = {}

  local p_line = ffi.new("char*[1]")
  local p_len = ffi.new("size_t[1]", 0)

  while true do
    local read = C.getline(p_line, p_len, fp)
    if read == -1 then break end

    local len = __getline_trim(p_line, read)
    local line_str = ffi.string(p_line[0], len)

    table.insert(ret, line_str)
  end

  C.fclose(fp)
  if p_line[0] ~= nil then
    C.free(p_line[0])
  end

  return ret
end

function M.maxline(path)
  local fp = ffi.C.fopen(path, "r")
  if fp == nil then return nil end

  local p_line = ffi.new("char*[1]")
  local p_len = ffi.new("size_t[1]", 0)

  local counter = 1
  while true do
    local read = C.getline(p_line, p_len, fp)
    if read == -1 then
      break
    end
    counter = counter + 1
  end

  C.fclose(fp)
  if p_line[0] ~= nil then
    C.free(p_line[0])
  end

  return counter
end

function M.state(path)
  return uv.fs_stat(path)
end

function M.executable(path)
  local stat, err = M.state(path)
  if not stat then
    return false, err
  end

  return (stat.type == "file") and
         (bit.band(stat.mode, tonumber('111', 8)) ~= 0)
end

function M.valid(path)
  local stat, err = M.state(path)
  if not stat or stat.type ~= "file" then
    return false, err
  else
    return true
  end
end

function M.readable(path)
  return uv.fs_access(path, "r")
end

local pl_utils = require("pl.utils")
local pl_file = require("pl.file")
local pl_dir = require("pl.dir")
local pl_path = require("pl.path")
M.read = pl_file.read
M.write = pl_file.write
M.makepath = pl_dir.makepath
M.exists = pl_path.exists
M.isdir = pl_path.isdir
M.isfile = pl_path.isfile

return M

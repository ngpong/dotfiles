local M = {}

local ffi = require "ffi"

local C = ffi.C

ffi.cdef [[
  typedef unsigned char char_u;
  int linetabsize_col(int startcol, char_u *s);
]]

local CHAR_ARRAY = ffi.typeof("char[?]")
function M.displaywidth(str, col)
  local startcol = col or 0
  local s = CHAR_ARRAY(#str + 1)
  ffi.copy(s, str)
  return C.linetabsize_col(startcol, s) - startcol
end

function M.octal_2utf8(text)
  local convert_octal_char = function(octal)
    return string.char(tonumber(octal, 8))
  end

  -- git uses octal encoding for utf-8 filepaths, convert octal back to utf-8
  local success, converted = pcall(string.gsub, text, "\\([0-7][0-7][0-7])", convert_octal_char)
  if success then
    return converted
  else
    return text
  end
end

function M.trim(str)
  return vim.trim(str)
end

function M.fill_tail(str, char, count)
  local ret = str

  for i = 1, count, 1 do
    ret = ("%s%s"):format(ret, char)
  end

  return ret
end

function M.encode(o)
  return require("string.buffer").encode(o)
end

function M.decode(o)
  return require("string.buffer").encode(o)
end

return M
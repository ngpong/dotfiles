local M = {}

function M.displaywidth(str)
  return vim.api.nvim_strwidth(str)
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

function M.align(text, width, opts)
  text = text or ""
  opts = opts or {}
  opts.align = opts.align or "left"
  local tw = vim.api.nvim_strwidth(text)
  if tw > width then
    return opts.truncate and (vim.fn.strcharpart(text, 0, width - 1) .. "…") or text
  end
  local left = math.floor((width - tw) / 2)
  local right = width - tw - left
  if opts.align == "left" then
    left, right = 0, width - tw
  elseif opts.align == "right" then
    left, right = width - tw, 0
  end
  return (" "):rep(left) .. text .. (" "):rep(right)
end

function M.encode(o)
  return require("string.buffer").encode(o)
end

function M.decode(o)
  return require("string.buffer").encode(o)
end

return M

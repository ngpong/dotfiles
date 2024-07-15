local colors = Plgs.colorscheme.colors

return {
  normal = {
    a = { bg = colors.bright_blue, fg = colors.dark0 },
    b = { bg = colors.dark1, fg = colors.light4 },
    c = { bg = colors.dark1, fg = colors.light4 },
  },
  insert = {
    a = { bg = colors.bright_red, fg = colors.dark0 },
    b = { bg = colors.dark1, fg = colors.light4 },
    c = { bg = colors.dark1, fg = colors.light4 },
  },
  visual = {
    a = { bg = colors.bright_orange, fg = colors.dark0 },
    b = { bg = colors.dark1, fg = colors.light4 },
    c = { bg = colors.dark1, fg = colors.light4 },
  },
  replace = {
    a = { bg = colors.dark1, fg = colors.dark0 },
    b = { bg = colors.dark1, fg = colors.light4 },
    c = { bg = colors.dark1, fg = colors.light4 },
  },
  command = {
    a = { bg = colors.bright_green, fg = colors.dark0 },
    b = { bg = colors.dark1, fg = colors.light4 },
    c = { bg = colors.dark1, fg = colors.light4 },
  },
  inactive = {
    a = { bg = colors.dark1, fg = colors.light4 },
    b = { bg = colors.dark1, fg = colors.light4 },
    c = { bg = colors.dark1, fg = colors.light4 },
  },
}

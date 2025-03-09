local icons = {
  unix = "",
  mac = "",
  windows = "",

  activets = "",
  activelsp = "",

  arrow_left_1 = "",
  arrow_right_1 = "",
  arrow_right_2 = "➜",
  arrow_right_3 = "󰁕",

  cursor_1 = "󰆿",
  cursor_2 = "󰳽",
  bookmarks = "󰬔",
  ok = "",
  close = "󰅖",
  big_dot = "",
  mid_dot = "●",
  small_dot = "",
  debugger = "",
  pen = "✎",
  ellipsis = "…",
  separator = " ",
  star = "★",
  caution = "󰒡",
  eye_1 = "󰈈",
  eye_2 = "󰷊",
  record = "",
  play = "",

  diagnostic_err = "󰅙",
  diagnostic_hint = "󰌵",
  diagnostic_info = "󰰄",
  diagnostic_warn = "󰀦",

  file_1 = "󰈙",
  file_2 = "",
  file_3 = "",
  files_1 = "󰉓",
  files_2 = "󱔗",
  filereadonly = "󰈡",
  directory = "󰉋",
  directory_opened = "󰝰",
  empty_directory = "󰉖",
  empty_directory_opened = "󰷏",

  git_1 = "󰊢",
  git_2 = "",
  git_3 = "",
  git_4 = "",
  git_5 = "",
  git_6 = "",
  git_add = "󰐖",
  git_change = "󰦓",
  git_conflict = "󰀧",
  git_delete = "󰍵",
  git_ignored = "󰔌",
  git_renamed = "󰑕",
  git_staged = "󰺦",
  git_unstaged = "󰺨",
  git_untracked = "󰞋",

  template = "",
  box_1 = "󰆧",
  box_2 = "",
  tag = "󰜢",
  source = "",

  -- border = { "", "▄", "", "▌", "", "▀", "", "▐" },
  -- border = { "", "", "", "", "", "", "", "" },
  -- border = { "▄", "▄", "▄", "█", "▀", "▀", "▀", "█" },
  -- border = { " ", " ", " ", " ", " ", " ", " ", " " },
  border = {
    yes = "rounded",
    no = { "", "", "", " ", "", "", "", " " }
  },

  braces = "󰅩",
  alpha = "󰀫",
  skip_next = "󰒭",
  repeatd = "󰑖",
  paste = "󰅌",
  refresh = "",
  search = "",
  selected = "❯",
  session = "󱂬",
  sort = "󰒺",
  spellcheck = "󰓆",
  terminal_1 = "",
  terminal_2 = "",
  space = " ",
  setting_1 = "",
  setting_2 = "",
  electricity = "",
  rabbit = "󰤇",
  cat = "󰄛",
  left_half_1 = "",
  right_half_1 = "",
  left_harf_2 = "",
  right_harf_2 = "",
  lines = "",
  location = "",
  alarm = "󰀠",
  clock = "",
  closepand = "",
  expand = "",
  indent_guid = vim.g.neovide and "▏" or "⁞",
  indent_marker_1 = "┆",
  indent_marker_2 = "└",
  indent_marker_3 = "│",
  import = "",
  keyboard = "",
  sleep = "󰒲",
  vim = "",
  lua = "󰢱",
  yes = "✔",
  yes_small = "",
  pinned_1 = "",
  pinned_2 = "󰐃",
  pinned_3 = "📌",
  fire = "",
  spinner_frames_1 = {
    spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
    ok = "󰩐",
  },
  spinner_frames_2 = {
    spinner = { "⠴", "⠲", "⠖", "⠦" },
    ok = "󰾨",
  },
  spinner_frames_3 = {
    spinner = { "⠁", "⠂", "⠄", "⠠", "⠐", "⠈" },
    ok = "󰾨",
  },
  spinner_frames_4 = {
    spinner = { "⠉", "⠆", "⠤", "⠰" },
    ok = "󰾨",
  },
  spinner_frames_5 = {
    spinner = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
    ok = "█",
  },
  spinner_frames_6 = {
    spinner = { "▰▱▱▱▱▱▱", "▰▱▱▱▱▱▱", "▰▰▱▱▱▱▱", "▰▰▰▱▱▱▱", "▰▰▰▰▱▱▱", "▰▰▰▰▰▱▱", "▰▰▰▰▰▰▱", "▰▰▰▰▰▰▰" },
    ok = "▰▰▰▰▰▰▰",
  },
  spinner_frames_7 = {
    spinner = { "🌑", "🌒", "🌓", "🌔", "🌕" },
    ok = "🌕",
  },
  spinner_frames_8 = {
    spinner = { "󰪞", "󰪟", "󰪠", "󰪡", "󰪢", "󰪣", "󰪤", "󰪥", "󰪤", "󰪣", "󰪢", "󰪡", "󰪠", "󰪟", "󰪞" },
    ok = "󰾨"
  },
}

icons.lsp_kinds = {
  Text = { val = "󰉿", hl = "BlinkCmpKindText" }, -- 󱀍 󰀬  󰉿
  Method = { val = "󰊕", hl = "BlinkCmpKindMethod" }, -- 󰊕 󰆧
  Function = { val = "󰊕", hl = "BlinkCmpKindFunction" },
  Constructor = { val = "󰒓", hl = "BlinkCmpKindConstructor" }, -- 󰒓  
  Field = { val = "", hl = "BlinkCmpKindField" }, --  󰜢
  Variable = { val = "", hl = "BlinkCmpKindVariable" }, -- 󰀫 󰆦
  Class = { val = "󱡠", hl = "BlinkCmpKindClass" }, -- 󱡠 
  Struct = { val = "󱡠", hl = "BlinkCmpKindStruct" }, --   󱡠
  Object = { val = "", hl = "BlinkCmpKindObject" },
  Interface = { val = "", hl = "BlinkCmpKindInterface" },
  Module = { val = "󰏗", hl = "BlinkCmpKindModule" }, -- 󰅩
  Namespace = { val = "󰅴", hl = "BlinkCmpKindNamespace" }, -- 󰅩
  Property = { val = "", hl = "BlinkCmpKindProperty" }, --   󰖷
  Unit = { val = "󰑭", hl = "BlinkCmpKindUnit" },
  Value = { val = "󱀍", hl = "BlinkCmpKindValue" }, -- 󰎠
  Number = { val = "󰎠", hl = "BlinkCmpKindNumber" },
  Array = { val = "󰅪", hl = "BlinkCmpKindArray" },
  Enum = { val = "", hl = "BlinkCmpKindEnum" },
  EnumMember = { val = "", hl = "BlinkCmpKindEnumMember" },
  Keyword = { val = "󰻾", hl = "BlinkCmpKindKeyword" }, -- 󰻾 󰌋
  Key = { val = "󰻾", hl = "BlinkCmpKindKey" },
  Snippet = { val = "󰩫", hl = "BlinkCmpKindSnippet" }, --  󱄽
  Color = { val = "󰏘", hl = "BlinkCmpKindColor" },
  File = { val = "󰈙", hl = "BlinkCmpKindFile" }, -- 󰈔
  Reference = { val = "󰈇", hl = "BlinkCmpKindReference" }, -- 󰬲
  Folder = { val = "󰉋", hl = "BlinkCmpKindFolder" },
  Copilot = { val = "", hl = "BlinkCmpKindCopilot" },
  String = { val = "󰉾", hl = "BlinkCmpKindString" },
  Constant = { val = "󰏿", hl = "BlinkCmpKindConstant" },
  Event = { val = "󱐋", hl = "BlinkCmpKindEvent" }, -- 󱐋 
  Operator = { val = "󰆕", hl = "BlinkCmpKindOperator" }, --  󰪚
  Type = { val = "", hl = "BlinkCmpKindType" }, -- 󰆩 󰊄 
  TypeParameter = { val = "󰊄", hl = "BlinkCmpKindTypeParameter" }, -- 󰆩 
  Package = { val = "󰏖", hl = "BlinkCmpKindPackage" }, -- 󰆦
  StaticMethod = { val = "󰠄", hl = "BlinkCmpKindStaticMethod" },
  Null = { val = "󰢤", hl = "BlinkCmpKindNull" },
  Boolean = { val = "◩", hl = "BlinkCmpKindBoolean" },
}
icons.lsp_menus = {
  nvim_lsp = "[LSP]",
  luasnip = "[SNIP]",
  buffer = "[BUFF]",
  async_path = "[PATH]",
}

function icons.get_all_lsp_hllink()
  local ret = {}

  for type, tb in pairs(icons.lsp_kinds) do
    if vim.__util.is_callable(tb) then
      goto continue
    end

    ret[type] = tb.hl_link

    ::continue::
  end

  return ret
end


local icon_color_cache = {}
local default_opts = { default = true }
function icons.get_icon_color_by_ft(ft)
  local cache = icon_color_cache[ft]
  if not cache then
    local icon, hl = vim.__webicons.get_icon_color_by_filetype(ft, default_opts)
    cache = { icon, { fg = hl } }
    icon_color_cache[ft] = cache
  end

  return cache[1], cache[2]
end

return icons

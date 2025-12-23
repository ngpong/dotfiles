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
  cursor_2 = "󰆾",
  bookmark = "󰃁",
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

  diagnostic_error = "󰅙",
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
    no = { "", "", "", "▌", "", "", "", "▐" },
    left = { " ", " ", " ", " ", " ", " ", " ", "│" },
    top = { " ", "-", " ", " ", " ", " ", " ", " " },
    raw_no = "none",
    no_but_title = { " ", " ", " ", " ", " ", " ", " ", " " },
    no_but_title_slim = { " ", " ", " ", "▌", "", "", "", "▐" },
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
  indent_guid = "▏", -- ▏⁞
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
  Class = { val = "󰆼", hl = "BlinkCmpKindClass" }, -- 󱡠 
  Struct = { val = "󱡠", hl = "BlinkCmpKindStruct" }, --   󱡠
  Object = { val = "", hl = "BlinkCmpKindObject" },
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
  Boolean = { val = "◩", hl = "BlinkCmpKindBoolean" }, -- 󰨙
  Unknown = { val = "", hl = "BlinkCmpKindUnknown" },
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

function icons.get_icon_color(name, ext)
  local webicons = vim.__webicons.get_icons()

  local icondata -- get icon by name
  if name then
    icondata = webicons[name:lower()]
  end
  if not icondata then -- get icon by ext
    ext = ext or vim.__path.ext(name)
    if ext then
      icondata = webicons[ext]
    end
  end
  if not icondata then -- default icon
    icondata = webicons[1]
  end

  local icon_name = icondata.name
  return icondata.icon, (icon_name and "DevIcon" .. icon_name or "DevIconDefault")
end

function icons.get_icon_color_by_ft(ft)
  local webicons = vim.__webicons.get_icons()

  local name = vim.__webicons.get_icon_name_by_filetype(ft)
  local icondata -- get icon by name
  if name then
    icondata = webicons[name:lower()]
  end
  if not icondata then -- default icon
    icondata = webicons[1]
  end

  local icon_name = icondata.name
  return icondata.icon, (icon_name and "DevIcon" .. icon_name or "DevIconDefault")
end

return icons

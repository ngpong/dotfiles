return {
  "nvim-treesitter/nvim-treesitter",
  main = "nvim-treesitter",
  lazy = vim.fn.argc(-1) == 0,
  event = { "LazyFile", "VeryLazy" },
  branch = "main",
  build = ":TSUpdate",
  highlights = {
    { "@string", fg = vim.__color.bright_green },
    { "@operator", fg = vim.__color.light4 },
    { "@operators", fg = vim.__color.light2 },
    { "@parameter", fg = vim.__color.light2 },
    { "@conditional", fg = vim.__color.bright_red, italic = true },
    { "@lsp.type.parameter", fg = vim.__color.light1 },
    { "@lsp.type.operator", fg = nil },
    { "@punctuation.bracket", fg = vim.__color.light2 },
    { "@punctuation.delimiter", fg = vim.__color.light2 },
    { "@constructor.lua", fg = vim.__color.light2 },
    { "@constant.builtin.lua", fg = vim.__color.bright_red, italic = true },
    { "@type.qualifier", fg = vim.__color.bright_red, italic = true },
    { "@keyword.return", fg = vim.__color.bright_red, italic = true },
    { "@keyword.operator", fg = vim.__color.bright_red, italic = true },
    { "@keyword.repeat", fg = vim.__color.bright_red, italic = true },
    { "@keyword.conditional", fg = vim.__color.bright_red, italic = true },
    { "@keyword.function", fg = vim.__color.bright_red, italic = true },
    { "@keyword.conditional.ternary", fg = vim.__color.light4 },
    { "@keyword", fg = vim.__color.bright_red, italic = true },
    { "@repeat", fg = vim.__color.bright_red, italic = true },
    { "@namespace", fg = vim.__color.bright_green, italic = true },
    { "@markup.link.label.markdown_inline", fg = vim.__color.bright_yellow },
  },
  opts_extend = { "ensure_install" },
  opts = {
    ensure_install = {},
  },
  config = function(_, opts)
    local ensure_parse    = {}
    local ensure_filetype = {}
    for _, v in ipairs(opts.ensure_install) do
      local parse
      local fts

      if type(v) == "table" then
        parse = v.parse
        fts = type(v.ft) == "string" and { v.ft } or v.ft
      else
        parse = v
        fts = { v }
      end

      table.insert(ensure_parse, parse)
      for _, ft in ipairs(fts) do
        table.insert(ensure_filetype, ft)
      end
      vim.treesitter.language.register(parse, fts)
    end

    opts.ensure_install = ensure_parse
    require("nvim-treesitter").setup(opts)
    -- enhance tinyd performance?
    -- https://www.reddit.com/r/neovim/comments/1144spy/will_treesitter_ever_be_stable_on_big_files/

    -- treesitter enabled, include highlight, textobject functional
    vim.__autocmd.augroup("treesitter"):on("FileType", function(args)
      local bufnr = args.buf
      local ft    = args.match

      if vim.__buf.size(bufnr) >= vim.__filter.max_size[3] then
        return
      end

      if vim.__buf.is_valid(bufnr) then
        vim.treesitter.start(bufnr, vim.treesitter.language.get_lang(ft))
        -- vim.bo[bufnr].syntax = "ON" -- enable legcy highlight engine if needed
      end
    end, { pattern = ensure_filetype })
  end,
}

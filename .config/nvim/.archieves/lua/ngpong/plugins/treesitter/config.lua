local M = {}

M.setup = function()
  require("nvim-treesitter.configs").setup {
    ensure_installed = {
      "c",
      "cpp",
      "query",
      "vim",
      "toml",
      "vimdoc",
      "regex",
      "json",
      "lua",
      "bash",
      "perl",
      "cmake",
      "markdown",
      "markdown_inline",
      "editorconfig",
      "git_config",
      "yaml",
      "gitattributes",
      "gitignore"
    },
    sync_install = false,
    auto_install = false,
    ignore_install = {},
    highlight = {
      enable = true,
      disable = function(bufnr)
        return vim.__buf.size(bufnr) >= vim.__filter.max_size[2]
      end,
      additional_vim_regex_highlighting = false,
    },
    textobjects = {
      select = {
        enable = false,
        lookahead = false,
        -- keymaps = {
        --   ["af"] = "@function.outer",
        --   ["if"] = "@function.inner",
        --   ["ac"] = "@class.outer",
        --   ["ic"] = { query = "@class.inner" },
        -- },
        -- selection_modes = {
        --   ["@parameter.outer"] = "v", -- charwise
        --   ["@function.outer"] = "V", -- linewise
        --   ["@class.outer"] = "<c-v>", -- blockwise
        -- },
        include_surrounding_whitespace = true,
      },
      swap = {
        enable = false,
      },
      lsp_interop = {
        enable = false,
      },
      move = {
        enable = true, -- not used but control by keys.lua
        set_jumps = true, -- whether to set jumps in the jumplist
      },
    },
  }
end

return M

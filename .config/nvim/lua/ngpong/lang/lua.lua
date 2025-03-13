return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_install = { "lua" }
    }
  },
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "stylua" } }
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        lua_ls = {
          cmd = {
            "lua-language-server",
            -- "--configpath=~/.config/lua_ls/.luarc.json"
            -- --loglevel=trace
          },
          single_file_support = true,
          filetypes = { "lua" },
        },
      },
    },
  },
}
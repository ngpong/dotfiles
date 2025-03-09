return {
  "nvim-treesitter/nvim-treesitter",
  optional = true,
  opts = {
    ensure_install = {
      { parse = "git_config", ft = "gitconfig" },
      { parse = "diff", ft = "gitdiff" },
      { parse = "git_rebase", ft = "gitrebase" },
      { parse = "gitattributes", ft = "gitattributes" },
      { parse = "gitignore", ft = "gitignore" },
    }
  }
}
return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        opts = {
          select = {
            lookahead = true,
            selection_modes = {
              ["@parameter.outer"] = "v", -- charwise
              ["@function.outer"] = "V", -- linewise
              ["@function.inner"] = "V", -- linewise
              ["@class.outer"] = "V", -- linewise
            },
            include_surrounding_whitespace = false,
          }
        }
      }
    },
    keys = {
      { "[f", function() pcall(require("nvim-treesitter-textobjects.move").goto_previous_end, "@function.outer") end, mode = { "n", "v", "o" } },
      { "]f", function() pcall(require("nvim-treesitter-textobjects.move").goto_next_start, "@function.inner") end, mode = { "n", "v", "o" } },
      { "[c", function() pcall(require("nvim-treesitter-textobjects.move").goto_previous_end, "@class.outer") end, mode = { "n", "v", "o" } },
      { "]c", function() pcall(require("nvim-treesitter-textobjects.move").goto_next_start, "@class.inner") end, mode = { "n", "v", "o" } },
      { "[o", function() pcall(require("nvim-treesitter-textobjects.move").goto_previous_end, "@conditional.outer") end, mode = { "n", "v", "o" } },
      { "]o", function() pcall(require("nvim-treesitter-textobjects.move").goto_next_start, "@conditional.inner") end, mode = { "n", "v", "o" } },
      { "[O", function() pcall(require("nvim-treesitter-textobjects.move").goto_previous_end, "@loop.outer") end, mode = { "n", "v", "o" } },
      { "]O", function() pcall(require("nvim-treesitter-textobjects.move").goto_next_start, "@loop.inner") end, mode = { "n", "v", "o" } },
    },
  },
  {
    "nvim-mini/mini.ai",
    main = "mini.ai",
    lazy = true,
    event = "VeryLazy",
    opts = function()
      return {
        custom_textobjects = {
          A = require("mini.ai").gen_spec.function_call(),
          f = require("mini.ai").gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
          c = require("mini.ai").gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
          o = require("mini.ai").gen_spec.treesitter({ a = '@conditional.outer', i = '@conditional.inner' }),
          O = require("mini.ai").gen_spec.treesitter({ a = '@loop.outer', i = '@loop.inner' }),
        },
        mappings = {
          goto_left = "",
          goto_right = "",
        },
        silent = true,
        n_lines = 500,
      }
    end
  }
}

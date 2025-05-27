-- NOTE:
-- 目前 mini.ai 中对 treesitter 的支持停留在 master 分支，但
-- 是目前项目已全面切换到了 main 分支，故存在不兼容的情况。正
-- 常来说，textobjects 的支持应该完全有 mini.ai 来做。
-- 检查 ai.lua 文件中的 gen_spec.treesitter 示例来完成最后的配置。

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
              ["@class.outer"] = "V", -- linewise
            },
            include_surrounding_whitespace = false,
          }
        }
      }
    },
    keys = {
      { "af", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer") end, mode = { "o", "v" } },
      { "if", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.inner") end, mode = { "o", "v" } },
      { "ac", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.outer") end, mode = { "o", "v" } },
      { "ic", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.inner") end, mode = { "o", "v" } },
      { "ao", function() require("nvim-treesitter-textobjects.select").select_textobject("@conditional.outer") end, mode = { "o", "v" } },
      { "io", function() require("nvim-treesitter-textobjects.select").select_textobject("@conditional.inner") end, mode = { "o", "v" } },
      { "aO", function() require("nvim-treesitter-textobjects.select").select_textobject("@loop.outer") end, mode = { "o", "v" } },
      { "iO", function() require("nvim-treesitter-textobjects.select").select_textobject("@loop.inner") end, mode = { "o", "v" } },

      { "[f", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer") end, mode = { "n", "v", "o" } },
      { "]f", function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.inner") end, mode = { "n", "v", "o" } },
      { "[c", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer") end, mode = { "n", "v", "o" } },
      { "]c", function() require("nvim-treesitter-textobjects.move").goto_next_start("@class.inner") end, mode = { "n", "v", "o" } },
      { "[o", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@conditional.outer") end, mode = { "n", "v", "o" } },
      { "]o", function() require("nvim-treesitter-textobjects.move").goto_next_start("@conditional.inner") end, mode = { "n", "v", "o" } },
      { "[O", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@loop.outer") end, mode = { "n", "v", "o" } },
      { "]O", function() require("nvim-treesitter-textobjects.move").goto_next_start("@loop.inner") end, mode = { "n", "v", "o" } },
    },
  },
  {
    "echasnovski/mini.ai",
    main = "mini.ai",
    lazy = true,
    event = "VeryLazy",
    opts = function()
      return {
        custom_textobjects = {
          f = "",
          F = require("mini.ai").gen_spec.function_call(),
        },
        mappings = {
          goto_left = "",
          goto_right = "",
        },
        silent = true,
      }
    end
  }
}

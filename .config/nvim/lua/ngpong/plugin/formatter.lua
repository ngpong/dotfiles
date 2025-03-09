return {
  "stevearc/conform.nvim",
  lazy = true,
  cmd = "ConformInfo",
  init = function()
    vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  keys = {
    {
      "fQ",
      function()
        local opts = {
          bufnr = 0,
          async = false,
          timeout_ms = 500,
          lsp_fallback = false,
          quiet = false,
          callback = nil, -- function
        }
        vim.__ui.input({ prompt = "This operation will format the entire file, yes(y) or no(n,...)?", relative = "editor" }, function(res)
          if res ~= "y" then
            return
          end
          require("conform").format(opts)
        end)
      end
    }
  },
  opts = {
    formatters_by_ft = {
      c = { "clang-format", },
      cpp = { "clang-format", },
      lua = { "stylua", },
    },
    format_on_save = nil,
    format_after_save = nil,
    log_level = vim.log.levels.ERROR,
    notify_on_error = true,
    formatters = {
      ["clang-format"] = {
        command = "clang-format-19",
        prepend_args = { "-style=file" },
      }
    },
  }
}
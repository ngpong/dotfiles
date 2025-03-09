local M = {}

local Conform = vim.__lazy.require("conform")

M.setup = function()
  Conform.setup({
    -- Map of filetype to formatters
    formatters_by_ft = {
      c = { "clang-format", },
      cpp = { "clang-format", },
      lua = { "stylua", },
    },
    -- If this is set, Conform will run the formatter on save.
    -- It will pass the table to conform.format().
    -- This can also be a function that returns the table.
    format_on_save = nil,
    -- If this is set, Conform will run the formatter asynchronously after save.
    -- It will pass the table to conform.format().
    -- This can also be a function that returns the table.
    format_after_save = nil,
    -- Set the log level. Use `:ConformInfo` to see the location of the log file.
    log_level = vim.log.levels.ERROR,
    -- Conform will notify you when a formatter errors
    notify_on_error = true,
    -- Custom formatters and changes to built-in formatters
    formatters = {
      ["clang-format"] = {
        command = "clang-format-19",
        prepend_args = { "-style=file" },
      }
    },
  })
end

return M

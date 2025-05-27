local M = {}

M.config = {
  formatters = {
    pos = function(ctx)
      local hl = "TroublePos"
      if ctx.item.invalid_pos then
        hl = "TroubleInvalidPos"
      end

      return {
        text = "[" .. ctx.item.pos[1] .. "," .. (ctx.item.pos[2] + 1) .. "]",
        hl = hl
      }
    end,
    comma = function(_)
      return {
        text = ":",
        hl = "TroubleFormattersComma"
      }
    end,
  },
}

function M.setup()
  vim.api.nvim_set_hl(0, "TroubleFormattersComma", { fg = vim.__color.bright_yellow })
end

return M

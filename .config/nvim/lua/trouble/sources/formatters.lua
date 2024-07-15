local M = {}

M.config = {
  formatters = {
    pos = function(ctx)
      return {
        text = '[' .. ctx.item.pos[1] .. ',' .. (ctx.item.pos[2] + 1) .. ']',
      }
    end,
  },
}

return M

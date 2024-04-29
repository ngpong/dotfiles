local M = {}

M.setup = function()
  require('spider').setup {
    skipInsignificantPunctuation = true,
    subwordMovement = true,
    customPatterns = {},
  }
end

return M

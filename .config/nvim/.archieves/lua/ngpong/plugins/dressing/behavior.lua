local M = {}

local etypes = vim.__event.types

M.setup = function()
  vim.__event.rg(etypes.FILE_TYPE, vim.__async.schedule_wrap(function(state)
    if "DressingInput" ~= state.file then
      return
    end

    local completion = not vim.__util.isempty(vim.bo[state.buf].completefunc) and true or false

    vim.bo[state.buf].omnifunc = ""
    vim.bo[state.buf].completefunc = ""

    vim.__event.emit(etypes.OPEN_DRESSING_INPUT, {
      bufnr = state.buf,
      completion = completion }
    )
  end))
end

return M

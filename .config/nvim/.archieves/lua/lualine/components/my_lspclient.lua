local LualineRequire   = require("lualine_require")
local LualineComponent = LualineRequire.require("lualine.component")
local LualineUtilsMode = LualineRequire.require("lualine.utils.mode")

local M = LualineComponent:extend()
local C = {}

local spinner_icon =  vim.__icons.spinner_frames_8
local spinner_icon_progress = spinner_icon.spinner
local spinner_icon_size = #spinner_icon_progress
local spinner_icon_ok = vim.__icons.activets

local elements = {
  {
    val = function()
      if C.spinner then
        return spinner_icon_progress[C.spinner]
      else
        return spinner_icon_ok
      end
    end,
    name = "e1",
    fg_hl = vim.__color.bright_green,
  },
  {
    val = function()
      local clis = vim.lsp.get_clients({ bufnr = vim.__buf.current() })
      if next(clis) then
        return clis[1].name:gsub("_", "")
      else
        return ""
      end
    end,
    name = "e2",
    fg_hl = vim.__color.light1,
  },
}

local process = function()
  if C.is_processing then
    return
  else
    C.is_processing = true
  end

  C.spinner = 1
  vim.__stl:refresh({}, true)

  local count = 1

  local function __process()
    vim.defer_fn(function()
      if not next(C.active_tokens) and count >= spinner_icon_size then
        C.spinner = nil
        C.is_processing = false
        vim.__stl:refresh({}, true)
        return
      end

      count = count + 1

      local next_s = C.spinner + 1
      if next_s > spinner_icon_size then
        C.spinner = 1
      else
        C.spinner = (next_s == spinner_icon_size and next_s or (next_s % spinner_icon_size))
      end

      vim.__stl:refresh({}, true)

      __process()
    end, 50)
  end

  __process()
end

local apply_hl = function(self)
  for _, element in pairs(elements) do
    element.hl_token = self:create_hl({ fg = element.fg_hl, gui = element.gui }, element.name)
  end
end

local apply_autocmd = function(self)
  C.active_tokens = {}

  vim.__autocmd.augroup("lualine_components_lspclient"):on(
    "LspProgress",
    vim.__async.schedule_wrap(function(state)
      local params = state.data.params

      if params.value.kind == "begin" then
        C.active_tokens[params.token] = true
        process()
      elseif params.value.kind == "end" then
        C.active_tokens[params.token] = nil
      end
    end)
  )
end

M.init = function(self, options)
  M.super.init(self, options)

  apply_hl(self)
  apply_autocmd(self)
end

M.update_status = function(self, _)
  local results = {}
  for _, element in ipairs(elements) do
    local val
    if type(element.val) == "function" then
      val = element.val()
    else
      val = element.val
    end

    local text = self:format_hl(element.hl_token) .. val

    results[#results + 1] = text
  end

  if #results > 0 then
    return table.concat(results, " ")
  else
    return ""
  end
end

return M

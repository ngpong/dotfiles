local M = {}

local Telescope = vim.__lazy.require("telescope")
local Extensions = vim.__lazy.require("telescope._extensions")

M.native_vim_grep = function()
  local config = Extensions._config["fzf"]

  local sorter = Telescope.extensions.fzf.native_fzf_sorter(config)

  sorter.scoring_function = function(...)
    return 1
  end

  local highlighter = sorter.highlighter
  sorter.highlighter = function(self, prompt, display)
    local match = prompt:match("\"(.-)\"")
    if match then
      prompt = match
    end

    return highlighter(self, prompt, display)
  end

  return sorter
end

return M

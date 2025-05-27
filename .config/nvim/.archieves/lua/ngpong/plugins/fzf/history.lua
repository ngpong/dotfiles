local M = {}

local etypes = vim.__event.types

function M.setup()
  local data_path = vim.__path.standard("data")
  local ws_sha1   = vim.__path.cwdsha1()

  local base_path
  vim.__event.rg(etypes.SETUP_FZFLUA, function(cfg)
    vim.__helper.dclock:reset()

    base_path = vim.__path.join(data_path, "fzf_history", "files")
    if not vim.__fs.exists(base_path) then
      vim.__fs.makepath(base_path)
    end
    cfg.files.fzf_opts = cfg.files.fzf_opts or {}
    cfg.files.fzf_opts["--history"] = vim.__path.join(base_path, ws_sha1)

    local base_path = vim.__path.join(data_path, "fzf_history", "grep")
    if not vim.__fs.exists(base_path) then
      vim.__fs.makepath(base_path)
    end
    cfg.grep.fzf_opts = cfg.grep.fzf_opts or {}
    cfg.grep.fzf_opts["--history"] = vim.__path.join(base_path, ws_sha1)

    vim.__helper.dclock()
  end)
end

return M
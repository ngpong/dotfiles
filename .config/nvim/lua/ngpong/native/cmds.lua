local M = {}

M.setup = function()
  -- 重新绑定原生的 command
  vim.cmd.cnoreabbrev('<expr>', 'q', '(getcmdtype()==#\':\'&&getcmdline()==#\'q\')?\'qa\':\'q\'')
  vim.cmd.cnoreabbrev('<expr>', 'q!', '(getcmdtype()==#\':\'&&getcmdline()==#\'q!\')?\'qa!\':\'q!\'')
  vim.cmd.cnoreabbrev('<expr>', 'wq', '(getcmdtype()==#\':\'&&getcmdline()==#\'wq\')?\'wqa\':\'wq\'')
  vim.cmd.cnoreabbrev('<expr>', 'wq!', '(getcmdtype()==#\':\'&&getcmdline()==#\'wq!\')?\'wqa!\':\'wq!\'')

  -- 绑定 user command
  vim.api.nvim_create_user_command('ReloadConfig', Helper.reload_cfg, {})
end

return M
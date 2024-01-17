local M = {}

local keymap = require('ngpong.common.keybinder')

local e_mode = keymap.e_mode

M.setup = function()
  if not HELPER.is_neovide() then
    return
  end

  -- 设置 guifont
  vim.go.guifont = 'CaskaydiaCove Nerd Font Mono'

  -- 控制行距
  vim.go.linespace = 0

  -- 启动鼠标控制
  -- vim.go.mouse = 'a'

  -- 刷新率
  vim.g.neovide_refresh_rate = 144

  -- 鼠标行为
  vim.g.neovide_cursor_animation_length = 0.06 -- 动画长度
  vim.g.neovide_cursor_trail_size = 0.3 -- 尾部拖拽长度
  vim.g.neovide_cursor_antialiasing = true -- 抗锯齿
  vim.g.neovide_cursor_vfx_mode = 'pixiedust' -- 雪花
  vim.g.neovide_cursor_animate_command_line = true -- 切换到命令行使用动画

  -- 样式
  vim.g.neovide_theme = 'dark'

  -- 不透明度
  vim.g.neovide_transparency = 1.0
  vim.g.transparency = 1.0

  -- 空闲的时候也会刷新
  vim.g.neovide_no_idle = true
  vim.g.neovide_refresh_rate_idle = 30

  -- 浮动窗口阴影
  vim.g.neovide_floating_shadow = true

  -- 记住窗口大小
  vim.g.neovide_remember_window_size = true

  -- 下划线描边宽度
  vim.g.neovide_underline_stroke_scale = 1.0

  -- 模拟终端中的复制粘贴行为
  keymap.register(e_mode.INSERT, '<C-S-v>', '<C-o>P', { remap = false, silent = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, '<C-S-v>', 'p', { remap = false, silent = false, desc = 'which_key_ignore' })
  keymap.register(e_mode.COMMAND, '<C-S-v>', '<C-R>*', { silent = false, desc = 'which_key_ignore' })

  -- 最大化
  keymap.register(e_mode.NORMAL, '<f11>', function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end, { desc = 'which_key_ignore' })

  -- 动态修改字体大小
  vim.g.neovide_scale_factor = 1.2
  local function scale(amount)
    local temp = vim.g.neovide_scale_factor + amount
    if temp < 0.5 then
      return
    end
    vim.g.neovide_scale_factor = temp
  end
  keymap.register(e_mode.NORMAL, '<C-=>', TOOLS.wrap_f(scale, 0.1), { desc = 'which_key_ignore' })
  keymap.register(e_mode.NORMAL, '<C-->', TOOLS.wrap_f(scale, -0.1), { desc = 'which_key_ignore' })

  -- neovide 的鼠标使用有问题，为了方便后续排查问题映射一些 debug 使用的 key
  keymap.register(e_mode.INSERT, '<f6>', function()
    vim.api.nvim_command_output('messages')
  end, { remap = false, desc = 'which_key_ignore' })
end

return M

local M = {}

local icons = require('ngpong.utils.icon')

local this = PLGS.todocomments

M.setup = function()
  require('todo-comments').setup({
    signs = false, -- show icons in the signs column
    sign_priority = 8, -- sign priority
    -- keywords recognized as todo comments
    keywords = {
      FIX = {
        icon = icons.debugger .. icons.space, -- icon used for the sign, and in search results
        color = 'error', -- can be a hex color, or a named color (see below)
        alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' }, -- a set of other keywords that all map to this FIX keywords
        -- signs = false, -- configure signs for some keywords individually
      },
      TODO = { icon = icons.yes_small .. icons.space, color = 'info' },
      HACK = { icon = icons.fire .. icons.space, color = 'error' },
      WARN = { icon = icons.diagnostic_warn .. icons.space, color = 'warning', alt = { 'WARNING', 'XXX' } },
      PERF = { icon = icons.diagnostic .. icons.space, alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
      NOTE = { icon = icons.diagnostic_hint .. icons.space, color = 'hint', alt = { 'INFO' } },
      TEST = { icon = icons.clock .. icons.space, color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
    },
    gui_style = {
      fg = 'NONE', -- The gui style to use for the fg highlight group.
      bg = 'BOLD', -- The gui style to use for the bg highlight group.
    },
    colors = {
      error = { 'DiagnosticError' },
      warning = { 'DiagnosticWarn' },
      info = { 'DiagnosticInfo' },
      hint = { 'DiagnosticHint' },
      default = { 'GruvboxOrange' },
      test = { 'GruvboxPurple' },
    },
    merge_keywords = true, -- when true, custom keywords will be merged with the defaults
    -- highlighting of the line containing the todo comment
    -- * before: highlights before the keyword (typically comment characters)
    -- * keyword: highlights of the keyword
    -- * after: highlights after the keyword (todo text)
    highlight = {
      multiline = false, -- enable multine todo comments
      multiline_pattern = '^.', -- lua pattern to match the next multiline from the start of the matched keyword
      multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
      before = 'empty', -- 'fg' or 'bg' or empty
      keyword = 'bg', -- 'fg', 'bg', 'wide', 'wide_bg', 'wide_fg' or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
      after = 'fg', -- 'fg' or 'bg' or empty
      pattern = {
        [[.*<(KEYWORDS)\s*:]],
        [[.*@(KEYWORDS)\s*:]],
      }, -- pattern or table of patterns, used for highlighting (vim regex)
      comments_only = true, -- uses treesitter to match keywords in comments only
      max_line_len = 400, -- ignore lines longer than this
      exclude = this.filter(), -- list of file types to exclude highlighting
    },
    search = {
      args = {
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--hidden',
        '--no-ignore-vcs',
      },
    },
  })
end

return M

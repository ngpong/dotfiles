local M = {}

local Icons = require('ngpong.utils.icon')

M.setup = function()
  require('trouble').setup({
    auto_close = true, -- auto close when there are no items
    auto_open = false, -- auto open when there are items
    auto_preview = false, -- automatically open preview when on an item
    auto_refresh = true, -- auto refresh when open
    auto_jump = false, -- auto jump to the item when there's only one
    focus = true, -- Focus the window when opened
    restore = true, -- restores the last location in the list when opening
    follow = false, -- Follow the current item
    indent_guides = true, -- show indent guides
    max_items = 9999, -- limit number of items that can be displayed per section
    multiline = true, -- render multi-line messages
    pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
    warn_no_results = true, -- show a warning when there are no results
    open_no_results = false, -- open the trouble window when there are no results
    win = {}, -- window options for the results window. Can be a split or a floating window.
    -- Window options for the preview window. Can be a split, floating window,
    -- or `main` to show the preview in the main editor window.
    preview = {
      type = 'split',
      relative = 'win',
      position = 'right',
      size = 0.5,
      scratch = true,
    },
    -- Throttle/Debounce settings. Should usually not be changed.
    throttle = {
      refresh = 100, -- fetches new data when needed
      update = 10, -- updates the window
      render = 10, -- renders the window
      follow = 100, -- follows the current item
      preview = { ms = 20, debounce = true }, -- shows the preview for the current item
    },
    config = function(opts)
      -- Key mappings can be set to the name of a builtin action,
      -- or you can define your own custom action.
      opts.keys = {}
    end,
    formatters = {
      pos = function(ctx)
        return {
          text = '[' .. ctx.item.pos[1] .. ',' .. (ctx.item.pos[2] + 1) .. ']',
        }
      end,
    },
    modes = {
      lsp_base = {
        groups = {
          { 'filename', format = '{file_icon}{filename} {count}' },
        },
        format = '{text:ts} ({item.client}) {pos}',
      },
      lsp_definitions_extra = {
        events = {},
        auto_jump = true,
        mode = 'lsp_base',
        source = 'lsp.definitions',
        desc = 'Lsp definitions',
      },
      lsp_references_extra = {
        events = {},
        params = {
          include_declaration = false,
        },
        auto_jump = false,
        mode = 'lsp_base',
        source = 'lsp.references',
        desc = 'Lsp references',
      },
      lsp_declarations_extra = {
        events = {},
        auto_jump = true,
        mode = 'lsp_base',
        source = 'lsp.declarations',
        desc = 'Lsp declarations',
      },
      diagnostics = {
        format = '{severity_icon}{message:md} {item.source} ({code}) {pos}',
      },
      document_diagnostics = {
        mode = 'diagnostics',
        filter = { buf = 0 },
        groups = {
          { 'filename', format = '{file_icon}{filename} {count}' },
        },
        desc = 'Document diagnostics',
      },
      workspace_diagnostics = {
        mode = 'diagnostics',
        desc = 'Workspace diagnostics',
        groups = {
          { 'filename', format = '{file_icon}{filename} {count}' },
        },
      },
      document_todo = {
        mode = 'todo',
        desc = 'Document todo comments',
        filter = {
          any = {
            buf = 0,
          },
        },
      },
      workspace_todo = {
        mode = 'todo',
        desc = 'Workspace todo comments',
      },
      document_mark = {
        mode = 'mark',
        desc = 'Document marks',
        params = {
          all = false,
        },
      },
      workspace_mark = {
        mode = 'mark',
        desc = 'Workspace marks',
        params = {
          all = true,
        },
      },
      document_git = {
        mode = 'git',
        desc = 'Document git diff',
        groups = {
          { 'head', format = '{git_head}' },
        },
      },
      workspace_git = {
        mode = 'git',
        desc = 'Workspace git diff',
        params = {
          target = 'all',
        },
      },
      lsp_document_symbols_extra = {
        desc = 'Lsp document symbols',
        follow = true,
        win = { position = 'right', size = 0.4 },
        mode = 'lsp_document_symbols',
        focus = false,
        preview = {
          type = 'main',
          scratch = true,
        },
        filter = {
          -- remove Package since luals uses it for control flow structures
          ['not'] = { ft = 'lua', kind = 'Package' },
        },
        title = '{filename} {count}',
        groups = {},
      },
      telescope_multi_selected_files = {
        desc = 'Telescope multi-selected result',
        source = 'telescope',
        sort = { 'filename', 'pos' },
        format = '{file_icon}{filename}',
      },
      telescope_multi_selected_lines = {
        desc = 'Telescope multi-selected result',
        events = {},
        source = 'telescope',
        sort = { 'filename', 'pos' },
        groups = {
          { 'filename', format = '{file_icon} {filename} {count}' },
        },
        format = '{text:ts} {pos}',
      },
    },
    -- stylua: ignore
    icons = {
      indent = {
        last = '╰╴',
      },
      kinds = {
        Array         = Icons.lsp_kinds.Array.val,
        Boolean       = Icons.lsp_kinds.Boolean.val,
        Class         = Icons.lsp_kinds.Class.val,
        Constant      = Icons.lsp_kinds.Constant.val,
        Constructor   = Icons.lsp_kinds.Constructor.val,
        Enum          = Icons.lsp_kinds.Enum.val,
        EnumMember    = Icons.lsp_kinds.EnumMember.val,
        Event         = Icons.lsp_kinds.Event.val,
        Field         = Icons.lsp_kinds.Field.val,
        File          = Icons.lsp_kinds.File.val,
        Function      = Icons.lsp_kinds.Function.val,
        Interface     = Icons.lsp_kinds.Interface.val,
        Key           = Icons.lsp_kinds.Key.val,
        Method        = Icons.lsp_kinds.Method.val,
        Module        = Icons.lsp_kinds.Module.val,
        Namespace     = Icons.lsp_kinds.Namespace.val,
        Null          = Icons.lsp_kinds.Null.val,
        Number        = Icons.lsp_kinds.Number.val,
        Object        = Icons.lsp_kinds.Object.val,
        Operator      = Icons.lsp_kinds.Operator.val,
        Package       = Icons.lsp_kinds.Package.val,
        Property      = Icons.lsp_kinds.Property.val,
        String        = Icons.lsp_kinds.String.val,
        Struct        = Icons.lsp_kinds.Struct.val,
        TypeParameter = Icons.lsp_kinds.TypeParameter.val,
        Variable      = Icons.lsp_kinds.Variable.val,
      },
    },
  })
end

return M

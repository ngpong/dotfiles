local M = {}

M.setup = function()
  require("trouble").setup({
    auto_close = true, -- auto close when there are no items
    auto_open = false, -- auto open when there are items
    auto_preview = false, -- automatically open preview when on an item
    auto_refresh = true, -- auto refresh when open
    auto_jump = false, -- auto jump to the item when there"s only one
    focus = true, -- Focus the window when opened
    restore = true, -- restores the last location in the list when opening
    follow = false, -- Follow the current item
    indent_guides = true, -- show indent guides
    max_items = 200, -- limit number of items that can be displayed per section
    multiline = true, -- render multi-line messages
    pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
    warn_no_results = true, -- show a warning when there are no results
    open_no_results = false, -- open the trouble window when there are no results
    win = {}, -- window options for the results window. Can be a split or a floating window.
    -- Window options for the preview window. Can be a split, floating window,
    -- or `main` to show the preview in the main editor window.
    preview = {
      type = "main",
      scratch = true,
      -- type = "split",
      -- relative = "win",
      -- position = "right",
      -- size = 0.5,
      -- scratch = true,
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
    modes = {
      lsp_base = {
        groups = {
          { "filename", format = "{file_icon}{filename} {count}" },
        },
        format = "{text:ts} ({item.client}) {pos}",
      },
      lsp_definitions_extra = {
        events = {},
        auto_jump = true,
        mode = "lsp_base",
        source = "lsp.definitions",
        desc = "Lsp definitions",
      },
      lsp_references_extra = {
        events = {},
        params = {
          include_declaration = false,
        },
        auto_jump = false,
        mode = "lsp_base",
        source = "lsp.references",
        desc = "Lsp references",
      },
      lsp_declarations_extra = {
        events = {},
        auto_jump = true,
        mode = "lsp_base",
        source = "lsp.declarations",
        desc = "Lsp declarations",
      },
      diagnostics = {
        format = "{severity_icon}{message:md} {item.source} ({code}) {pos}",
      },
      document_diagnostics = {
        mode = "diagnostics",
        filter = { buf = 0 },
        groups = {
          { "filename", format = "{file_icon}{filename} {count}" },
        },
        desc = "Document diagnostics",
      },
      workspace_diagnostics = {
        mode = "diagnostics",
        desc = "Workspace diagnostics",
        groups = {
          { "filename", format = "{file_icon}{filename} {count}" },
        },
      },
    },
    -- stylua: ignore
    icons = {
      indent = {
        last = "╰╴",
      },
      kinds = {
        Array         = vim.__icons.lsp_kinds.Array.val,
        Boolean       = vim.__icons.lsp_kinds.Boolean.val,
        Class         = vim.__icons.lsp_kinds.Class.val,
        Constant      = vim.__icons.lsp_kinds.Constant.val,
        Constructor   = vim.__icons.lsp_kinds.Constructor.val,
        Enum          = vim.__icons.lsp_kinds.Enum.val,
        EnumMember    = vim.__icons.lsp_kinds.EnumMember.val,
        Event         = vim.__icons.lsp_kinds.Event.val,
        Field         = vim.__icons.lsp_kinds.Field.val,
        File          = vim.__icons.lsp_kinds.File.val,
        Function      = vim.__icons.lsp_kinds.Function.val,
        Interface     = vim.__icons.lsp_kinds.Interface.val,
        Key           = vim.__icons.lsp_kinds.Key.val,
        Method        = vim.__icons.lsp_kinds.Method.val,
        Module        = vim.__icons.lsp_kinds.Module.val,
        Namespace     = vim.__icons.lsp_kinds.Namespace.val,
        Null          = vim.__icons.lsp_kinds.Null.val,
        Number        = vim.__icons.lsp_kinds.Number.val,
        Object        = vim.__icons.lsp_kinds.Object.val,
        Operator      = vim.__icons.lsp_kinds.Operator.val,
        Package       = vim.__icons.lsp_kinds.Package.val,
        Property      = vim.__icons.lsp_kinds.Property.val,
        String        = vim.__icons.lsp_kinds.String.val,
        Struct        = vim.__icons.lsp_kinds.Struct.val,
        TypeParameter = vim.__icons.lsp_kinds.TypeParameter.val,
        Variable      = vim.__icons.lsp_kinds.Variable.val,
      },
    },
  })
end

return M

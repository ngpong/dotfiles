local M = {
  types = {
    -- native
    BUFFER_READ = 1,
    VIM_ENTER = 2,
    BUFFER_ENTER = 3,
    BUFFER_WIN_ENTER = 4,
    BUFFER_READ_POST = 5,
    BUFFER_ADD = 6,
    BUFFER_DELETE = 7,
    FILE_TYPE = 8,
    WIN_CLOSED = 9,
    BUFFER_ENTER_ONCE = 10,
    VIM_LEAVE_PRE = 11,
    VIM_LEAVE = 12,
    CURSOR_NORMAL = 13,
    VIM_EXIT_PRE = 14,
    UI_ENTER = 15,
    COLOR_SCHEME = 16,
    PRESS_QUIT = 17,

    -- explore tree
    -- SETUP_NEOTREE = 20,
    -- OPEN_NEOTREE = 21,
    -- FREE_NEOTREE = 22,
    SETUP_NVIMTREE = 20,
    OPEN_NVIMTREE = 21,
    FREE_NVIMTREE = 22,

    -- buffer
    -- NOTE: 目前这些事件好像没啥用
    -- CYCLE_NEXT_BUFFER = 30,
    -- CYCLE_PREV_BUFFER = 31,
    -- SELECT_TARGET_BUFFER = 32,

    -- neoscroll
    -- SETUP_NEOSCROLL = 35,

    -- gitsigns
    ATTACH_GITSIGNS = 41,
    GITSIGNS_OPEN_POPUP = 42,

    -- telescope
    SETUP_TELESCOPE = 46,
    TELESCOPE_PREVIEW_LOAD = 47,
    TELESCOPE_LOAD = 48,

    -- trouble
    CREATE_TROUBLE_LIST = 55,
    CLOSED_TROUBLE_LIST = 56,

    -- cmp
    SETUP_CMP = 60,

    -- LSP
    ATTACH_LSP = 70,
    DETACH_LSP = 71,

    -- nvim navic
    ATTACH_NAVIC = 80,
    DETACH_NAVIC = 81,

    -- which-key
    SETUP_WHICHKEY = 90,

    -- multicursors
    SETUP_MULTICURSORS = 100,

    -- dressing
    OPEN_DRESSING_INPUT = 110,

    -- fzflua
    SETUP_FZFLUA = 120,
    FZFLUA_PREVIEW_LOAD = 121,
    FZFLUA_LOAD = 122,
  }
}

local EventHandler = vim.__class.def(function(this)
  local id, proc, slot

  function this:__init(_id, _proc, _slot, etype)
    id = _id
    proc = _proc
    slot = _slot
  end

  function this:off()
    slot[id] = nil
  end

  function this:run(...)
    proc(..., this)
  end
end)

local EventManager = vim.__class.def(function(this)
  local cb_slots, id_generator = {}, 0

  function this:push(etype, fn)
    local slot = cb_slots[etype]
    if not slot then
      slot = {}
      cb_slots[etype] = slot
    end

    id_generator = id_generator + 1

    slot[id_generator] = EventHandler:new(id_generator, fn, slot, etype)
  end

  function this:pop(etype, id)
    local slot = cb_slots[etype]
    if slot then
      slot[id] = nil
    end
  end

  function this:ref()
    return cb_slots
  end
end)
local manager = EventManager:new()

function M.rg(etype, fn)
  if type(etype) == "table" then
    for _, t in ipairs(etype) do
      manager:push(t, fn)
    end
  else
    manager:push(etype, fn)
  end
end

function M.emit(etype, ...)
  local handlers = manager:ref()

  local success = true
  for _, h in pairs(handlers[etype] or {}) do
    local status, res = pcall(h.run, h, ...)
    if not status then
      success = false
      if vim.__notifier then vim.__notifier.err("execute event error, please check log file for more information.") end
      vim.__logger.error(res, debug.traceback())
    end
  end

  return success
end

local function setup_extra_event_trigger()
  for _, spec in ipairs({
    { "BufReadPost", M.types.BUFFER_READ_POST },
    { "FileType", M.types.FILE_TYPE },
    { "VimEnter", M.types.VIM_ENTER },
    { "VimLeavePre", M.types.VIM_LEAVE_PRE },
    { "VimLeave", M.types.VIM_LEAVE },
    { "ExitPre", M.types.VIM_EXIT_PRE },
    { "BufNew", M.types.BUFFER_READ },
    { "BufEnter", M.types.BUFFER_ENTER },
    { "BufWinEnter", M.types.BUFFER_WIN_ENTER },
    { "BufAdd", M.types.BUFFER_ADD },
    { "BufDelete", M.types.BUFFER_DELETE },
    { "BufWipeout", M.types.BUFFER_DELETE },
    { "WinClosed", M.types.WIN_CLOSED },
    { { "CursorMoved", "InsertLeave", "CursorHold" }, M.types.CURSOR_NORMAL },
    { "UIEnter", M.types.UI_ENTER },
    { "ColorScheme", M.types.COLOR_SCHEME },
  }) do
    vim.__autocmd.on(spec[1], function(args) M.emit(spec[2], args) end)
  end

  M.rg(M.types.VIM_ENTER, function()
    -- 只触发一次的 BUFFER_ENTER event
    local bufnrs = {}
    M.rg(M.types.BUFFER_ENTER, function(state)
      if bufnrs[state.buf] then
        return
      end

      bufnrs[state.buf] = true

      M.emit(M.types.BUFFER_ENTER_ONCE, state)
    end)
    M.rg(M.types.BUFFER_DELETE, function(state)
      bufnrs[state.buf] = nil
    end)

    -- 由于 VIM_ENTER 的时候不会触发 BUFFER_ENTER，所以手动触发一次
    M.emit(M.types.BUFFER_ENTER, { buf = vim.__buf.current() })
  end)

  for _, spec in ipairs({
    { "LspAttach", M.types.ATTACH_LSP },
    { "LspDetach", M.types.DETACH_LSP },
  }) do
    vim.__autocmd.on(spec[1], function(args)
      M.emit(spec[2], { cli = vim.lsp.get_client_by_id(args.data.client_id), bufnr = args.buf })
    end)
  end
end
setup_extra_event_trigger()

return M
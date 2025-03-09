local Item      = vim.__lazy.require("trouble.item")
local Cache     = vim.__lazy.require("trouble.cache")
local LspSource = vim.__lazy.require("trouble.sources.lsp")

local M = {}

M.config = {
  modes = {
    lsp_document_symbols_extra = {
      desc = "Lsp document symbols",
      source = "lsp.document_symbols",
      follow = true,
      win = { position = "right", size = 0.4 },
      events = {
        "BufEnter",
        { event = "TextChanged", main = true },
        { event = "CursorMoved", main = true },
        { event = "LspAttach", main = true },
      },
      focus = false,
      preview = {
        type = "main",
        scratch = true,
      },
      sort = { "filename", "pos", "text" },
      format = "{kind_icon} {symbol.name} {text:Comment} {pos}",
    },
  },
}

function M.setup()
  LspSource.get.document_symbols = function(cb)
    local buf = vim.__buf.current()

    local cache = Cache.symbols[buf]
    if cache and next(cache) then
      return cb(cache)
    end

    local params = { textDocument = vim.lsp.util.make_text_document_params() }
    LspSource.request("textDocument/documentSymbol", params):next(function(results)
      if vim.tbl_isempty(results) then
        return cb({})
      end
      if not vim.__buf.is_valid(buf) then
        return
      end

      local items = {}
      for _, res in ipairs(results) do
        vim.list_extend(items, LspSource.results_to_items(res.client, res.result, params.textDocument.uri))
      end

      for _, item in ipairs(items) do
        item.text = vim.__str.trim(vim.__fs.getline(buf, item.pos[1], ""))
      end

      if next(items) then
        Cache.symbols[buf] = items
      end

      cb(items)
    end)
  end
end

return M

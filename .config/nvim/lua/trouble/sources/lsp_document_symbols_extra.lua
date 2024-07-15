-- stylua: ignore start
local Icons     = require('ngpong.utils.icon')
local Lazy      = require('ngpong.utils.lazy')
local libP      = require('ngpong.common.libp')
local Item      = Lazy.require('trouble.item')
local Cache     = Lazy.require("trouble.cache")
local LspSource = Lazy.require('trouble.sources.lsp')

local colors = Plgs.colorscheme.colors
-- stylua: ignore end

local M = {}

M.config = {
  modes = {
    lsp_document_symbols_extra = {
      desc = 'Lsp document symbols',
      source = 'lsp.document_symbols',
      follow = true,
      win = { position = 'right', size = 0.4 },
      events = {
        'BufEnter',
        { event = 'TextChanged', main = true },
        { event = 'CursorMoved', main = true },
        { event = 'LspAttach', main = true },
      },
      focus = false,
      preview = {
        type = 'main',
        scratch = true,
      },
      sort = { 'filename', 'pos', 'text' },
      format = '{kind_icon} {symbol.name} {text:Comment} {pos}',
      -- title =  '{filename} {count}',
      -- groups = {},
    },
  },
}

M.setup = function()
  LspSource.get.document_symbols = function(cb)
    local buf = vim.api.nvim_get_current_buf()
    local ret = Cache.symbols[buf]

    if ret then
      return cb(ret)
    end

    local params = { textDocument = vim.lsp.util.make_text_document_params() }

    LspSource.request('textDocument/documentSymbol', params):next(function(results)
      if vim.tbl_isempty(results) then
        return cb({})
      end
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end

      local items = {}
      for _, res in ipairs(results) do
        vim.list_extend(items, LspSource.results_to_items(res.client, res.result, params.textDocument.uri))
      end

      for _, item in ipairs(items) do
        item.text = Helper.strim(Helper.getline(buf, item.pos[1]))
      end

      -- Item.add_text(items, { mode = 'after' })

      if next(items) then
        Cache.symbols[buf] = items
      end

      cb(items)
    end)
  end
end

return M

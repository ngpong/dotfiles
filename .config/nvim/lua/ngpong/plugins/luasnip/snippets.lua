local M = {}

local Lazy     = require('ngpong.utils.lazy')
local Engine   = Lazy.require('luasnip')
local Snippets = Lazy.require('luasnip.loaders.from_vscode')

local S        = Lazy.access('luasnip', 'snippet')
local T        = Lazy.access('luasnip', 'text_node')
local I        = Lazy.access('luasnip', 'insert_node')
local F        = Lazy.access('luasnip', 'function_node')
local P        = Lazy.access('luasnip.extras', 'partial')
local PF       = Lazy.access('luasnip.extras.postfix', 'postfix')

M.setup = function()
  -- custom snippets
  Snippets.lazy_load {
    paths  = './snippets',
    exclude = { 'lua' }, -- luals 不支持禁用内置 snippets，为了使完成更加存粹，禁用掉这里的
  }

  -- snippets write by lua
  Engine.add_snippets('all', {
    S('$YEAR', {
      P(os.date, '%Y')
    }),

    S({ trig = 'trigger_test_test', name = 'hello,world' }, {
      T({'After expanding, the cursor is here ->'}), I(1),
      T({'', 'After jumping forward once, cursor is here ->'}), I(2),
      T({'', 'After jumping once more, the snippet is exited there ->'}), I(0),
    }),

    PF('.br', {
      F(function(_, parent)
        return '[' .. (parent.snippet.env.POSTFIX_MATCH or '') .. ']'
      end, {}),
    }),

    PF('.log', {
      F(function(_, parent)
        return 'log << ' .. (parent.snippet.env.POSTFIX_MATCH or '')
      end, {}),
    }),
  })
  Engine.add_snippets('cpp', {
    Engine.parser.parse_snippet(
      { trig = 'bmk', name = 'Benchmark Template.', desc = 'Google benchmark template for a tiny cpp program' },
      "#include <benchmark/benchmark.h>\n\nvoid foo(benchmark::State& state) {\n\tfor (auto _: state) {}\n}\nBENCHMARK(foo);\n\nBENCHMARK_MAIN();"
    )
  })
end

return M

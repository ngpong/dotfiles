local M = {}

local lazy     = require('ngpong.utils.lazy')
local engine   = lazy.require('luasnip')
local snippets = lazy.require('luasnip.loaders.from_vscode')

local s       = lazy.access('luasnip', 'snippet')
local t       = lazy.access('luasnip', 'text_node')
local i       = lazy.access('luasnip', 'insert_node')
local f       = lazy.access('luasnip', 'function_node')
local p       = lazy.access('luasnip.extras', 'partial')
local postfix = lazy.access('luasnip.extras.postfix', 'postfix')

M.setup = function()
  -- vscode snippets
  snippets.lazy_load {
    exclude = { 'lua' }, -- luals 不支持禁用内置 snippets，为了使完成更加存粹，禁用掉这里的
  }

  -- snippets write by lua
  engine.add_snippets('all', {
    s('$YEAR', {
      p(os.date, '%Y')
    }),

    s({ trig = 'trigger_test_test', name = 'hello,world' }, {
      t({'After expanding, the cursor is here ->'}), i(1),
      t({'', 'After jumping forward once, cursor is here ->'}), i(2),
      t({'', 'After jumping once more, the snippet is exited there ->'}), i(0),
    }),

    postfix('.br', {
      f(function(_, parent)
        return '[' .. (parent.snippet.env.POSTFIX_MATCH or '') .. ']'
      end, {}),
    }),

    postfix('.log', {
      f(function(_, parent)
        return 'log << ' .. (parent.snippet.env.POSTFIX_MATCH or '')
      end, {}),
    }),
  })
  engine.add_snippets('cpp', {
    engine.parser.parse_snippet(
      { trig = 'bmk', name = 'Benchmark Template.', desc = 'Google benchmark template for a tiny cpp program' },
      "#include <benchmark/benchmark.h>\n\nvoid foo(benchmark::State& state) {\n\tfor (auto _: state) {}\n}\nBENCHMARK(foo);\n\nBENCHMARK_MAIN();"
    )
  })
end

return M

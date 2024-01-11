local M = {}

local ls         = require('luasnip')
local ls_extras  = require('luasnip.extras')
local ls_postfix = require('luasnip.extras.postfix')

local s       = ls.snippet
local t       = ls.text_node
local i       = ls.insert_node
local f       = ls.function_node
local p       = ls_extras.partial
local postfix = ls_postfix.postfix

M.setup = function()
  -- vscode snippets
  require('luasnip.loaders.from_vscode').lazy_load {
    exclude = { 'lua' }, -- luals 不支持禁用内置 snippets，为了使完成更加存粹，禁用掉这里的
  }

  -- snippets write by lua
  ls.add_snippets('all', {
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
  ls.add_snippets('cpp', {
    ls.parser.parse_snippet(
      { trig = 'bmk', name = 'Benchmark Template.', desc = 'Google benchmark template for a tiny cpp program' },
      "#include <benchmark/benchmark.h>\n\nvoid foo(benchmark::State& state) {\n\tfor (auto _: state) {}\n}\nBENCHMARK(foo);\n\nBENCHMARK_MAIN();"
    )
  })
end

return M

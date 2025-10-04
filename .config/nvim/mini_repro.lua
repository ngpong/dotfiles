local root = vim.fn.fnamemodify("./.repro", ":p")

for _, name in ipairs({ "config", "data", "state", "cache" }) do
  vim.env[("XDG_%s_HOME"):format(name:upper())] = root .. "/" .. name
end

local lazypath = root .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

local plugins = {
  -- "williamboman/mason-lspconfig.nvim",
  -- {
  --   "williamboman/mason.nvim",
  --   opts = {
  --     pip = {
  --       upgrade_pip = false,
  --       install_args = { "--proxy", "http://127.0.0.1:7890" },
  --     },
  --   },
  --   config = function(_, opts)
  --     require("mason").setup(opts)
  --     require("mason-lspconfig").setup()
  --
  --     local mr = require("mason-registry")
  --     mr:on("package:install:success", vim.schedule_wrap(function(p)
  --       vim.defer_fn(function()
  --         require("lazy.core.handler.event").trigger({
  --           event = "FileType",
  --           buf = vim.api.nvim_get_current_buf(),
  --         })
  --       end, 100)
  --     end))
  --     mr.update(function()
  --       mr.get_package("clangd"):install()
  --     end)
  --   end
  -- },
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     require("lspconfig").clangd.setup({
  --       capabilities = vim.tbl_deep_extend(
  --         "force",
  --         vim.lsp.protocol.make_client_capabilities(),
  --         {
  --           textDocument = {
  --             completion = {
  --               completionItem = {
  --                 snippetSupport = false
  --               }
  --             }
  --           }
  --         }
  --       )
  --     })
  --   end
  -- },
  -- {
  --   "saghen/blink.cmp",
  --   main = "blink-cmp",
  --   dependencies = {
  --     "nvim-mini/mini.snippets",
  --   },
  --   build = "cargo build --release",
  --   opts = {
  --     snippets = {
  --       preset = "mini_snippets"
  --     },
  --     keymap = {
  --       preset = "none",
  --       ["<C-g>"] = { "show_documentation", "hide_documentation" },
  --       ["<C-S-G>"] = { "show_signature", "hide_signature" },
  --       ["<C-f>"] = { "scroll_documentation_down" },
  --       ["<C-s>"] = { "scroll_documentation_up" },
  --       ["<Tab>"] = { "accept", "snippet_forward", "fallback" },
  --       ["<S-TAB>"] = { "snippet_backward", "fallback" },
  --       ["<A-SPACE>"] = { "show", "hide" },
  --       ["<C-c>"] = {
  --         function()
  --           if not MiniSnippets.session.get() then
  --             return false
  --           end
  --
  --           vim.schedule(function()
  --             while MiniSnippets.session.get() do
  --               MiniSnippets.session.stop()
  --             end
  --           end)
  --           return true
  --         end,
  --         "fallback"
  --       },
  --       ["<C-p>"] = { "select_prev" },
  --       ["<C-n>"] = { "select_next" },
  --     },
  --     completion = {
  --       accept = {
  --         dot_repeat = true,
  --         auto_brackets = {
  --           enabled = false
  --         }
  --       },
  --     },
  --   },
  -- },
  -- {
  --   "nvim-mini/mini.snippets",
  --   main = "mini.snippets",
  --   dependencies = {
  --     "rafamadriz/friendly-snippets",
  --   },
  --   opts = {
  --     mappings = {
  --       expand = "",
  --       jump_next = "",
  --       jump_prev = "",
  --       stop = "",
  --     },
  --     variables = {},
  --     empty_tabstop_final = "•", -- ∎
  --     empty_tabstop = "", -- •
  --     wrap_jump = false,
  --   },
  --   config = function(_, opts)
  --     local gen_loader = require("mini.snippets").gen_loader
  --     require("mini.snippets").setup({
  --       snippets = {
  --         -- friendly-snippets
  --         gen_loader.from_lang(),
  --       },
  --       mappings = opts.mappings,
  --       expand = {
  --         insert = function(snippet)
  --           return MiniSnippets.default_insert(snippet, {
  --             lookup = opts.variables,
  --             empty_tabstop = opts.empty_tabstop,
  --             empty_tabstop_final = opts.empty_tabstop_final,
  --           })
  --         end
  --       }
  --     })
  --   end,
  -- },

  {
    "nvimdev/indentmini.nvim",
    opts = {
      char = "▏",
      -- exclude = vim.__filter.filetypes[1]
    }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    opts = {
      ensure_install = { "cpp" },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          vim.treesitter.start(args.buf)
        end
      })
    end,
  }
}
require("lazy").setup(plugins, {
  root = root .. "/plugins",
})

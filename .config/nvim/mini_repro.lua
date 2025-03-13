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
  "ellisonleao/gruvbox.nvim",
  "williamboman/mason-lspconfig.nvim",
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_install = {
        { parse = "cpp", ft = "cpp" },
        { parse = "c", ft = "c" },
        { parse = "lua", ft = "lua" }
      },
      ignore_install = {},
    },
    config = function(_, opts)
      local ensure_parse    = {}
      local ensure_filetype = {}
      for _, v in ipairs(opts.ensure_install) do
        local parse
        local fts

        if type(v) == "table" then
          parse = v.parse
          fts = type(v.ft) == "string" and { v.ft } or v.ft
        else
          parse = v
          fts = { v }
        end

        table.insert(ensure_parse, parse)
        for _, ft in ipairs(fts) do
          table.insert(ensure_filetype, ft)
        end
        vim.treesitter.language.register(parse, fts)
      end

      opts.ensure_install = ensure_parse
      require("nvim-treesitter").setup(opts)
      -- enhance tinyd performance?
      -- https://www.reddit.com/r/neovim/comments/1144spy/will_treesitter_ever_be_stable_on_big_files/

      -- treesitter highlight
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local bufnr = args.buf
          local ft    = args.match
  
          vim.treesitter.start(bufnr, vim.treesitter.language.get_lang(ft))
        end,
        pattern = ensure_filetype
      })
    end,
  },
  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        enabled = true,
        indent = {
          enabled = true,
          only_scope = false,
          only_current = false,
          hl = "IndentGuide",
        },
        animate = {
          enabled = false,
        },
        scope = {
          enabled = false,
        },
        chunk = {
          enabled = false,
        },
      },
    }
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    opts = {
      select = {
        lookahead = true,
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          ['@class.outer'] = '<c-v>', -- blockwise
        },
        include_surrounding_whitespace = false,
      }
    }
  },
  {
    "williamboman/mason.nvim",
    opts = {
      pip = {
        upgrade_pip = false,
        install_args = { "--proxy", "http://127.0.0.1:7890" },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      require("mason-lspconfig").setup()

      local mr = require("mason-registry")
      mr:on("package:install:success", vim.schedule_wrap(function(p)
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end))
      mr.update(function()
        mr.get_package("clangd"):install()
      end)
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").clangd.setup({
        capabilities = vim.tbl_deep_extend(
          "force",
          vim.lsp.protocol.make_client_capabilities(),
          require("blink.cmp").get_lsp_capabilities(),
          {
            textDocument = {
              completion = {
                completionItem = {
                  snippetSupport = false
                }
              }
            }
          }
        )
      })
    end
  },
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    opts = {
    }
  },
}
require("lazy").setup(plugins, {
  root = root .. "/plugins",
})

-- add anything else here
vim.opt.termguicolors = true
-- do not remove the colorscheme!
vim.cmd([[colorscheme gruvbox]])
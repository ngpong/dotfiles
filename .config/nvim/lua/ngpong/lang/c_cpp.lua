return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_install = { "cpp", "c" }
    }
  },
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "clang-format" } }
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    dependencies = {
      "p00f/clangd_extensions.nvim",
    },
    opts = {
      servers = {
        clangd = {
          enabled = true,
          keys = {
            { "<leader>lh", "<CMD>ClangdTypeHierarchy<CR>", silent = true },
            { "<leader>lm", "<CMD>ClangdMemoryUsage<CR>", silent = true },
            { "<leader>la", "<CMD>ClangdAST<CR>", silent = true },
            { "gs", "<CMD>ClangdSwitchSourceHeader<CR>", silent = true },
          },
          cmd = {
            "clangd",
            "-j=16",
            "--clang-tidy",
            "--background-index",
            "--background-index-priority=normal",
            "--ranking-model=decision_forest",
            "--completion-style=bundled",
            "--header-insertion=never", -- iwyu
            "--header-insertion-decorators=false",
            "--pch-storage=memory",
            "--limit-references=0",
            "--rename-file-limit=0",
            -- "--limit-results=30",
            -- "--compile-commands-dir=/home/ngpong/code/cpp/CPP-Study-02/TEST/TEST_93/",
            -- "--log=verbose",
          },
          single_file_support = true,
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "tcc" },
          capabilities = {
            offsetEncoding = { "utf-16" },
            textDocument = {
              completion = {
                completionItem = {
                  snippetSupport = false
                }
              }
            },
          },
          on_attach = function()
            -- require("clangd_extensions.inlay_hints").setup_autocmd()
            -- require("clangd_extensions.inlay_hints").set_inlay_hints()
          end
        },
        ccls = {
          enabled = false,
          mason_install = false,
          init_options = {
            cache = {
              directory = ".ccls-cache";
            };
          },
          single_file_support = true,
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "tcc" },
          capabilities = {
            offsetEncoding = { "utf-16" },
            textDocument = {
              completion = {
                completionItem = {
                  snippetSupport = true
                }
              }
            },
          },
        },
      },
    },
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    opts = {
      inlay_hints = {
        inline = vim.fn.has("nvim-0.10") == 1,
        only_current_line = false,
        only_current_line_autocmd = { "CursorHold" },
        show_parameter_hints = true,
        parameter_hints_prefix = "<- ",
        other_hints_prefix = "=> ",
        max_len_align = false,
        max_len_align_padding = 1,
        right_align = false,
        right_align_padding = 7,
        highlight = "Comment",
        priority = 100,
      },
      ast = {
        role_icons = {
          type = vim.__icons.lsp_kinds.Type.val,
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
        highlights = {
          detail = "Comment",
        },
      },
      memory_usage = {
        border = "rounded",
      },
      symbol_info = {
        border = "rounded",
      },
    },
  },
}